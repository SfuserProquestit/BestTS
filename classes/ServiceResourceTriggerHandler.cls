public class ServiceResourceTriggerHandler {
    public static void setRelatedUser(List<ServiceResource> newServiceResources) {
        for(ServiceResource newSR : newServiceResources){
            newSR.Related_User__c = newSR.RelatedRecordId;
        }
    }

    //Create sharing on location for a service resource
    public static void createLocationSharing(List<ServiceResource> newServiceResources, Map<Id,ServiceResource> oldServiceResources){

        Map<Id,Set<Id>> userIdsByLocationId = new Map<Id,Set<Id>>();
        Set<id> locationIds = new Set<Id>();

        for(ServiceResource newSR : newServiceResources){
            if(newSR.LocationId != null &&  
                (oldServiceResources == null || (oldServiceResources != null && (oldServiceResources.get(newSR.Id).LocationId != newSR.LocationId || oldServiceResources.get(newSR.Id).RelatedRecordId != newSR.RelatedRecordId)))){
                if(userIdsByLocationId.containsKey(newSR.LocationId)){
                    userIdsByLocationId.get(newSR.LocationId).add(newSR.RelatedRecordId);
                }
                else{
                    userIdsByLocationId.put(newSR.LocationId,new Set<Id>{newSR.RelatedRecordId});
                }
                locationIds.add(newSR.LocationId);
            }
        }

        if(userIdsByLocationId.size()>0){

            List<ProductItem> productItems = ProductItemDAO.getProductItemsByLocationIds(locationIds);
            Map<Id,Set<Id>> productItemIdsByLocationId = new Map<Id,Set<Id>>();
            for(ProductItem productItem : productItems){
                if(productItemIdsByLocationId.containsKey(productItem.LocationId)){
                    productItemIdsByLocationId.get(productItem.LocationId).add(productItem.Id);
                }
                else{
                    productItemIdsByLocationId.put(productItem.LocationId,new Set<Id>{productItem.Id});
                }
            }

            List<LocationShare> locationSharing = new List<LocationShare>();
            List<ProductItemShare> productItemSharing = new List<ProductItemShare>();
            for(Id locationId : userIdsByLocationId.keySet()){
                Set<Id> userIds = userIdsByLocationId.get(locationId);
                for(Id userId : userIds){
                    locationSharing.add(new LocationShare(UserOrGroupId=userId,
                                                            ParentId=locationId,
                                                            AccessLevel=Constants.OBJECT_ACCESS_LEVEL_READ));

                    if(productItemIdsByLocationId.size() >0 && productItemIdsByLocationId.containsKey(locationId)){
                        Set<Id> productItemIds = productItemIdsByLocationId.get(locationId);
                        for(Id productItemId : productItemIds){
                            productItemSharing.add(new ProductItemShare(UserOrGroupId=userId,
                                                                        ParentId=productItemId,
                                                                        AccessLevel=Constants.OBJECT_ACCESS_LEVEL_READ));
                        }
                    }
                }
            }

            if(locationSharing.size()>0){
                insert locationSharing;
            }
            if(productItemSharing.size()>0){
                insert productItemSharing;
            }
        }
    }

    //Delete sharing on location for a service resource
    public static void deleteLocationSharing(List<ServiceResource> newServiceResources, Map<Id,ServiceResource> oldServiceResources){
        Set<id> locationIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        for(ServiceResource newSR : newServiceResources){
            ServiceResource oldSR = oldServiceResources.get(newSR.Id);
            if(oldSR.LocationId != null && (oldSR.LocationId != newSR.LocationId || oldSR.RelatedRecordId != newSR.RelatedRecordId)){
                locationIds.add(oldSR.LocationId);
                userIds.add(oldSR.RelatedRecordId);
            }
        }

        if(locationIds.size()>0){
            List<LocationShare> locationSharing = ObjectShareDAO.getLocationShareByParentIdUserId(locationIds,userIds);

            List<ProductItemShare> productItemSharing = new List<ProductItemShare>();
            List<ProductItem> productItems = ProductItemDAO.getProductItemsByLocationIds(locationIds);
            if(productItems.size()>0){
                Map<Id,ProductItem> mapProductItems = new Map<Id,ProductItem>(productItems);
                productItemSharing = ObjectShareDAO.getProductItemShareByParentIdUserId(mapProductItems.keySet(),userIds);
            }

            if(locationSharing.size()>0){
                delete locationSharing;
            }
            if(productItemSharing.size()>0){
                delete productItemSharing;
            }
        }
    }
}