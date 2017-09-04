public class ServiceAppointmentDAO {
    public static List<ServiceAppointment> getSerAppointmentsByParentRecordId(Set<Id> parentRecordIds){
        return [SELECT  Id,
                        Status,
                        ParentRecordId
                FROM ServiceAppointment
                WHERE ParentRecordId IN :parentRecordIds];
    }

    public static List<ServiceAppointment> getSerAppointmentsById(Set<Id> serAppointmentIds){
        return [SELECT  Id,
                        Status,
                        ParentRecordId
                FROM ServiceAppointment
                WHERE Id IN :serAppointmentIds];
    }
}