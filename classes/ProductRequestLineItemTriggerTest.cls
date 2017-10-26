/*
*   Test class for ProductRequestLineItemTriggerController
*   Created by Joey Ho 02/08/2017
*/
@isTest
public class ProductRequestLineItemTriggerTest {
    
    @testSetup
    private static void init(){
        TestUtility.createActivateTriggerCS();
        TestUtility.createLocationSettingsCS();
        
        List<ProductItem> productItems = TestUtility.createNewProductItems(5);
        insert productItems;

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        ServiceContract sContract = TestUtility.createServiceContracts(account, 1)[0];
        insert sContract;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account,Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;
        
        WorkOrder woService = [SELECT id FROM WorkOrder WHERE RecordType.Name=:Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER LIMIT 1];
        list<productItem> listPIs = [SELECT id,Product2Id,LocationId,QuantityUnitOfMeasure,QuantityOnHand FROM productItem];
        
        list<Request_Part__c> rplist = TestUtility.createNewPartRequest(woService,listPIs);
        insert rplist;

    }
    
    //Add and update new Request Part on Service Work Order
    static testmethod void addNewRequestLines(){
        
        //Check 5 units from Service Contract
        WorkOrder woService = [SELECT id,ParentWorkOrderId, (SELECT Id,Quantity__c,Product_Name__c  FROM Request_Parts1__r) FROM WorkOrder WHERE RecordType.Name=:Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER LIMIT 1];

        Test.startTest();
     
		ProductRequest pr = new ProductRequest(WorkOrderId=woService.ParentWorkOrderId);
        insert pr;

        list<Request_Part__c> rp1 = woService.Request_Parts1__r;
        for(Request_Part__c rp:rp1){
            rp.Product_Request__c = pr.Id;
        }
        update rp1;

        list<ProductRequestLineItem> rList = new list<ProductRequestLineItem>();
        for(Request_Part__c rp: woService.Request_Parts1__r){
            ProductRequestLineItem p = new ProductRequestLineItem(Product2Id = rp.Product_Name__c, ParentId=pr.Id, QuantityRequested=rp.Quantity__c+1);
            rList.add(p);
        }
        insert rList;
        
        //Update from Service Request Part records
        ProductRequestLineItemTriggerController.flag_updateProductRequestLineItems = false;
        list<Request_Part__c> rr = woService.Request_Parts1__r;
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
        WorkOrder woService = [SELECT id,ParentWorkOrderId, (SELECT Id,Quantity__c FROM Request_Parts1__r) FROM WorkOrder WHERE RecordType.Name=:Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER LIMIT 1];
		delete woService.Request_Parts1__r;
    }
    
    //Deleting Require Part items with error
    static testmethod void deletingRequestParts2(){        
        WorkOrder woService = [SELECT id,ParentWorkOrderId, (SELECT Id,Quantity__c FROM Request_Parts1__r) FROM WorkOrder WHERE RecordType.Name=:Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER LIMIT 1];
        list<Request_Part__c> rr = woService.Request_Parts1__r;
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
        WorkOrder woService = [SELECT id,ParentWorkOrderId, (SELECT Id,Quantity__c FROM Request_Parts1__r) FROM WorkOrder WHERE RecordType.Name=:Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER LIMIT 1];
        list<Received_Part__c> receives = new list<Received_Part__c>();
        for(Request_Part__c rp : woService.Request_Parts1__r){
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
        WorkOrder woService = [SELECT id,ParentWorkOrderId, (SELECT Id,Quantity__c FROM Request_Parts1__r) FROM WorkOrder WHERE RecordType.Name=:Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER LIMIT 1];
        list<Received_Part__c> receives = new list<Received_Part__c>();
        for(Request_Part__c rp : woService.Request_Parts1__r){
            Received_Part__c part = new Received_Part__c(Quantity_Received__c=rp.Quantity__c-1,Date_Received__c=system.today(),Request_Part__c=rp.Id);
            receives.add(part);
            break;
        }
        insert receives;    
        delete receives;        

    }
}