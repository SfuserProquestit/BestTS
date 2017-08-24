global class SignatureExt {
    global CKSW_BASE__Service__c servc ;
    global SignatureExt(ApexPages.StandardController stdController){
        servc = (CKSW_BASE__Service__c)stdController.getRecord();
        servc.CKSW_BASE__Status__c = Constants.SERVICE_STATUS_CAPTURE_SIGN;
    }
 
    @RemoteAction
    global static String uploadSignature(String b64SignData, String id, String callingForm){
        returnData ret = new returnData();
        ret.success = true;
        ret.message = 'Signature uploaded successfully';
        try{
            
            //CKSW_BASE__Service__c servc = new CKSW_BASE__Service__c(id= id);
            
            //update servc;
            
            Blob signature = EncodingUtil.base64Decode(b64SignData);
            Attachment att = new Attachment();
            att.body = signature;
            att.ContentType = 'image/png';
            att.name = callingForm+'_'+UserInfo.getName()+'_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss');
            att.IsPrivate = false;
            att.ParentId = id;
            insert att;
        }catch(Exception e){
            ret.success = false;
            ret.message = e.getMessage();
        }    
        return JSON.serialize(ret);
    }
    
    private class returnData{
        Boolean success {get;set;}
        String message {get;set;}
    }
}