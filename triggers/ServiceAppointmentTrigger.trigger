trigger ServiceAppointmentTrigger on ServiceAppointment (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ServiceAppointmentTriggerHandler.setWorkOrderRelationship(Trigger.new);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            if(ServiceAppointmentTriggerHandler.runUpdateWorkOrderStatus){
                ServiceAppointmentTriggerHandler.updateWorkOrderStatus(Trigger.new, Trigger.oldMap);
            }
        }
    }
}