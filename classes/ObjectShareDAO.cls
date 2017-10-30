public class ObjectShareDAO {
    public static List<WorkOrderShare> getWorkOrderShareByParentIdUserId(Set<Id> parentIds, Set<Id> userIds) {
        return [SELECT Id 
                FROM WorkOrderShare 
                WHERE ParentId IN :parentIds
                    AND UserOrGroupId IN :userIds];
    }

    public static List<LocationShare> getLocationShareByParentIdUserId(Set<Id> parentIds, Set<Id> userIds) {
        return [SELECT Id 
                FROM LocationShare 
                WHERE ParentId IN :parentIds
                    AND UserOrGroupId IN :userIds];
    }
    
    public static List<ProductItemShare> getProductItemShareByParentIdUserId(Set<Id> parentIds, Set<Id> userIds) {
        return [SELECT Id 
                FROM ProductItemShare 
                WHERE ParentId IN :parentIds
                    AND UserOrGroupId IN :userIds];
    }
}