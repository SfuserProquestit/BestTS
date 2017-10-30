public class ServiceResourceDAO {
    public static List<ServiceResource> getServiceResourcesByLocationIds(Set<Id> locationIds) {
        return [SELECT Id,
                        LocationId,
                        RelatedRecordId
                FROM ServiceResource 
                WHERE LocationId IN :locationIds];
    }
}