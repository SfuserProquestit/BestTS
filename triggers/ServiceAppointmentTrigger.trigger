trigger ServiceAppointmentTrigger on ServiceAppointment (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    

    if(CustomMetadataTypeDAO.getTriggerSettingForFSLMigration() == false){
        return;
    }

    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ServiceAppointmentTriggerHandler.setWorkOrderRelationship(Trigger.new);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ServiceAppointmentTriggerHandler.setServiceAppointmentOnWorkOrder(Trigger.new);
        }
        if(Trigger.isUpdate){
            if(ServiceAppointmentTriggerHandler.runUpdateWorkOrderStatus){
                ServiceAppointmentTriggerHandler.updateWorkOrderStatus(Trigger.new, Trigger.oldMap);
            }
        }
    }
}