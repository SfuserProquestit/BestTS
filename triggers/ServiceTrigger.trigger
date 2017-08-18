trigger ServiceTrigger on CKSW_BASE__Service__c (after insert, after update, before delete, after undelete) {
	if(Trigger.isInsert || Trigger.isUpdate) {
		ServiceTriggerHandler.updateWorkOrdersStatus(Trigger.newMap, false); 
		ServiceTriggerHandler.allocateLicensing(Trigger.oldMap, Trigger.new);
	} else if(Trigger.isDelete){
		ServiceTriggerHandler.preventInvoicedWOServiceDeletion(Trigger.old);
	}
}