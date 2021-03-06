public class TestUtility {

    public static List<Account> createAccounts(Integer count) {

        List<Account> accountList = new List<Account>();
        for(Integer i=0; i<count; i++){
            accountList.add(new Account(Name= 'TestBestTS'+i, Type = 'Client', BillingCity = 'Sydney', BillingCountry = 'Australia'));
        }
        return accountList;
    }

    public static List<WorkOrder> createWorkOrders(Account account, Integer count) {
        
        List<WorkOrder> woList = new List<WorkOrder>();
        for(Integer i=0; i<count; i++){
            woList.add(new WorkOrder(AccountId = account.Id, Status = 'New', Invoice_Created__c = false));
        }
        return woList;
    }

    public static List<CKSW_BASE__Service_Type__c> createServiceTypes(Integer count) {
        
        List<CKSW_BASE__Service_Type__c> serviceTypeList = new List<CKSW_BASE__Service_Type__c>();
        for(Integer i=0; i<count; i++){
            serviceTypeList.add(new CKSW_BASE__Service_Type__c(
                                                Name = 'Test Service Type', 
                                                CKSW_BASE__Duration__c = 60.00, 
                                                CKSW_BASE__Duration_Type__c='Minutes'));
        }
        return serviceTypeList;
    }

    public static List<CKSW_BASE__Location__c> createLocations(Account account, Integer count) {
        
        List<CKSW_BASE__Location__c> locationsList = new List<CKSW_BASE__Location__c>();
        for(Integer i=0; i<count; i++){
            locationsList.add(new CKSW_BASE__Location__c(Name = 'Test Location', 
                                                         CKSW_BASE__Start_of_Day__c = '00:00', 
                                                         CKSW_BASE__Time_Zone__c = 'Australia/Sydney'));
        }
        return locationsList;
    }
    
    public static List<CKSW_BASE__Service__c> createServices(WorkOrder workorder, CKSW_BASE__Service_Type__c serviceType, CKSW_BASE__Location__c location, String status, Integer count) {
        
        List<CKSW_BASE__Service__c> servicesList = new List<CKSW_BASE__Service__c>();
        for(Integer i=0; i<count; i++){
            servicesList.add(new CKSW_BASE__Service__c(Work_Order__c = workorder.Id, 
                                                       CKSW_BASE__Status__c = status, 
                                                       CKSW_BASE__Service_Type__c = serviceType.Id, 
                                                       CKSW_BASE__Location__c = location.Id,
                                                       Created_from_Test_Class__c = true));
        }
        return servicesList;
    }

    public static List<ServiceContract> createServiceContracts(Account account, Integer count) {

        List<ServiceContract> contractsList = new List<ServiceContract>();
        for(Integer i=0; i<count; i++){
            contractsList.add(new ServiceContract(AccountId = account.Id, Name = 'Test Service Contract ' + i));
        }
        return contractsList;
    }


    // create pricing category
    public static List<Pricing_Category__c> createPricingCategory(Account account, Integer count) {

        List<Pricing_Category__c> pricingCategoriesList = new List<Pricing_Category__c>();
        for(Integer i=0; i<count; i++){
            pricingCategoriesList.add(new Pricing_Category__c(Name = 'Test Pricing Category ' + i));
        }
        return pricingCategoriesList;
    }

    // create contract pricing
    public static List<Contract_Pricing__c> createContractPricing(Id recTypeId, ServiceContract serviceContract, Pricing_Category__c pricingCategory, Integer count) {

        List<Contract_Pricing__c> contractPricingList = new List<Contract_Pricing__c>();
        for(Integer i=0; i<count; i++){
            contractPricingList.add(new Contract_Pricing__c(Name = 'Test contract pricing ' + i, 
                                                            RecordTypeId = recTypeId,
                                                            Service_Contract__c = serviceContract.Id,
                                                            Pricing_Category__c = pricingCategory.Id));
        }
        return contractPricingList;
    }



    public static List<Usage_FSL__c> createUsages(Id recTypeId, WorkOrder workorder, ServiceContract serviceContract, Contract_Pricing__c contractPricing, CKSW_BASE__Service__c service, Integer count) {

        List<Usage_FSL__c> usages = new List<Usage_FSL__c>();
        for(Integer i=0; i<count; i++){
            usages.add(new Usage_FSL__c(RecordTypeId = recTypeId,
                                        Work_Order__c = workorder.Id,
                                        Service_Contract__c = serviceContract.Id,
                                        Contract_Pricing__c = contractPricing.Id,
                                        Service__c = service.Id));
        }
        return usages;
    }

    public static List<CKSW_BASE__Resource__c> createResource(List<User> users, CKSW_BASE__Location__c location){
        List<CKSW_BASE__Resource__c> newResources = new List<CKSW_BASE__Resource__c>();
        for(User user: users){
            newResources.add(new CKSW_BASE__Resource__c(    CKSW_BASE__User__c = user.Id, 
                                                            CKSW_BASE__Active__c = true,
                                                            CKSW_BASE__Location__c = location.Id));
        }
        return newResources;
    }

    public static List<User> createUsers(Integer count, Id profileId){
        List<User> entries = new List<User>();
        for(Integer i=0; i<count; i++){
            entries.add(new User(   ProfileId = profileId, 
                                    USERNAME = 'sfuser'+i+'@proquestit.com', 
                                    LASTNAME = 'Test', 
                                    FIRSTNAME = 'Test', 
                                    EMAIL = 'noreply@chatter.salesforce.com', 
                                    EMAILPREFERENCESAUTOBCC = true, 
                                    EMAILPREFERENCESAUTOBCCSTAYINTOUCH = false, 
                                    EMAILPREFERENCESSTAYINTOUCHREMINDER = true, 
                                    ALIAS = 'sfuser'+i, 
                                    COMMUNITYNICKNAME = 'sfuser'+i, 
                                    ISACTIVE = true, 
                                    TIMEZONESIDKEY = 'Pacific/Auckland', 
                                    LOCALESIDKEY = 'en_NZ', 
                                    LANGUAGELOCALEKEY = 'en_US', 
                                    EMAILENCODINGKEY = 'ISO-8859-1' ));
        }
        return entries;
    }

    //Create the custom settings Email Service Settings
    public static void createEmailServiceSettingsCS(Id accountId){
        Email_Service_Settings__c emailServiceSettingsCS = Email_Service_Settings__c.getOrgDefaults();
        emailServiceSettingsCS.SetupOwnerId=UserInfo.getOrganizationId();
        emailServiceSettingsCS.NCR_Account_Id__c = accountId;
        upsert emailServiceSettingsCS;
    }

    public static void createLocationSettingsCS(){
        CKSW_BASE__Location__c location = new CKSW_BASE__Location__c(Name = 'Test Location', 
                                                         CKSW_BASE__Start_of_Day__c = '00:00', 
                                                         CKSW_BASE__Time_Zone__c = 'Australia/Sydney');
        insert location;

        Location_Settings__c locationSettingsCS = Location_Settings__c.getOrgDefaults();
        locationSettingsCS.Australia_Location_Id__c = location.Id;
        upsert locationSettingsCS;
    }
}