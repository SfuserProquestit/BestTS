public class AssignedResourceDAO {
    static public List<AssignedResource> getAssignedResourceByIds(Set<Id> assignedResourceIds){
        return [SELECT
                    Id,
                    ServiceResourceId,
                    ServiceAppointment.Work_Order__c
                FROM
                    AssignedResource
                WHERE
                    Id IN :assignedResourceIds
            ];
    }
}