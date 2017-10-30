/*
* Required trigger to update of Request_Part__c and its matching Product Request Line Items on a Service 
* Created by Joey Ho - 01/8/17
*/
trigger RequestPartTrigger on Request_Part__c (before insert, after update, before delete) {

    if(CustomMetadataTypeDAO.getTriggerSettingForFSLMigration() == false){
        return;
    }

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ProductRequestLineItemTriggerController.setWorkOrder(Trigger.new);
        }
    }
	//Update Qty field to Product Request Line Item and Product Transfers 
	if(trigger.isAfter && trigger.isUpdate && ProductRequestLineItemTriggerController.flag_updateProductRequestLineItems==false){
		new ProductRequestLineItemTriggerController().updateProductRequestLineItems(trigger.newMap,trigger.oldMap);
	}

	//Delete matching Product Request, line items and Product Transfer
	if(trigger.isBefore && trigger.isDelete && ProductRequestLineItemTriggerController.flag_deletingProductrequestLines==false)
		new ProductRequestLineItemTriggerController().deletingProductrequestLines(trigger.oldMap);
}