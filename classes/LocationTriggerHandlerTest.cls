@isTest
public class LocationTriggerHandlerTest {
    @isTest
    static void testCreateLocationSharingWithServiceResource(){
        Schema.Location van1 = new Schema.Location(Name='Test Van 1', LocationType='Van', IsMobile=true, IsInventoryLocation=true);
        Schema.Location van2 = new Schema.Location(Name='Test Van 1', LocationType='Van', IsMobile=true, IsInventoryLocation=true);
        List<Schema.Location> vans = new List<Schema.Location>{van1,van2};
        insert vans;

        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);

        List<ServiceResource> serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        serviceResources[0].LocationId=vans[0].Id;
        insert serviceResources;

        Test.startTest();
        //change the location owner
        vans[0].OwnerId = serviceResources[1].RelatedRecordId;
        update vans[0];
        Test.stopTest();

        List<LocationShare> locationShare = [SELECT Id FROM LocationShare WHERE ParentId = :vans[0].Id AND UserOrGroupId = :serviceResources[0].RelatedRecordId];
        System.assertEquals(1,locationShare.size(), 'LocationShare not created as expected');
    }
}