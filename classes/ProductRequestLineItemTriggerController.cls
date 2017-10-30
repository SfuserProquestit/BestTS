/*
*   Controller for RequestPartTrigger and ProductRequestLineItemTrigger as well as ReceivedPartTrigger
*   Created by Joey Ho 01/08/2017
*/
public with sharing class ProductRequestLineItemTriggerController {
	public static boolean flag_updateProductRequestLineItems = false;
	public static boolean flag_deletingProductrequestLines = false;
	public static boolean flag_removeReceivedPartLines = false;

	//Updates the matching Product Request Line Items when Request_Part__c is altered (Qty field changed only)
	public void updateProductRequestLineItems(map<Id,Request_Part__c> newMap, Map<Id,Request_Part__c> oldMap){
		flag_updateProductRequestLineItems = true;		

		map<Id,Id> PR2PartRequestId = new map<Id,Id>();

		//Get product request id matching to the Request_Part__c records
        for(Id key: newMap.keySet()){     
            system.debug('request line new Quantity__c--- '+newMap.get(key).Quantity__c); 
            system.debug('request line old Quantity__c--- '+newMap.get(key).Quantity__c);
	        if(newMap.get(key).Quantity__c != oldMap.get(key).Quantity__c && newMap.get(key).Product_Request__c!=null){	
	        	if(newMap.get(key).status__c=='Received')
					newMap.get(key).addError('Quantity can not be changed when Part Request has be \'Received\'');
	        	else        	
	            	PR2PartRequestId.put(newMap.get(key).Product_Request__c,key);	      
	        }
        }

        if(!PR2PartRequestId.isEmpty()){
        	list<ProductRequestLineItem> prline = new list<ProductRequestLineItem>();
        	list<ProductTransfer> ptlist = new list<ProductTransfer>();

        	for(ProductRequest pr : [SELECT id, WorkOrderId,         		
        								(SELECT id, QuantityRequested FROM ProductRequestLineItems),
        								(SELECT Id, QuantityReceived, QuantitySent FROM ProductTransfers) FROM ProductRequest
        								WHERE Id IN: PR2PartRequestId.keySet()]){
        	
        		Id originalReqId = PR2PartRequestId.get(pr.Id);
        		decimal newQty = newMap.get(originalReqId).Quantity__c;
        		for(ProductRequestLineItem pl: pr.ProductRequestLineItems){
        			pl.QuantityRequested = newQty;
        			prline.add(pl);
        		}

        		for(ProductTransfer pt : pr.ProductTransfers){
        			/* Removed as ProductTranser is altered by Recevied_Part__c	
                    pt.QuantityReceived = newQty;
        			pt.QuantitySent = newQty;
        			ptlist.add(pt);
        			*/
                }
        	}

        	update ptlist;
        	update prline;
        }
	}

    /*Remove delete from Product Line Itme  joho 13/8/17
	//Udates Request_Part__c records when Product REquest Line Items are altered in qty field
	public void updateRequestParts(map<Id,ProductRequestLineItem> newMap, Map<Id,ProductRequestLineItem> oldMap){
		/* Removed to stop updates from apex when Product Request Line Items change
		 
        flag_updateProductRequestLineItems = true;

		list<Id> prlineIds = new list<Id>();
		map<Id,Id> ProductTran2LineItem = new map<Id,Id>();

        
		for(Id key: newMap.keySet()){
			if(newMap.get(key).QuantityRequested != oldMap.get(key).QuantityRequested){
				if(newMap.get(key).status=='Received')					
					newMap.get(key).addError('Quantity can not be changed when Part Request has be \'Received\'');
				else
					prlineIds.add(key);
			}
		}

        
		map<Id,ProductTransfer> ptUpdates = new map<Id,ProductTransfer>();
		for(ProductTransfer pt : [SELECT id, QuantityReceived, QuantitySent, ProductRequestLineItemId FROM ProductTransfer WHERE ProductRequestLineItemId IN: prlineIds]){
				
			decimal qty = newMap.get(pt.ProductRequestLineItemId).QuantityRequested;
			system.debug('---qty--- ' + qty);
			pt.QuantityReceived = qty;
			pt.QuantitySent = qty;
			ptUpdates.put(pt.Id,pt);
		
		}

		update ptUpdates.values();

		list<Request_Part__c> rp_list = new list<Request_Part__c>();
		for(Request_Part__c rp : [SELECT id, Quantity__c, Product_Transfer__c FROM Request_Part__c WHERE Product_Transfer__c IN:ptUpdates.keySet()]){			
			decimal qty = ptUpdates.get(rp.Product_Transfer__c).QuantitySent;
			rp.Quantity__c = qty;
			rp_list.add(rp);			
		}

		update rp_list;
		
	}
*/
	//Delete related Product Request, Product Request Line Items and Product Transfer items
	public void deletingProductrequestLines(map<Id,Request_Part__c> oldMap){
		flag_deletingProductrequestLines = true;

		list<ProductRequest> prList = new list<ProductRequest>();
		list<ProductTransfer> ptList = new list<ProductTransfer>();

		for(Id key : oldMap.keySet()){
			if(oldMap.get(key).status__c == 'Received'){
				oldMap.get(key).addError('Record can not be deleted when Request Part has be \'Received\'');
			}else{
				if(oldMap.get(key).Product_Request__c!=null)
					prList.add(new ProductRequest(id=oldMap.get(key).Product_Request__c));

                /*Removed as Product Transfer is altered in Received_Part__c - jho - 13/8/17
                if(oldMap.get(key).Product_Transfer__c!=null)
					ptList.add(new ProductTransfer(id=oldMap.get(key).Product_Transfer__c));
				*/
			}
		}

		//delete ptList;	//Removed as Product Transfer is altered in Received_Part__c - jho - 13/8/17
		delete prList;
	}

    /*Remove delete from Product Line Itme  joho 13/8/17
	//Deletes all Request_Part records that have a reference to the PRoduct Request Id from the Product Request Line Items
	public void deleteFromProductLineItems(map<id,ProductRequestLineItem> oldMap){
		set<Id> prList = new set<Id>();
		map<Id,Id> pr2lineMap = new map<Id,Id>();
		for(Id key: oldMap.keySet()){
			prList.add(oldMap.get(key).ParentId);
			pr2lineMap.put(oldMap.get(key).ParentId,key);		
		}

		list<Request_Part__c> delRP = [SELECT id,Product_Request__c FROM Request_Part__c WHERE Product_Request__c IN: pr2lineMap.keySet()];	
		Database.DeleteResult[] drList = Database.delete(delRP, false);
		
		// Iterate through each returned result
		for(integer i = 0; i<drList.size(); i++) {
		    if (!drList[i].isSuccess()) {
		        // Operation failed, so get all errors     
		        string errstr = '';           
		        for(Database.Error err : drList[i].getErrors()) {		                             
		            errstr += (err.getStatusCode() + ': ' + err.getMessage());
		        }
		        Id prId = delRP[i].Product_Request__c;
		        Id lineId = pr2lineMap.get(prId);
		        oldMap.get(lineId).addError(errstr);
		    }
		}
	}
*/
	//Deletes corresponding ProductTransfer record matching to the received Part.
	public void removeReceivedPartLines(list<Received_Part__c> oldList){
		
        flag_removeReceivedPartLines = true;
		set<Id> reqIds = new set<Id>();
		for(Received_Part__c rp:oldList)
			reqIds.add(rp.Request_Part__c);

		map<Id,boolean> stopDel = new map<Id,boolean>();
		for(Request_Part__c req:[SELECT id, Status__c FROM Request_Part__c WHERE Id IN: reqIds]){
			boolean stop = (req.Status__c == 'Received') ? true:false;			
			stopDel.put(req.Id,stop);
		}

		list<ProductTransfer> ptDel = new list<ProductTransfer>();
		for(Received_Part__c rp:oldList){
			if(stopDel.get(rp.Request_Part__c))
				rp.addError('Record can not be deleted when Request Part has be \'Received\'');
			else if(rp.Product_Transfer__c!=null)
				ptDel.add(new ProductTransfer(id=rp.Product_Transfer__c));
		}
		delete ptDel;
		
	}

    public static void setWorkOrder(List<Request_Part__c> newRequestParts){
        Set<Id> woServiceIds = new Set<Id>();
        for(Request_Part__c rp : newRequestParts){
            woServiceIds.add(rp.Work_Order_Service__c);
        }
        Map<Id,WorkOrder> woServices = new Map<Id,WorkOrder>(WorkOrderDAO.getWorkOrdersById(woServiceIds));
        for(Request_Part__c rp : newRequestParts){
            rp.Work_Order__c = woServices.get(rp.Work_Order_Service__c).ParentWorkOrderId;
        }
    }
}