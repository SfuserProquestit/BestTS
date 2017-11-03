public class ProductItemTriggerHandler {
    //Create sharing on product item with the service resource that has the location populated with the location of the product item
    //Create sharing when the owner is changed:
    //Community users can't be owner of a Product Item, when the owner is changed, the sharing previously created is cleared and must be created again
    public static void createProductItemSharingWithServiceResource(List<ProductItem> productItems, Map<Id,ProductItem> oldProductItems){

        Set<Id> locationIds = new Set<Id>();
        List<ProductItem> productItemsToShare = new List<ProductItem>();
        for(ProductItem pi : productItems){
            if(pi.LocationId != null 
                && ((oldProductItems==null && pi.OwnerId != UserInfo.getUserId()) || (oldProductItems != null && pi.OwnerId != oldProductItems.get(pi.Id).OwnerId))){
                productItemsToShare.add(pi);
                locationIds.add(pi.LocationId);
            }
        }

        if(locationIds.size()>0){
            List<ServiceResource> serviceResources = ServiceResourceDAO.getServiceResourcesByLocationIds(locationIds);
            Map<Id,Id> locationIdUserId = new Map<Id,Id>();
            for(ServiceResource sr : serviceResources){
                locationIdUserId.put(sr.LocationId,sr.RelatedRecordId);
            }

            List<ProductItemShare> productItemSharing = new List<ProductItemShare>();
            for(ProductItem pi : productItemsToShare){
                if(locationIdUserId.containsKey(pi.LocationId)){
                    productItemSharing.add(new ProductItemShare(UserOrGroupId=locationIdUserId.get(pi.LocationId),
                                                                ParentId=pi.Id,
                                                                AccessLevel=Constants.OBJECT_ACCESS_LEVEL_READ));
                }
            }

            if(productItemSharing.size()>0){
                insert productItemSharing;
            }
        }
    }
}