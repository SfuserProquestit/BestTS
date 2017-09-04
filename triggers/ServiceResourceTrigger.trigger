trigger ServiceResourceTrigger on ServiceResource (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ServiceResourceTriggerHandler.setRelatedUser(Trigger.new);
        }
        if(Trigger.isUpdate){
            ServiceResourceTriggerHandler.setRelatedUser(Trigger.new);
        }
    }
}