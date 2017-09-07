global class SignatureExt {
    global WorkOrder wo ;
    global SignatureExt(ApexPages.StandardController stdController){
        wo = (WorkOrder)stdController.getRecord();
        wo.Status = Constants.WORK_ORDER_STATUS_CAPTURE_SIGNATURE;
    }
    
    @RemoteAction
    global static String uploadSignature(String b64SignData, String woId, String callingForm){
        returnData ret = new returnData();
        ret.success = true;
        ret.message = 'Signature uploaded successfully';
        try{
            Blob signature = EncodingUtil.base64Decode(b64SignData);
            Attachment att = new Attachment();
            att.body = signature;
            att.ContentType = 'image/png';
            att.name = callingForm+'_'+UserInfo.getName()+'_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss');
            att.IsPrivate = false;
            att.ParentId = woId;
            insert att;
            WorkOrder theWO = new WorkOrder(Id=woId,Status=Constants.WORK_ORDER_STATUS_CAPTURE_SIGNATURE);
            update theWO;
        }catch(Exception e){
            ret.success = false;
            ret.message = e.getMessage() + e.getStackTraceString() + e.getTypeName();
        }    
        return JSON.serialize(ret);
    }
    
    private class returnData{
        Boolean success {get;set;}
        String message {get;set;}
    }
}