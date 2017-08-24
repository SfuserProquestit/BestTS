global class NCRIncomingEmailHandler implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        if(email.subject.contains('SR:')){

            String srNumber = email.subject.subString(email.subject.indexOf('SR:')+3, email.subject.indexOf('SR:')+13);

            List<WorkOrder> existingWorkOrders =WorkOrderDAO.getWorkOrdersBySRNumber(new List<String>{srNumber});

            Email_Log__c emailLog = new Email_Log__c();
            emailLog.HTML_Message_Received__c = email.htmlBody;
            emailLog.Status__c = Constants.EMAIL_LOG_STATUS_SUCCESS;
            emailLog.Subject__c = email.subject;
            emailLog.PlainText_Message_Received__c = email.plainTextBody;
            emailLog.From_Address__c = email.fromAddress;

            Group errorQueue = QueueDAO.getQueueByDeveloperNames(new List<String>{Constants.QUEUE_FAILED_EMAIL_PARSING})[0];

            if(existingWorkOrders.size()==0){

                try{
                    List<String> parsedEmailBody = parseEmailBody(email.htmlBody);
                    Map<String,String> fieldValueMap = new Map<String,String>();
                    for(String value : parsedEmailBody){
                        List<String> fieldValue = value.split(';');
                        if(fieldValue != null && fieldValue.size()>0){
                            if(fieldValue.size()>1){
                                fieldValueMap.put(fieldValue[0], fieldValue[1]);
                            }
                            else{
                                fieldValueMap.put(fieldValue[0], '');
                            }
                        }
                    }

                    WorkOrder wo = new WorkOrder();
                    CKSW_BASE__Service__c service = new CKSW_BASE__Service__c();
                    
                    setRecordsFromEmail(fieldValueMap,wo,service);

                    String contractNumber = Territory_Contract_Mapping__c.getValues(wo.Customer_Territory_No__c) != null ? Territory_Contract_Mapping__c.getValues(wo.Customer_Territory_No__c).Contract_Number__c : '';
                    List<ServiceContract> contract = ServiceContractDAO.getServiceContractByContractNumber(new List<String>{contractNumber});
                    Id contractId = contract.size()>0 ? contract[0].Id : null;

                    if(contractId != null){

                        Group ncrQueue = QueueDAO.getQueueByDeveloperNames(new List<String>{Constants.QUEUE_NCR_EMAIL})[0];

                        wo.Customer_s_Reference__c = srNumber;
                        wo.ServiceContractId = contractId;
                        wo.AccountId = Email_Service_Settings__c.getOrgDefaults().NCR_Account_Id__c;
                        wo.OwnerId = ncrQueue.Id;

                        if(wo.City__c != null && wo.City__c != '' && wo.City__c.length() >=12){
                            wo.Site_Post_Code__c = wo.City__c.subString(wo.City__c.length()-4,wo.City__c.length());
                            wo.Site_State__c = wo.City__c.subString(wo.City__c.length()-11,wo.City__c.length()-8);
                            wo.City__c = wo.City__c.subString(0,wo.City__c.length()-12);
                        }

                        //The first SLA Record found is set in the work order
                        List<SLA__c> sla = SLADAO.getSLAByServiceContractId(new Set<Id>{contractId});
                        if(sla.size()>0){
                            wo.SLA__c = sla[0].Id;
                        }
                        insert wo;

                        service.Work_Order__c = wo.Id;
                        service.Customer_s_Reference__c = srNumber;
                        service.CKSW_BASE__Account__c = Email_Service_Settings__c.getOrgDefaults().NCR_Account_Id__c;
                        service.Service_Contract__c = contractId;
                        service.OwnerId = ncrQueue.Id;
                        service.CKSW_BASE__City__c = wo.City__c;
                        service.CKSW_BASE__State__c = wo.Site_State__c;
                        service.CKSW_BASE__Zip__c = wo.Site_Post_Code__c;
                        insert service;
                    }
                    else{
                        emailLog.OwnerId = errorQueue.Id;
                        emailLog.Error_Message__c = String.format(Label.No_contract_for_the_territory, new List<String>{wo.Customer_Territory_No__c});
                        emailLog.Status__c = Constants.EMAIL_LOG_STATUS_ERROR;
                    }
                    result.success = true;
                }
                catch(Exception e){
                    emailLog.OwnerId = errorQueue.Id;
                    emailLog.Error_Message__c = e.getTypeName() + ' \n ' + e.getMessage();
                    emailLog.Status__c = Constants.EMAIL_LOG_STATUS_ERROR;
                    result.success = false;
                    result.message = emailLog.Error_Message__c;
                }
            }
            else{
                emailLog.OwnerId = errorQueue.Id;
                emailLog.Error_Message__c = String.format(Label.Duplicate_SR_Number, new List<String>{srNumber, existingWorkOrders[0].WorkOrderNumber});
                emailLog.Status__c = Constants.EMAIL_LOG_STATUS_ERROR;
                result.success = true;
            }

            insert emailLog;

            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf(email.htmlBody);
            attachment.Name = String.valueOf(email.subject+'.html');
            attachment.ParentId = emailLog.Id; 
            insert attachment;
        }
        return result;
    }

    public static String[] parseEmailBody(String source) {
        String src='<!DOCTYPE html [<!ENTITY nbsp " ">]>'+source;
        src=src.replace('<hr>','').replaceAll('<hr.+?>','').replace('<br>','').replace('</br>','').replace('<wbr>','').replaceAll('<img.+?>','').replaceAll('<meta.+?>','').replace('<o:p></o:p>',''); //remove special tags
        System.debug('*********String to Parse **** ' +src);
        String[] values = new String[0];

        XmlStreamReader r = new XmlStreamReader(src);
        Integer retry = 0;
        Boolean inRow = false, inCol = false;
        
        while(r.hasNext() && retry < 5) {
            try {
                r.next();
                retry = 0;
                if(r.getEventType()==xmltag.start_element && r.getLocalName()=='tr') { 
                    values.add('');
                    inRow = true;
                }
                if(r.getEventType()==xmltag.end_element && r.getLocalName()=='tr') {
                    inrow = incol = false;
                }
                if(r.getEventType()==xmltag.start_element && r.getLocalName()=='td') {
                    incol = true;
                }
                if(r.getEventType()==xmltag.end_element && r.getLocalName()=='td') {
                    incol = false;
                    if(!values.isempty())
                        values[values.size()-1]+=';';
                }
                if(inRow && inCol &&r.getEventType()==xmltag.characters) {
                    values[values.size()-1]+=r.gettext().normalizeSpace().removeEnd(' ').removeStart(' ');
                }
            } catch(exception e) {
                retry++;
            }
        }
        System.debug('VALUES => ' + values);
        return values;
    }

    public static void setRecordsFromEmail(Map<String,String> fieldValueMap, WorkOrder wo, CKSW_BASE__Service__c service){
        List<Email_Parsing_Field_Mapping__mdt> fieldMapping = CustomMetadataTypeDAO.getEmailParsingMapping();

        for(String fieldKey : fieldValueMap.keySet()){
            for(Email_Parsing_Field_Mapping__mdt mapping : fieldMapping){
                if(mapping.Email_Field__c == fieldKey){
                    
                    if(mapping.SF_Field_Type__c == Constants.FIELD_TYPE_DATETIME){
                        DateTime fieldDateTime = DateHelper.convertStringToDateTime(fieldValueMap.get(fieldKey));
                        if(mapping.SF_Object_Type__c == Constants.API_OBJECT_NAME_WORK_ORDER){
                            wo.put(mapping.SF_Field__c, fieldDateTime);
                        }
                        else if(mapping.SF_Object_Type__c == Constants.API_OBJECT_NAME_SERVICE){
                            service.put(mapping.SF_Field__c, fieldDateTime);
                        }
                    }
                    else{
                        String fieldString = fieldValueMap.get(fieldKey);
                        if(mapping.SF_Object_Type__c == Constants.API_OBJECT_NAME_WORK_ORDER){
                            wo.put(mapping.SF_Field__c, fieldString);
                        }
                        else if(mapping.SF_Object_Type__c == Constants.API_OBJECT_NAME_SERVICE){
                            service.put(mapping.SF_Field__c, fieldString);
                        }
                    }
                }
            }
        }
    }
}