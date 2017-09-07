@isTest
private class ChangeStatusControllerExtensionTest {
    @isTest
    static void testChangeStatus(){

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(childWorkOrders[0]);
        ChangeStatusControllerExtension ctrlExt = new ChangeStatusControllerExtension(sc);
        List<String> nexStatusSelected = ctrlExt.getNextStatusSelected(childWorkOrders[0].status);

        ctrlExt.woStatus='Assigned';
        ctrlExt.updateWorkOrderStatus();
        childWorkOrders = [SELECT Id, Status FROM WorkOrder WHERE Id = :childWorkOrders[0].Id];
        System.assertEquals('Assigned', childWorkOrders[0].Status);

        ctrlExt.woStatus='Capture Signature';
        ctrlExt.updateWorkOrderStatus();

        Test.stopTest();
    }
}