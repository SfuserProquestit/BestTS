trigger WorkOrderTrigger on WorkOrder (before delete) {
    if(Trigger.isDelete) {
        WorkOrderTriggerHandler.preventInvoicedWODeletion(Trigger.old);
    }
}