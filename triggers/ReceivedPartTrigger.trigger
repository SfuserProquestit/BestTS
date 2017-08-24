/*
* Required trigger to update to delete Received_Part__c records which directly delete the Part_Transfer__c record 
* Created by Joey Ho - 11/8/17
*/
trigger ReceivedPartTrigger on Received_Part__c (after delete) {
	if(trigger.isAfter && trigger.isDelete){
		if(!ProductRequestLineItemTriggerController.flag_removeReceivedPartLines)
			new ProductRequestLineItemTriggerController().removeReceivedPartLines(trigger.old);			
	}
}