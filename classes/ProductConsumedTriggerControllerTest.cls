/*
*   Test class for ProductConsumedTriggerController
*   Created by Joey Ho 13/08/2017
*/
@isTest
public class ProductConsumedTriggerControllerTest {
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
    }
    
    //Add and update new Service Part on Service 
    static testmethod void addNewServiceParts(){
        WorkOrder woService = [SELECT id, ParentWorkOrderId FROM WorkOrder WHERE RecordType.Name=:Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER LIMIT 1];
        list<productItem> listPIs = [SELECT id,Product2Id,LocationId,QuantityUnitOfMeasure,QuantityOnHand FROM productItem];
        
        list<Service_Part__c> sparts = new list<Service_Part__c>();
        list<Service_Part__c> add_sparts = new list<Service_Part__c>();
        list<Service_Part__c> over_sparts = new list<Service_Part__c>();

        for(ProductItem pi:listPIs){
            sparts.add(new Service_Part__c(Work_Order__c=woService.ParentWorkOrderId,Work_Order_Service__c=woService.Id,Product_Item__c=pi.Id,Quantity_Consumed__c=pi.QuantityOnHand));
            over_sparts.add(new Service_Part__c(Work_Order__c=woService.ParentWorkOrderId,Work_Order_Service__c=woService.Id,Product_Item__c=pi.Id,Quantity_Consumed__c=pi.QuantityOnHand+10));
        }
        
        test.startTest();
        //Over additing items
        try{
            insert over_sparts;
        }Catch(Exception e){}
        
        //Normal additing items
        insert sparts;
        
        //Adding items not in stock
        for(ProductItem pi:listPIs){
            add_sparts.add(new Service_Part__c(Work_Order__c=woService.ParentWorkOrderId, Work_Order_Service__c=woService.Id,Product_Item__c=pi.Id,Quantity_Consumed__c=1));
        }        
        try{
            insert add_sparts;
        }Catch(Exception e){}
        
        /*//Adding items not in van
        ProductItem prod = TestDataFactory.createNewProductItems(1)[0];
        insert prod;  
        Service_Part__c spa = new Service_Part__c(Service__c=s.Id,Product_Item__c=prod.Id,Quantity_Consumed__c=1);
        try{
            insert spa;
        }Catch(Exception e){}
    */  
        test.stopTest();
    }
    
    //Update Service Parts 
    static testmethod void updateServiceParts(){
        WorkOrder woService = [SELECT id, ParentWorkOrderId FROM WorkOrder WHERE RecordType.Name=:Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER LIMIT 1];
        list<productItem> listPIs = [SELECT id,Product2Id,LocationId,QuantityUnitOfMeasure,QuantityOnHand FROM productItem];  
        list<Service_Part__c> sparts = new list<Service_Part__c>();
        
        for(ProductItem pi:listPIs){
            sparts.add(new Service_Part__c(Work_Order__c=woService.ParentWorkOrderId,Work_Order_Service__c=woService.Id,Product_Item__c=pi.Id,Quantity_Consumed__c=pi.QuantityOnHand-1));
        }
        insert sparts;
        
        for(Service_Part__c sp :sparts){
            sp.Quantity_Consumed__c++;
        }        
        
        test.startTest();
        update sparts;
                
        //Update with error
        ProductConsumedTriggerController.flag_updateSerivceParts = false;
        ProductItem pp = [SELECT id FROM ProductItem Limit 1];
        for(Service_Part__c sp :sparts){
            sp.Product_Item__c=pp.id;
        }
        try{
            update sparts;
        }Catch(Exception e){}
                
        //Delete Service Parts
        delete sparts;
        
        test.stopTest();
    }
}