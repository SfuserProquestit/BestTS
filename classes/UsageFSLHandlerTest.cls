@isTest
public class UsageFSLHandlerTest {

    @isTest
    static void testRollupCalculations() {
        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        List<ServiceContract> servicecontracts = TestUtility.createServiceContracts(account, 2);
        insert servicecontracts;

        List<Pricing_Category__c> pricingCategories = TestUtility.createPricingCategory(account, 2);
        insert pricingCategories;

        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Contract_Pricing__c);
        Id pricingCategoryRT = rtMap.get(Constants.CONTRACT_PRICING_RECORD_TYPE_MARKUP_BASED).getRecordTypeId(); 

        List<Contract_Pricing__c> contractPricings = TestUtility.createContractPricing(pricingCategoryRT, servicecontracts[0], pricingCategories[0], 2);
        insert contractPricings;

        rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Usage_FSL__c);
        Id usageRT = rtMap.get(Constants.USAGE_RECORD_TYPE_STANDARD_USAGE).getRecordTypeId(); 

        Test.startTest();
            List<Usage_FSL__c> usages = TestUtility.createUsages(usageRT, parentWorkOrders[0], servicecontracts[0], contractPricings[0], childWorkOrders[0], 2);
            usages[0].Total_Engineering_Cost__c = 10.00;
            usages[0].Total_Engineering_Revenue__c = 100.00;
            usages[0].Total_Pass_Through_Cost__c = 40.00;
            usages[0].Total_Pass_Through_Revenue__c = 400.00;


            usages[1].Total_Engineering_Cost__c = 30.00;
            usages[1].Total_Engineering_Revenue__c = 400.00;
            usages[1].Total_Pass_Through_Cost__c = 10.00;
            usages[1].Total_Pass_Through_Revenue__c = 100.00;

            insert usages;
        
        Test.stopTest();
        
        childWorkOrders = [SELECT Service_Engineering_Cost__c, Service_Engineering_Revenue__c, 
                                    Service_Pass_Through_Cost__c, Service_Pass_Through_Revenue__c 
                           FROM WorkOrder 
                           WHERE Id = :childWorkOrders[0].Id];           
        System.assertEquals(40.00, childWorkOrders[0].Service_Engineering_Cost__c);
        System.assertEquals(500.00, childWorkOrders[0].Service_Engineering_Revenue__c);
        System.assertEquals(50.00, childWorkOrders[0].Service_Pass_Through_Cost__c);
        System.assertEquals(500.00, childWorkOrders[0].Service_Pass_Through_Revenue__c);
    }

    @isTest
    static void testSetParentWorkOrder() {
        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        List<ServiceContract> servicecontracts = TestUtility.createServiceContracts(account, 2);
        insert servicecontracts;
        childWorkOrders[0].ServiceContractId = servicecontracts[0].Id;
        update childWorkOrders[0];

        List<Pricing_Category__c> pricingCategories = TestUtility.createPricingCategory(account, 2);
        insert pricingCategories;

        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Contract_Pricing__c);
        Id pricingCategoryRT = rtMap.get(Constants.CONTRACT_PRICING_RECORD_TYPE_MARKUP_BASED).getRecordTypeId(); 

        List<Contract_Pricing__c> contractPricings = TestUtility.createContractPricing(pricingCategoryRT, servicecontracts[0], pricingCategories[0], 2);
        insert contractPricings;

        rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Usage_FSL__c);
        Id usageRT = rtMap.get(Constants.USAGE_RECORD_TYPE_STANDARD_USAGE).getRecordTypeId(); 

        Test.startTest();
            List<Usage_FSL__c> usages = new List<Usage_FSL__c>();
            for(Integer i=0; i<2; i++){
                usages.add(new Usage_FSL__c(RecordTypeId = usageRT,
                                            Contract_Pricing__c = contractPricings[0].Id,
                                            Service_Work_Order__c = childWorkOrders[0].Id));
            }
            insert usages;
        Test.stopTest();
        
        usages = [SELECT Work_Order__c, Service_Contract__c FROM Usage_FSL__c];
        for(Usage_FSL__c usage : usages){
            System.assertEquals(childWorkOrders[0].ParentWorkOrderId,usage.Work_Order__c);
            System.assertEquals(childWorkOrders[0].ServiceContractId,usage.Service_Contract__c);
        }
    }

    @isTest
    static void testUsageDelete() {

        Account account = TestUtility.createAccounts(1)[0];
        insert account;

        List<WorkOrder> parentWorkOrders = TestUtility.createWorkOrders(account, Constants.RECORD_TYPE_MASTER_WORK_ORDER, 1);
        insert parentWorkOrders;

        List<WorkOrder> childWorkOrders = TestUtility.createChildWorkOrders(account, parentWorkOrders[0], Constants.RECORD_TYPE_STANDARD_SERVICE_WORK_ORDER, 2);
        insert childWorkOrders;

        List<ServiceContract> servicecontracts = TestUtility.createServiceContracts(account, 2);
        insert servicecontracts;

        List<Pricing_Category__c> pricingCategories = TestUtility.createPricingCategory(account, 2);
        insert pricingCategories;

        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Contract_Pricing__c);
        Id pricingCategoryRT = rtMap.get(Constants.CONTRACT_PRICING_RECORD_TYPE_MARKUP_BASED).getRecordTypeId(); 

        List<Contract_Pricing__c> contractPricings = TestUtility.createContractPricing(pricingCategoryRT, servicecontracts[0], pricingCategories[0], 2);
        insert contractPricings;

        rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.Usage_FSL__c);
        Id usageRT = rtMap.get(Constants.USAGE_RECORD_TYPE_STANDARD_USAGE).getRecordTypeId();
        List<Usage_FSL__c> usages = TestUtility.createUsages(usageRT, parentWorkOrders[0], servicecontracts[0], contractPricings[0], childWorkOrders[0], 2);
        insert usages;
        
        parentWorkOrders[0].Status = 'Closed';
        parentWorkOrders[0].Invoice_Created__c = true;
        update parentWorkOrders[0];

        Test.startTest();
            try{
                delete usages[0];
            } catch(Exception exp) {
                System.assert(exp.getMessage().contains(Label.CannotDeleteUsage));
            }
        Test.stopTest();
    }
}