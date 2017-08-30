trigger UsageFSLTrigger on Usage_FSL__c (before insert, after insert, before update, after update, before delete, after undelete) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            UsageFSLHandler.setParentWorkOrder(Trigger.new);
        }
        if(Trigger.isDelete){
            UsageFSLHandler.preventInvoicedUsageDeletion(Trigger.old);
            UsageFSLHandler.calculateRollups(Trigger.oldMap, true);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert) {
            UsageFSLHandler.calculateRollups(Trigger.newMap, false);
        }
        if(Trigger.isUpdate) {
            UsageFSLHandler.calculateRollups(Trigger.newMap, false);
        }
        if(Trigger.isUndelete) {
            UsageFSLHandler.calculateRollups(Trigger.newMap, false);
        }
    }
}