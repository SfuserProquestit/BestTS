trigger ProductItemTrigger on ProductItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ProductItemTriggerHandler.createProductItemSharingWithServiceResource(Trigger.new, null);
        }
        if(Trigger.isUpdate){
            ProductItemTriggerHandler.createProductItemSharingWithServiceResource(Trigger.new, Trigger.oldMap);
        }
    } 
}