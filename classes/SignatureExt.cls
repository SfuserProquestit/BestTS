global class SignatureExt {
    global ServiceAppointment sa ;
    global SignatureExt(ApexPages.StandardController stdController){
        sa = (ServiceAppointment)stdController.getRecord();
        sa.Status = Constants.SERVICE_STATUS_CAPTURE_SIGN;
    }
 
    @RemoteAction
    global static String uploadSignature(String b64SignData, String id, String callingForm){
        returnData ret = new returnData();
        ret.success = true;
        ret.message = 'Signature uploaded successfully';
        try{
            List<ServiceAppointment> serviceAppointment = ServiceAppointmentDAO.getSerAppointmentsById(new Set<Id>{id});
            Blob signature = EncodingUtil.base64Decode(b64SignData);
            Attachment att = new Attachment();
            att.body = signature;
            att.ContentType = 'image/png';
            att.name = callingForm+'_'+UserInfo.getName()+'_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss');
            att.IsPrivate = false;
            att.ParentId = serviceAppointment[0].ParentRecordId;
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