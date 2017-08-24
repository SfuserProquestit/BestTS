@isTest
public class UsageFSLHandlerTest {

    static testMethod void testRollupCalculations() {

        List<Account> accounts = TestUtility.createAccounts(2);
        insert accounts;

        List<CKSW_BASE__Service_Type__c> serviceTypes = TestUtility.createServiceTypes(2);
        insert serviceTypes;

        List<WorkOrder> workorders = TestUtility.createWorkOrders(accounts.get(0), 2);
        insert workorders;

        List<CKSW_BASE__Location__c> locations = TestUtility.createLocations(accounts.get(0), 2);
        insert locations;

        List<CKSW_BASE__Service__c> services = TestUtility.createServices(workorders.get(0), serviceTypes.get(0), locations.get(0), Constants.SERVICE_STATUS_IN_PROGRESS, 2);
        insert services;

        List<ServiceContract> servicecontracts = TestUtility.createServiceContracts(accounts.get(0), 2);
        insert servicecontracts;

        List<Pricing_Category__c> pricingCategories = TestUtility.createPricingCategory(accounts.get(0), 2);
        insert pricingCategories;

        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Contract_Pricing__c);
        Id pricingCategoryRT = rtMap.get(Constants.CONTRACT_PRICING_RECORD_TYPE_MARKUP_BASED).getRecordTypeId(); 

        List<Contract_Pricing__c> contractPricings = TestUtility.createContractPricing(pricingCategoryRT, servicecontracts.get(0), pricingCategories.get(0), 2);
        insert contractPricings;

        rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Usage_FSL__c);
        Id usageRT = rtMap.get(Constants.USAGE_RECORD_TYPE_STANDARD_USAGE).getRecordTypeId(); 

        Test.startTest();
            List<Usage_FSL__c> usages = TestUtility.createUsages(usageRT, workorders.get(0), servicecontracts.get(0), contractPricings.get(0), services.get(0), 2);
            usages.get(0).Total_Engineering_Cost__c = 10.00;
            usages.get(0).Total_Engineering_Revenue__c = 100.00;
            usages.get(0).Total_Pass_Through_Cost__c = 40.00;
            usages.get(0).Total_Pass_Through_Revenue__c = 400.00;


            usages.get(1).Total_Engineering_Cost__c = 30.00;
            usages.get(1).Total_Engineering_Revenue__c = 400.00;
            usages.get(1).Total_Pass_Through_Cost__c = 10.00;
            usages.get(1).Total_Pass_Through_Revenue__c = 100.00;

            insert usages;
        
        Test.stopTest();
        
        List<CKSW_BASE__Service__c> updatedservices = [SELECT Service_Engineering_Cost__c, Service_Engineering_Revenue__c, 
                                                                Service_Pass_Through_Cost__c, Service_Pass_Through_Revenue__c 
                                                       FROM CKSW_BASE__Service__c 
                                                       WHERE Id =: services.get(0).Id];
        System.assert(updatedservices.size() > 0);                                                
        System.assertEquals(40.00, updatedservices.get(0).Service_Engineering_Cost__c);
        System.assertEquals(500.00, updatedservices.get(0).Service_Engineering_Revenue__c);
        System.assertEquals(50.00, updatedservices.get(0).Service_Pass_Through_Cost__c);
        System.assertEquals(500.00, updatedservices.get(0).Service_Pass_Through_Revenue__c);
        
       
    }
    
    static testMethod void testUsageDelete() {

        List<Account> accounts = TestUtility.createAccounts(2);
        insert accounts;

        List<CKSW_BASE__Service_Type__c> serviceTypes = TestUtility.createServiceTypes(2);
        insert serviceTypes;

        List<WorkOrder> workorders = TestUtility.createWorkOrders(accounts.get(0), 2);
        insert workorders;

        List<CKSW_BASE__Location__c> locations = TestUtility.createLocations(accounts.get(0), 2);
        insert locations;

        List<CKSW_BASE__Service__c> services = TestUtility.createServices(workorders.get(0), serviceTypes.get(0), locations.get(0), Constants.SERVICE_STATUS_IN_PROGRESS, 2);
        insert services;

        List<ServiceContract> servicecontracts = TestUtility.createServiceContracts(accounts.get(0), 2);
        insert servicecontracts;

        List<Pricing_Category__c> pricingCategories = TestUtility.createPricingCategory(accounts.get(0), 2);
        insert pricingCategories;

        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Contract_Pricing__c);
        Id pricingCategoryRT = rtMap.get(Constants.CONTRACT_PRICING_RECORD_TYPE_MARKUP_BASED).getRecordTypeId(); 

        List<Contract_Pricing__c> contractPricings = TestUtility.createContractPricing(pricingCategoryRT, servicecontracts.get(0), pricingCategories.get(0), 2);
        insert contractPricings;

        rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Usage_FSL__c);
        Id usageRT = rtMap.get(Constants.USAGE_RECORD_TYPE_STANDARD_USAGE).getRecordTypeId(); 
        
        List<Usage_FSL__c> usages = TestUtility.createUsages(usageRT, workorders.get(0), servicecontracts.get(0), contractPricings.get(0), services.get(0), 2);
        usages.get(0).Total_Engineering_Cost__c = 10.00;
        usages.get(0).Total_Engineering_Revenue__c = 100.00;
        usages.get(0).Total_Pass_Through_Cost__c = 40.00;
        usages.get(0).Total_Pass_Through_Revenue__c = 400.00;

        insert usages;
        
        List<WorkOrder> newworkorders = [SELECT Id, Invoice_Created__c FROM WorkOrder WHERE Id =: workorders.get(0).Id];
        newworkorders.get(0).Status = 'Closed';
        newworkorders.get(0).Invoice_Created__c = true;
        update newworkorders.get(0);
        
        Test.startTest();
            try{
                delete usages.get(0);
            } catch(Exception exp) {
                System.assert(exp.getMessage().contains(Label.CannotDeleteUsage));
            }
            
        Test.stopTest();
    }
}