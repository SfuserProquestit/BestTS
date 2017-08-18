/*
*   Test class for ProductRequestLineItemTriggerController
*   Created by Joey Ho 02/08/2017
*/
@isTest
public class ProductRequestLineItemTriggerTest {
    
    @testSetup
    private static void init(){
        TestDataFactory.setData(); 
        
        CKSW_BASE__Service__c sss = [SELECT id,CKSW_BASE__Duration__c FROM CKSW_BASE__Service__c Limit 1];
        list<productItem> listPIs = [SELECT id,Product2Id,LocationId,QuantityUnitOfMeasure,QuantityOnHand FROM productItem];
        
        list<Request_Part__c> rplist = TestDataFactory.createNewPartRequest(sss,listPIs);
        insert rplist;
    }
    
    //Add and update new Request Part on Service 
    static testmethod void addNewRequestLines(){
        
        //Check 5 units from Service Contract
        CKSW_BASE__Service__c s = [SELECT id,Work_Order__c, (SELECT Id,Quantity__c FROM Requested_Parts__r) FROM CKSW_BASE__Service__c LIMIT 1];
        //system.assertEquals(5,s.Requested_Parts__r.size());
        
        //Get the Product Line Item Request
        list<ProductRequestLineItem> prli_list = [SELECT id, QuantityRequested FROM ProductRequestLineItem WHERE WorkOrderId=:s.Work_Order__c];
        
        Test.startTest();
                
        //system.assertEquals(5,prli_list.size());        
		        
        system.debug('---prli_list--- '+prli_list);
        list<ProductRequestLineItem> rList = new list<ProductRequestLineItem>();
        for(ProductRequestLineItem rp: prli_list){
            ProductRequestLineItem p = new ProductRequestLineItem(Id=rp.id,QuantityRequested=rp.QuantityRequested+1);
            //rp.QuantityRequested++;
            rList.add(p);
        }
        system.debug('---rList--- '+rList);
        //Update from a Work Order - Product Request Line Item
        ProductRequestLineItemTriggerController.flag_updateProductRequestLineItems = false;
        update rList;
        
        //Update from Service Request Part records
        ProductRequestLineItemTriggerController.flag_updateProductRequestLineItems = false;
        list<Request_Part__c> rr = s.Requested_Parts__r;
        for(Request_Part__c rp:rr){
            rp.Quantity__c++;
        }
        update rr;
        
        //Update from Service Request Part error for items received
        ProductRequestLineItemTriggerController.flag_updateProductRequestLineItems = false;
        for(Request_Part__c rp:rr){
            rp.Status__c = 'Received';
            rp.Quantity__c++;
        }        
        try{
        update rr;
        }Catch(Exception e){}
        Test.stopTest();
    }   
    
    //Deleting Require Part items
    static testmethod void deletingRequestParts(){        
        CKSW_BASE__Service__c s = [SELECT id,Work_Order__c, (SELECT Id,Quantity__c FROM Requested_Parts__r) FROM CKSW_BASE__Service__c LIMIT 1];
		delete s.Requested_Parts__r;
    }
    
    //Deleting Require Part items with error
    static testmethod void deletingRequestParts2(){        
        CKSW_BASE__Service__c s = [SELECT id,Work_Order__c, (SELECT Id,Quantity__c FROM Requested_Parts__r) FROM CKSW_BASE__Service__c LIMIT 1];
        list<Request_Part__c> rr = s.Requested_Parts__r;
        for(Request_Part__c rp:rr){
            rp.Status__c = 'Received';
        }
        update rr;
        try{
        	delete rr;
        }catch(exception e){}
    }
    
    //Receive Part Trigger testing with error
    static testmethod void deletingReceivePartTriggerError(){        
        CKSW_BASE__Service__c s = [SELECT id,Work_Order__c, (SELECT Id,Quantity__c FROM Requested_Parts__r) FROM CKSW_BASE__Service__c LIMIT 1];
        list<Received_Part__c> receives = new list<Received_Part__c>();
        for(Request_Part__c rp : s.Requested_Parts__r){
            Received_Part__c part = new Received_Part__c(Quantity_Received__c=rp.Quantity__c,Date_Received__c=system.today(),Request_Part__c=rp.Id);
            receives.add(part);
            break;
        }
        insert receives;    
        try{
			delete receives;        
        }Catch(Exception e){}
    }
    
    //Receive Part Trigger testing
    static testmethod void deletingReceivePartTrigger(){        
        CKSW_BASE__Service__c s = [SELECT id,Work_Order__c, (SELECT Id,Quantity__c FROM Requested_Parts__r) FROM CKSW_BASE__Service__c LIMIT 1];
        list<Received_Part__c> receives = new list<Received_Part__c>();
        for(Request_Part__c rp : s.Requested_Parts__r){
            Received_Part__c part = new Received_Part__c(Quantity_Received__c=rp.Quantity__c-1,Date_Received__c=system.today(),Request_Part__c=rp.Id);
            receives.add(part);
            break;
        }
        insert receives;    
        delete receives;        

    }
}