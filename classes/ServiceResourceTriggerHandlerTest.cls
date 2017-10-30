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

    @isTest
    static void testCreateLocationSharing(){
        Schema.Location van1 = new Schema.Location(Name='Test Van 1', LocationType='Van', IsMobile=true, IsInventoryLocation=true);
        Schema.Location van2 = new Schema.Location(Name='Test Van 1', LocationType='Van', IsMobile=true, IsInventoryLocation=true);
        List<Schema.Location> vans = new List<Schema.Location>{van1,van2};
        insert vans;

        List<Product2> products = new List<Product2>();
        for(Integer i=0; i<5; i++){
            products.add(new Product2(Name='Test Product'+i));
        }
        insert products;

        List<ProductItem> productItems = new List<ProductItem>();
        for(Product2 prod : products){
            productItems.add(new ProductItem(Product2Id=prod.Id, LocationId=vans[0].Id, QuantityOnHand=10));
            productItems.add(new ProductItem(Product2Id=prod.Id, LocationId=vans[1].Id, QuantityOnHand=10));
        }
        insert productItems;

        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);

        List<ServiceResource> serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        serviceResources[0].LocationId=vans[0].Id;

        Test.startTest();
            insert serviceResources;
            List<LocationShare> locationShare = [SELECT Id FROM LocationShare WHERE ParentId = :vans[0].Id AND UserOrGroupId = :serviceResources[0].RelatedRecordId];
            System.assertEquals(1,locationShare.size(), 'LocationShare not created as expected');

            serviceResources[1].LocationId=vans[1].Id;
            update serviceResources[1];
        Test.stopTest();

        Set<Id> userIds = new Set<Id>{serviceResources[0].RelatedRecordId, serviceResources[1].RelatedRecordId};
        locationShare = [SELECT Id FROM LocationShare WHERE ParentId = :vans[1].Id AND UserOrGroupId = :serviceResources[1].RelatedRecordId];
        System.assertEquals(1,locationShare.size(), 'LocationShare not created as expected');

        List<ProductItemShare> productItemShare = [SELECT Id FROM ProductItemShare WHERE UserOrGroupId IN :userIds];
        System.assertEquals(10,productItemShare.size(), 'ProductItemShare not created as expected');
    }

    @isTest
    static void testDeleteLocationSharing(){
        Schema.Location van1 = new Schema.Location(Name='Test Van 1', LocationType='Van', IsMobile=true, IsInventoryLocation=true);
        Schema.Location van2 = new Schema.Location(Name='Test Van 1', LocationType='Van', IsMobile=true, IsInventoryLocation=true);
        List<Schema.Location> vans = new List<Schema.Location>{van1,van2};
        insert vans;

        List<Product2> products = new List<Product2>();
        for(Integer i=0; i<5; i++){
            products.add(new Product2(Name='Test Product'+i));
        }
        insert products;

        List<ProductItem> productItems = new List<ProductItem>();
        for(Product2 prod : products){
            productItems.add(new ProductItem(Product2Id=prod.Id, LocationId=vans[0].Id, QuantityOnHand=10));
            productItems.add(new ProductItem(Product2Id=prod.Id, LocationId=vans[1].Id, QuantityOnHand=10));
        }
        insert productItems;

        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);

        List<ServiceResource> serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        serviceResources[0].LocationId = vans[0].Id;
        serviceResources[1].LocationId = vans[1].Id;
        insert serviceResources;

        Test.startTest();

        for(ServiceResource sr : serviceResources){
            sr.LocationId = null;
        }
        update serviceResources;
        Test.stopTest();
        Set<Id> userIds = new Set<Id>{serviceResources[0].RelatedRecordId, serviceResources[1].RelatedRecordId};

        List<LocationShare> locationShare = [SELECT Id FROM LocationShare WHERE UserOrGroupId IN :userIds];
        System.assertEquals(0,locationShare.size(), 'LocationShare not deleted as expected');

        List<ProductItemShare> productItemShare = [SELECT Id FROM ProductItemShare WHERE UserOrGroupId IN :userIds];
        System.assertEquals(0,productItemShare.size(), 'ProductItemShare not deleted as expected');
    }
}