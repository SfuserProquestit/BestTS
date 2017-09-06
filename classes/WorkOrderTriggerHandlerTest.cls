@isTest
public class WorkOrderTriggerHandlerTest {
    
    static testMethod void testPreventInvoicedWODeletion() {
        List<Account> accounts = TestUtility.createAccounts(2);
        insert accounts;

        List<CKSW_BASE__Service_Type__c> serviceTypes = TestUtility.createServiceTypes(2);
        insert serviceTypes;

        List<WorkOrder> workorders = TestUtility.createWorkOrders(accounts.get(0), Constants.RECORD_TYPE_MASTER_WORK_ORDER, 2);
        insert workorders;

        Test.startTest();
            // allow delete
            delete workorders.get(0);
            
            //workorders.get(1).Invoice_Created__c = true;
            // don't allow delete
            try {
                delete workorders.get(1);
            } catch(Exception exp) {
                //System.assert(exp.getMessage().contains(Label.CannotDeleteWO));
            }
        
        Test.stopTest();

        
    }

    @isTest(seeAllData=true)
    static void testUpdateSAStatus(){

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        List<ServiceAppointment> serviceAppointments = TestUtility.createServiceAppointments(new Map<Id,WorkOrder>(childWorkOrders).keySet(),1);
        insert serviceAppointments;

        Test.startTest();

        for(WorkOrder workOrder : childWorkOrders){
            workOrder.Status=Constants.WORK_ORDER_STATUS_ASSIGNED;
        }
        update childWorkOrders;

        Test.stopTest();

        Set<Id> serviceAppointmentIds = new Map<Id,ServiceAppointment>(serviceAppointments).keySet();
        serviceAppointments = [SELECT Status FROM ServiceAppointment WHERE Id IN :serviceAppointmentIds];
        for(ServiceAppointment sa : serviceAppointments){
            System.assertEquals(Constants.SERVICE_APPOINTMENT_STATUS_ASSIGNED, sa.Status);
        }
    }

    @isTest
    static void testUpdateParentWorkOrderStatus(){

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        Test.startTest();

        for(WorkOrder workOrder : childWorkOrders){
            workOrder.Status=Constants.WORK_ORDER_STATUS_COMPLETED;
        }
        update childWorkOrders;

        Test.stopTest();

        Set<Id> workOrderIds = new Map<Id,WorkOrder>(parentWorkOrders).keySet();
        parentWorkOrders = [SELECT Status FROM WorkOrder WHERE Id IN :workOrderIds];
        for(WorkOrder wo : parentWorkOrders){
            System.assertEquals(Constants.WORK_ORDER_STATUS_COMPLETED, wo.Status);
        }
    }

    @isTest
    static void testCreateParentWorkOrderSharing(){

        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);
        List<ServiceResource> serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        insert serviceResources;

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        Test.startTest();
            childWorkOrders[0].Service_Resource__c = serviceResources[0].Id;
            childWorkOrders[1].Service_Resource__c = serviceResources[1].Id;
            update childWorkOrders;
        Test.stopTest();

        Set<Id> userIds = new Set<Id>();
        for(ServiceResource sr : serviceResources){
            userIds.add(sr.RelatedRecordId);
        }

        List<WorkOrderShare> workOrderShare = [SELECT Id FROM WorkOrderShare WHERE ParentId = :parentWorkOrders[0].Id AND UserOrGroupId IN :userIds];
        System.assertEquals(2,workOrderShare.size(), 'WorkOrderShare not created as expected');
    }

    @isTest
    static void testDeleteWorkOrderSharing(){

        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);
        List<ServiceResource> serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        insert serviceResources;

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        childWorkOrders[0].Service_Resource__c = serviceResources[0].Id;
        childWorkOrders[1].Service_Resource__c = serviceResources[1].Id;
        update childWorkOrders;
        
        Test.startTest();
            childWorkOrders[0].Service_Resource__c = null;
            childWorkOrders[1].Service_Resource__c = null;
            update childWorkOrders;
        Test.stopTest();

        Set<Id> userIds = new Set<Id>();
        for(ServiceResource sr : serviceResources){
            userIds.add(sr.RelatedRecordId);
        }

        List<WorkOrderShare> workOrderShare = [SELECT Id FROM WorkOrderShare WHERE ParentId = :parentWorkOrders[0].Id AND UserOrGroupId IN :userIds];
        System.assertEquals(0,workOrderShare.size(), 'WorkOrderShare not deleted as expected');
    }

    @isTest
    static void testCreateParentWorkOrderSharingOnOwnerChange(){

        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);
        List<ServiceResource> serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        insert serviceResources;

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        childWorkOrders[0].Service_Resource__c = serviceResources[0].Id;
        childWorkOrders[1].Service_Resource__c = serviceResources[1].Id;
        update childWorkOrders;

        Test.startTest();
            User sysAdmin = [SELECT Id FROM User WHERE Profile.Name='System Administrator' AND UserRoleId != null AND IsActive = true LIMIT 1][0];
            parentWorkOrders[0].OwnerId= sysAdmin.Id;
            update parentWorkOrders[0];
        Test.stopTest();

        Set<Id> userIds = new Set<Id>();
        for(ServiceResource sr : serviceResources){
            userIds.add(sr.RelatedRecordId);
        }

        List<WorkOrderShare> workOrderShare = [SELECT Id FROM WorkOrderShare WHERE ParentId = :parentWorkOrders[0].Id AND UserOrGroupId IN :userIds];
        System.assertEquals(2,workOrderShare.size(), 'WorkOrderShare not created as expected');
    }

    @isTest
    static void testSetTimeStamps(){
        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;
        
        Test.startTest();
            parentWorkOrders[0].Status = 'Closed';
            update parentWorkOrders[0];
        Test.stopTest();

        parentWorkOrders = [SELECT Closed_On__c FROM WorkOrder WHERE Id = :parentWorkOrders[0].Id];
        System.assertNotEquals(null,parentWorkOrders[0].Closed_On__c);
    }

    @isTest(SeeAllData=true)
    static void testChatterPost(){
        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);
        
        Test.startTest();
            List<Id> techIds = new List<Id>();
            techIds.add(techUsers.get(0).Id);
            List<Id> feedItemIds = ChatterPostForTechnician.createChatterPostForTechnician(techIds);
            System.assertEquals(feedItemIds.size(), 1);
        Test.stopTest();

    }
}