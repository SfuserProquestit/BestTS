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

        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(childWorkOrders[0]);
        SignatureExt sp = new SignatureExt(sc);
        String result = SignatureExt.uploadSignature('123456',childWorkOrders[0].Id, 'Safety_Induction');
        System.debug('Result is ' + result);
        System.assert(result!=null);

        Test.stopTest();

        List<Attachment> workOrderAttachment = [SELECT Id FROM Attachment WHERE ParentId = :childWorkOrders[0].Id];
        System.assertEquals(1,workOrderAttachment.size(),'Signature attachment not created as expected');
    }
}