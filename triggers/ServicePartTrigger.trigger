/*
* Required trigger to update Consumed Product Items as Field Service Mobile Profiles do not have write permissions on WO - hence not on Consumed Products
* Created by Joey Ho - 25/7/17
*/
trigger ServicePartTrigger on Service_Part__c (before insert, after update, before delete) {

	if(trigger.isBefore && trigger.isInsert){
		//Checks Stock Location and productItems within stock location
		new ProductConsumedTriggerController().stockLocationcheck(trigger.new);
	}

	if(trigger.isAfter && trigger.isUpdate){
		//This trigger uses functions from class ProductConsumedTriggerController.cls to allow techs to update Products Consumed
		if(!ProductConsumedTriggerController.flag_updateSerivceParts)
			new ProductConsumedTriggerController().updateSerivceParts(trigger.newMap, trigger.oldMap);
	}

	if(trigger.isBefore && trigger.isDelete && ProductConsumedTriggerController.flag_isDeletingProductOrServicePart == false){
		//Delete corresponding Consumed Part
		ProductConsumedTriggerController.flag_isDeletingProductOrServicePart = true;
		//list<ProductConsumed> pcl = new ProductConsumedTriggerController().getFilteredProductConsumedList(trigger.oldMap);
		delete new ProductConsumedTriggerController().getFilteredProductConsumedList(trigger.oldMap);
	}

}