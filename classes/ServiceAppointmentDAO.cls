public class ServiceAppointmentDAO {
    public static List<ServiceAppointment> getSerAppointmentsByParentRecordId(Set<Id> parentRecordIds){
        return [SELECT  Id,
                        Status,
                        ParentRecordId
                FROM ServiceAppointment
                WHERE ParentRecordId IN :parentRecordIds];
    }
}