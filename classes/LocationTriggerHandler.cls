public class LocationTriggerHandler {
    //Create sharing when the owner is changed:
    //Community users can't be owner of a Location, when the owner is changed, the sharing previously created is cleared and must be created again
    public static void createLocationSharingWithServiceResource(List<Schema.Location> locations, Map<Id,Schema.Location> oldLocations){

        Set<Id> locationIds = new Set<Id>();
        for(Schema.Location loc : locations){
            if(loc.OwnerId != oldLocations.get(loc.Id).OwnerId){
                locationIds.add(loc.Id);
            }
        }

        if(locationIds.size()>0){
            List<ServiceResource> serviceResources = ServiceResourceDAO.getServiceResourcesByLocationIds(locationIds);
            List<LocationShare> locationSharing = new List<LocationShare>();
            for(ServiceResource sr : serviceResources){
                locationSharing.add(new LocationShare(UserOrGroupId=sr.RelatedRecordId,
                                                        ParentId=sr.LocationId,
                                                        AccessLevel=Constants.OBJECT_ACCESS_LEVEL_READ));
            }

            if(locationSharing.size()>0){
                insert locationSharing;
            }
        }
    }
}