@isTest
private class AssigneResourceTriggerHandlerTest {
    
    @isTest(seeAllData=true)
    static void testSetServiceResourceOnWorkOrder(){

        List<User> techUsers = new List<User>();
        Integer nbTechnicians = 2;
        List<ServiceResource> serviceResources = [SELECT Id FROM ServiceResource WHERE IsActive=true AND ResourceType = :Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH];
        if(serviceResources.size()<nbTechnicians){
            techUsers = TestUtility.createCommunityUserTechnicians(nbTechnicians-serviceResources.size());
            serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        }

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        List<ServiceAppointment> serviceAppointments = TestUtility.createServiceAppointments(new Map<Id,WorkOrder>(childWorkOrders).keySet(),1);
        insert serviceAppointments;

        Test.startTest();

            List<AssignedResource> assignedResources = new List<AssignedResource>();
            assignedResources.add(new AssignedResource( ServiceResourceId = serviceResources[0].Id,
                                                        ServiceAppointmentId = serviceAppointments[0].Id));
            assignedResources.add(new AssignedResource( ServiceResourceId = serviceResources[1].Id,
                                                        ServiceAppointmentId = serviceAppointments[1].Id));
            insert assignedResources;

            assignedResources[0].ServiceResourceId = serviceResources[1].Id;
            update assignedResources[0];

        Test.stopTest();

        Set<Id> childWorkOrderIds = new Set<Id>(new Map<Id,WorkOrder>(childWorkOrders).keySet());
        List<WorkOrder> workOrders = [SELECT Service_Resource__c FROM WorkOrder WHERE Id IN :childWorkOrderIds];
        for(WorkOrder wo : workOrders){
            System.assertEquals(serviceResources[1].Id,wo.Service_Resource__c,'Service Resource not set as expected on Work Order');
        }
    }

    @isTest(seeAllData=true)
    static void testSetServiceResourceOnWorkOrderWhenDelete(){

        List<User> techUsers = new List<User>();
        Integer nbTechnicians = 1;
        List<ServiceResource> serviceResources = [SELECT Id FROM ServiceResource WHERE IsActive=true AND ResourceType = :Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH];
        if(serviceResources.size()<nbTechnicians){
            techUsers = TestUtility.createCommunityUserTechnicians(nbTechnicians-serviceResources.size());
            serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        }

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        List<ServiceAppointment> serviceAppointments = TestUtility.createServiceAppointments(new Map<Id,WorkOrder>(childWorkOrders).keySet(),1);
        insert serviceAppointments;

        List<AssignedResource> assignedResources = new List<AssignedResource>();
        assignedResources.add(new AssignedResource( ServiceResourceId = serviceResources[0].Id,
                                                    ServiceAppointmentId = serviceAppointments[0].Id));
        assignedResources.add(new AssignedResource( ServiceResourceId = serviceResources[1].Id,
                                                    ServiceAppointmentId = serviceAppointments[1].Id));
        insert assignedResources;

        Test.startTest();

            delete assignedResources;

        Test.stopTest();

        Set<Id> childWorkOrderIds = new Set<Id>(new Map<Id,WorkOrder>(childWorkOrders).keySet());
        List<WorkOrder> workOrders = [SELECT Service_Resource__c FROM WorkOrder WHERE Id IN :childWorkOrderIds];
        for(WorkOrder wo : workOrders){
            System.assertEquals(null,wo.Service_Resource__c,'Service Resource not set as expected on Work Order');
        }
    }
}