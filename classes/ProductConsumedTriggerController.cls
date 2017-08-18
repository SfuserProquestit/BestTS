/*
*   Created by Joey Ho 21/07/2017
*/
public without sharing class ProductConsumedTriggerController {
    
    public static boolean flag_updateSerivceParts = false; //Used in ProductConsumedTrigger as well as ServicePartTrigger to avoid overwriting
    public static boolean flag_isDeletingProductOrServicePart = false;

    /*
    //Returns list Service Part that matches to the Product Consumed that was deleted
    public list<Service_Part__c> getFilteredServiceParts(list<ProductConsumed> oldList){
        list<Service_Part__c> sobjList = new list<Service_Part__c>();
        for(ProductConsumed pc : oldList){
            if(pc.Matching_Service_Part__c!=null)
                sobjList.add(new Service_Part__c(Id=pc.Matching_Service_Part__c));
        }    
        system.debug('delete --- '+ sobjList);
        return sobjList;
    }
	*/
    //Returns list of matching conusming parts given old map
    public list<ProductConsumed> getFilteredProductConsumedList(map<Id,Service_Part__c> oldMap){
        list<ProductConsumed> sobjList = new list<ProductConsumed>();  
        system.debug('---oldMap.keySet()--- ' + oldMap.keySet());
      

      for(ProductConsumed pc : [SELECT Id, Matching_Service_Part__c FROM ProductConsumed WHERE Matching_Service_Part__c IN: oldMap.keySet()]){
            sobjList.add(pc);
        }   

        system.debug('length --- '+ sobjList.size());
        system.debug('delete --- '+ sobjList);
        return sobjList;
    }
	
    /*
    //Updates Service Parts that have quantity changed from the Product Consumed record
    public void updateSerivceParts(map<Id,ProductConsumed> newMap, Map<Id,ProductConsumed> oldMap){
    	flag_updateSerivceParts = true;

        map<Id,Id> ServicePart2PcIds = new map<Id,Id>();

        for(Id key: newMap.keySet()){
            if(newMap.get(key).QuantityConsumed != oldMap.get(key).QuantityConsumed){
                ServicePart2PcIds.put(newMap.get(key).Matching_Service_Part__c,key);
            }
        }

        if(!ServicePart2PcIds.isEmpty()){
            list<Service_Part__c> spUpdate = new list<Service_Part__c>();
            for(Service_Part__c sp : [SELECT Id, Quantity_Consumed__c FROM Service_Part__c WHERE Id IN: ServicePart2PcIds.keySet()]){
                Id pcId = ServicePart2PcIds.get(sp.Id);
                sp.Quantity_Consumed__c = newMap.get(pcId).QuantityConsumed;
                spUpdate.add(sp);
            }

            update spUpdate;
        }
    }
	*/
    //For Technicians to update Product Consumed - Joey Ho - 25/07/2017
    public void updateSerivceParts(map<Id,Service_Part__c> newMap, Map<Id,Service_Part__c> oldMap){
        flag_updateSerivceParts = true;

        set<id> ServicePartSet = new set<id>();
        list<ProductConsumed> pc2Update = new list<ProductConsumed>();

        for(Id key : newMap.keySet()){
            if(newMap.get(key).Product_Item__c != oldMap.get(key).Product_Item__c)
                newMap.get(key).addError('You can not change the Product Item Consumed. Please Delete this item and create a new one.');

            if(newMap.get(key).Quantity_Consumed__c != oldMap.get(key).Quantity_Consumed__c)
                ServicePartSet.add(key);
        }

        for(ProductConsumed pc : [SELECT Id, QuantityConsumed, ProductItemId, Matching_Service_Part__c FROM ProductConsumed WHERE Matching_Service_Part__c IN: ServicePartSet]){
            Id spId = pc.Matching_Service_Part__c;
            pc.QuantityConsumed = newMap.get(spId).Quantity_Consumed__c;
            //pc.ProductItemId = newMap.get(spId).Product_Item__c;
            pc2Update.add(pc);
        }
        
        integer i = 0;
        Database.SaveResult[] srList = Database.update(pc2Update, false);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()){
                    Id key = pc2Update[i].Matching_Service_Part__c;
                    newMap.get(key).addError(' updating Service Part - '+err.getMessage());
                }
            }
            i++;
        }
    }   

    //Checks product items in Stock Van locations contain enough quantity before proceeding
    public void stockLocationcheck(list<Service_Part__c> newList){
        set<Id> serviceIds = new set<Id>();
        set<Id> prodItems = new set<Id>();
        for(Service_Part__c sp : newList){
            serviceIds.add(sp.Service__c);
            prodItems.add(sp.Product_Item__c);
        }

        set<Id> product2Ids = new set<Id>();        
        map<Id,decimal> vanStockMap = new map<id,decimal>();
        for(ProductItem pi:[SELECT id, Product2Id, QuantityOnHand FROM ProductItem WHERE Id IN:prodItems]){
            vanStockMap.put(pi.Id,pi.QuantityOnHand);
            product2Ids.add(pi.product2Id);
        }

/*
        //Get all request to check
        map<id,map<id,integer>> numOfReqMap = new map<id,map<id,integer>>();
        for(Request_Part__c rp:[SELECT id, Service__c FROM Request_Part__c WHERE Service__c IN:serviceIds AND product_Name__c IN: product2Ids]]){

        }
*/
        //Check if has van and part locations
        for(Service_Part__c sp:newList){
            if(!vanStockMap.containsKey(sp.Product_Item__c))
                sp.addError('You may not a Van or Stock to consume part');
            else{
                integer soh = integer.valueOf(vanStockMap.get(sp.Product_Item__c));
                if(soh==0)
                    sp.addError('You do not have any stock to consume for this product.');
                else if(sp.Quantity_Consumed__c > soh){
                    sp.addError('You only have '+soh+ ' stock on hand and cannot consume more than that.');
                }
            }
        }
    }

}