trigger ServiceResourceTrigger on ServiceResource (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if(CustomMetadataTypeDAO.getTriggerSettingForFSLMigration() == false){
        return;
    }

    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ServiceResourceTriggerHandler.setRelatedUser(Trigger.new);
        }
        if(Trigger.isUpdate){
            ServiceResourceTriggerHandler.setRelatedUser(Trigger.new);
            ServiceResourceTriggerHandler.deleteLocationSharing(Trigger.new, Trigger.oldMap);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ServiceResourceTriggerHandler.createLocationSharing(Trigger.new, null);
        }
        if(Trigger.isUpdate){
            ServiceResourceTriggerHandler.createLocationSharing(Trigger.new, Trigger.oldMap);
        }
    }
}