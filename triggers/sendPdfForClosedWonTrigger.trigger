/**
*   Created By  :   Joey Ho
*   Description :   This Trigger calls @future method to send VF page rendered as PDF as attachment in Email 
*   Note        :   Make sure that this Trigger does not call Future methods more than 10 times.
*/

trigger sendPdfForClosedWonTrigger on Opportunity(before update) {
    
    //Get the values of Engagement Type in Opportunity object and set out the Map
    Schema.DescribeFieldResult fieldResult = Opportunity.Engagement_Type__c.getDescribe();
    List<Schema.PicklistEntry> engageType = fieldResult.getPicklistValues();
    
    map<string,list<string>> engage2EmailMap = new map<string,list<string>>();
    for(Schema.PicklistEntry sp:engageType){
        engage2EmailMap.put(sp.getValue(),new list<string>());
    }
    
    
    //Get all Users that require notification and add to the right Map of Engagement Type 
    list<User> users = [SELECT email, Engagement_Type_Notifications__c FROM User WHERE isActive = true AND (UserType = 'Standard' OR UserType = 'CsnOnly' OR Id =: UserInfo.getUserId()) AND Notify_Closed_Won_Opportunities__c = true];
    for(User u:users){
        String[] types = u.Engagement_Type_Notifications__c.split(';');
        for(string t:types){
            if(engage2EmailMap.containsKey(t)){
                engage2EmailMap.get(t).add(u.email);
            }
        }            
    }
    
    //Check if opportunity is Closed Won and needs to be notified only if VF_Closed_Won__c is false
    //Send notification to respective reciepients for records that meet criteria
    for(Opportunity opp:trigger.new){
        if(opp.IsClosed == true && opp.IsWon == true){
            if(opp.VF_Closed_Won__c == true && opp.VF_Closed_Won_Notification_Sent__c == false && engage2EmailMap.containsKey(opp.Engagement_Type__c)){                
                string oppId = string.valueOf(opp.Id);
                string toAddress = string.join(engage2EmailMap.get(opp.Engagement_Type__c),',');   
                string subj = 'Closed/Won Opportunity Alert - ' + opp.Engagement_Type__c + ' Engagement Type ';
                string body = 'Please find attached details of a new sale under the ' + opp.Engagement_Type__c + ' category';
                //Send PDF notifcation
                if(!Test.isRunningTest() && SendVFAsAttachment.inSendVF == false){                    	
                    SendVFAsAttachment.sendVF(toAddress,subj,body,oppId,UserInfo.getSessionId());
                }
                //Mark as sent
                opp.VF_Closed_Won__c = false;
                opp.VF_Closed_Won_Notification_Sent__c = true;
            }
        }
    }
   /* }else{
        //Notify error in trigger to avoid limits
        //https://developer.salesforce.com/page/An_Introduction_to_Exception_Handling
        list<User> admins = [SELECT email FROM User WHERE isActive = true AND UserType = 'Standard' AND Notify_Custom_Apex_Erros__c = true];
        list<string> emails = new list<string>{};
        for(User a:admins){
            emails.add(a.email);
        }
        
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        mail.setToAddresses(emails);
        mail.setReplyTo('noreply@best-ite.com');
        mail.setSenderDisplayName('Apex Error Notification');
        mail.setSubject('Error from sendPdfForClosedWonTrigger');
        mail.setPlainTextBody('Error from sendPdfForClosedWonTrigger : Too many Closed/Won Opportunties : Total ' + trigger.new.size());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    }
	*/
}