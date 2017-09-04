public class ServiceResourceTriggerHandler {
    public static void setRelatedUser(List<ServiceResource> newServiceResources) {
        for(ServiceResource newSR : newServiceResources){
            newSR.Related_User__c = newSR.RelatedRecordId;
        }
    }
}