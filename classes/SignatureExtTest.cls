@isTest
private class SignatureExtTest {
    @isTest
    static void testUploadSignature(){

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        List<ServiceAppointment> serviceAppointments = TestUtility.createServiceAppointments(new Map<Id,WorkOrder>(childWorkOrders).keySet(),1);
        insert serviceAppointments;

        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(serviceAppointments[0]);
        SignatureExt sp = new SignatureExt(sc);
        String result = SignatureExt.uploadSignature('123456',serviceAppointments[0].Id, 'Safety_Induction');
        System.debug('Result is ' + result);
        System.assert(result!=null);

        Test.stopTest();

        List<Attachment> workOrderAttachment = [SELECT Id FROM Attachment WHERE ParentId = :serviceAppointments[0].ParentRecordId];
        System.assertEquals(1,workOrderAttachment.size(),'Signature attachment not created as expected');
    }
}