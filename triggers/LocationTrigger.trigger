trigger LocationTrigger on Location (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            LocationTriggerHandler.createLocationSharingWithServiceResource(Trigger.new, Trigger.oldMap);
        }
    }
}