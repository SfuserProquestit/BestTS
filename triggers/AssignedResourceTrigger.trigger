trigger AssignedResourceTrigger on AssignedResource (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    
    if(CustomMetadataTypeDAO.getTriggerSettingForFSLMigration() == false){
        return;
    }


    if(Trigger.isBefore){
        if(Trigger.isDelete){
            AssignedResourceTriggerHandler.setServiceResourceOnWorkOrderWhenDelete(Trigger.oldMap);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            AssignedResourceTriggerHandler.setServiceResourceOnWorkOrder(Trigger.newMap, null);
        }
        if(Trigger.isUpdate){
            AssignedResourceTriggerHandler.setServiceResourceOnWorkOrder(Trigger.newMap, Trigger.oldMap);
        }
    }
}