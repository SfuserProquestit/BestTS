public class ObjectShareDAO {
    public static List<WorkOrderShare> getWorkOrderShareByParentIdUserId(Set<Id> parentIds, Set<Id> userIds) {
        return [SELECT Id 
                FROM WorkOrderShare 
                WHERE ParentId IN :parentIds
                    AND UserOrGroupId IN :userIds];
    }
}