trigger WorkOrderTrigger on WorkOrder (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            WorkOrderTriggerHandler.deleteWorkOrderSharing(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isDelete) {
            WorkOrderTriggerHandler.preventInvoicedWODeletion(Trigger.old);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            if(WorkOrderTriggerHandler.runUpdateSAStatus){
                WorkOrderTriggerHandler.updateSAStatus(Trigger.new, Trigger.oldMap);
                WorkOrderTriggerHandler.updateParentWorkOrderStatus(Trigger.new, Trigger.oldMap);
            }
            WorkOrderTriggerHandler.createParentWorkOrderSharing(Trigger.new, Trigger.oldMap);
            WorkOrderTriggerHandler.createParentWorkOrderSharingOnOwnerChange(Trigger.new, Trigger.oldMap);
        }
    }
}