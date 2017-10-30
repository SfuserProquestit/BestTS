@isTest
public class ProductItemTriggerHandlerTest {

    @isTest
    static void testCreateProductItemSharingWithServiceResource(){
        Schema.Location van1 = new Schema.Location(Name='Test Van 1', LocationType='Van', IsMobile=true, IsInventoryLocation=true);
        Schema.Location van2 = new Schema.Location(Name='Test Van 1', LocationType='Van', IsMobile=true, IsInventoryLocation=true);
        List<Schema.Location> vans = new List<Schema.Location>{van1,van2};
        insert vans;

        List<User> techUsers = TestUtility.createCommunityUserTechnicians(2);

        List<ServiceResource> serviceResources=TestUtility.createServiceResources(techUsers, Constants.SERVICE_RESOURCE_RESOURCE_TYPE_TECH);
        serviceResources[0].LocationId=vans[0].Id;
        insert serviceResources;

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

        Test.startTest();
            //change the product item owner
            productItems[0].OwnerId = serviceResources[1].RelatedRecordId;
            update productItems[0];
        Test.stopTest();

        List<ProductItemShare> productItemShare = [SELECT Id FROM ProductItemShare WHERE ParentId = :productItems[0].Id AND UserOrGroupId = :serviceResources[0].RelatedRecordId];
        System.assertEquals(1,productItemShare.size(), 'ProductItemShare not created as expected');
    }
}