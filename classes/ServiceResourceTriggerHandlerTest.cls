@isTest
public class ServiceResourceTriggerHandlerTest {

    @isTest
    static void testCreateParentWorkOrderSharing(){
        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);
        List<ServiceResource> serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        Test.startTest();
            insert serviceResources;
            serviceResources = [SELECT Related_User__c, RelatedRecordId FROM ServiceResource];
            for(ServiceResource sr : serviceResources){
                System.assertEquals(sr.RelatedRecordId,sr.Related_User__c);
            }

            update serviceResources;
            serviceResources = [SELECT Related_User__c, RelatedRecordId FROM ServiceResource];
            for(ServiceResource sr : serviceResources){
                System.assertEquals(sr.RelatedRecordId,sr.Related_User__c);
            }
        Test.stopTest();
    }
}