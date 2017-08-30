@isTest
private class ServiceAppointmentTriggerHandlerTest {

    @isTest(seeAllData=true)
    static void testUpdateWorkOrderStatus(){

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        List<ServiceAppointment> serviceAppointments = TestUtility.createServiceAppointments(new Map<Id,WorkOrder>(childWorkOrders).keySet(),1);
        insert serviceAppointments;

        Test.startTest();

        for(ServiceAppointment sa : serviceAppointments){
            sa.Status=Constants.SERVICE_APPOINTMENT_STATUS_ASSIGNED;
        }
        update serviceAppointments;

        Test.stopTest();

        Set<Id> workOrderIds = new Map<Id,WorkOrder>(childWorkOrders).keySet();
        childWorkOrders = [SELECT Status FROM WorkOrder WHERE Id IN :workOrderIds];
        for(WorkOrder wo : childWorkOrders){
            System.assertEquals(Constants.WORK_ORDER_STATUS_ASSIGNED, wo.Status);
        }
    }

    @isTest
    static void testSetWorkOrderRelationship(){

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        Test.startTest();

        List<ServiceAppointment> serviceAppointments = TestUtility.createServiceAppointments(new Map<Id,WorkOrder>(childWorkOrders).keySet(),1);
        insert serviceAppointments;

        Test.stopTest();

        Set<Id> serviceAppointmentIds = new Map<Id,ServiceAppointment>(serviceAppointments).keySet();
        serviceAppointments = [SELECT ParentRecordId, Work_Order__c FROM ServiceAppointment WHERE Id IN :serviceAppointmentIds];
        for(ServiceAppointment sa : serviceAppointments){
            System.assertEquals(sa.ParentRecordId, sa.Work_Order__c);
        }
    }
}