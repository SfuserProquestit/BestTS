trigger UsageFSLTrigger on Usage_FSL__c (after insert, after update, before delete, after undelete) {

	if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
		UsageFSLHandler.calculateRollups(Trigger.newMap, false);
	} else if(Trigger.isDelete){
		UsageFSLHandler.preventInvoicedUsageDeletion(Trigger.old);
		UsageFSLHandler.calculateRollups(Trigger.oldMap, true);
	}
}