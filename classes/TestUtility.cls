public class TestUtility {

    public static List<Account> createAccounts(Integer count) {

        List<Account> accountList = new List<Account>();
        for(Integer i=0; i<count; i++){
            accountList.add(new Account(Name= 'TestBestTS'+i, Type = 'Client', BillingCity = 'Sydney', BillingCountry = 'Australia'));
        }
        return accountList;
    }

    public static List<WorkOrder> createWorkOrders(Account account, String recordTypeName, Integer count) {
        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.WorkOrder);
        Id woRecordTypeId = rtMap.get(recordTypeName).getRecordTypeId();
        List<WorkOrder> woList = new List<WorkOrder>();
        for(Integer i=0; i<count; i++){
            woList.add(new WorkOrder(RecordTypeId =woRecordTypeId,
                                     AccountId = account.Id, 
                                     Status = 'New', 
                                     Invoice_Created__c = false));
        }
        return woList;
    }

    public static List<WorkOrder> createChildWorkOrders(Account account, WorkOrder parentWorkOrder, String recordTypeName, Integer count) {
        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.WorkOrder);
        Id woRecordTypeId = rtMap.get(recordTypeName).getRecordTypeId();
        List<WorkOrder> woList = new List<WorkOrder>();
        for(Integer i=0; i<count; i++){
            woList.add(new WorkOrder(RecordTypeId =woRecordTypeId,
                                     AccountId = account.Id, 
                                     Status = 'New', 
                                     Invoice_Created__c = false,
                                     ParentWorkOrderId = parentWorkOrder.Id));
        }
        return woList;
    }

    public static List<ServiceAppointment> createServiceAppointments(Set<Id> parentRecordIds, Integer nbServiceAppointments){
        List<ServiceAppointment> serviceAppointments = new List<ServiceAppointment>();
        for(Id parentRecordId : parentRecordIds){
            for(Integer i=0; i<nbServiceAppointments; i++){
                serviceAppointments.add(new ServiceAppointment( ParentRecordId = parentRecordId,
                                                                //Status=Constants.SERVICE_APPOINTMENT_STATUS_NEW,
                                                                DueDate = Datetime.now().addDays(10),
                                                                EarliestStartTime = Datetime.now(),
                                                                SchedStartTime = Datetime.now(),
                                                                SchedEndTime = Datetime.now().addHours(1),
                                                                Duration = 60,
                                                                DurationType=Constants.SERVICE_APPOINTMENT_DURATION_TYPE_MINUTES));
            }
        }
        return serviceAppointments;
    }

    public static List<User> createCommunityUserTechnicians(Integer count){
        Profile techProfile = [Select Id From Profile Where Name LIKE :Constants.PROFILE_NAME_FOR_COMMUNITY_TECHNICIAN];
        return createCommunityUsers(count, techProfile.Id);
    }

    public static List<User> createCommunityUsers(Integer count, Id profileId){
        User sysAdmin = [SELECT Id FROM User WHERE Profile.Name='System Administrator' AND UserRoleId != null AND IsActive = true LIMIT 1][0];
        List<User> users = new List<User>();
        System.runAs(sysAdmin){
            Account bestAccount = new Account(Name='Best');
            insert bestAccount;

            List<Contact> contacts = new List<Contact>();

            for(Integer i=0; i<count; i++){
                contacts.add(new Contact(FirstName='Test',
                                        LastName='Test Last Name',
                                        AccountId = bestAccount.Id));
            }
            insert contacts;

            UserRole communityRole = [Select Id From UserRole Where PortalType = 'CustomerPortal' Limit 1][0];
            Integer i=0;
            for(Contact contact : contacts){
                users.add(new User(   ProfileId = profileId, 
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
                                        TIMEZONESIDKEY = 'Australia/Sydney', 
                                        LOCALESIDKEY = 'en_AU', 
                                        LANGUAGELOCALEKEY = 'en_US', 
                                        EMAILENCODINGKEY = 'ISO-8859-1',
                                        ContactId=contact.Id));
                i++;
            }
            insert users;
        }
        return users;
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
                                    TIMEZONESIDKEY = 'Australia/Sydney', 
                                    LOCALESIDKEY = 'en_AU', 
                                    LANGUAGELOCALEKEY = 'en_US', 
                                    EMAILENCODINGKEY = 'ISO-8859-1' ));
        }
        return entries;
    }

    public static List<ServiceResource> createServiceResources(List<User> users, String serviceResourceType){
        List<ServiceResource> serviceResources = new List<ServiceResource>();
        for(User user : users){
            serviceResources.add(new ServiceResource(Name = user.FirstName + ' ' + user.LastName,
                                                    IsActive = true,
                                                    ResourceType = serviceResourceType,
                                                    RelatedRecordId = user.Id));
        }
        return serviceResources;
    }

    public static void assignServiceResourcesToServiceTerritory(List<ServiceResource> serviceResources, ServiceTerritory territory){
        Map<Id,ServiceResource> serviceResourcesById = new Map<Id,ServiceResource>(serviceResources);
        List<ServiceTerritoryMember> stms = [SELECT Id,ServiceResourceId, ServiceTerritoryId, TerritoryType, EffectiveStartDate, EffectiveEndDate FROM ServiceTerritoryMember WHERE ServiceResourceId IN :serviceResourcesById.keySet() AND TerritoryType='P' AND EffectiveStartDate<=:DateTime.Now() AND (EffectiveEndDate=null OR EffectiveEndDate >=:DateTime.Now())];
        if(territory == null){
            territory = createServiceTerritories(1)[0];
        }

        List<ServiceTerritoryMember> stmsToInsert = new List<ServiceTerritoryMember>();
        for(ServiceResource sr : serviceResources){
            Boolean hasPrimaryServiceTerritory = false;
            for(ServiceTerritoryMember stm : stms){
                if(sr.Id == stm.ServiceResourceId){
                    hasPrimaryServiceTerritory=true;
                    break;
                }
            }
            if(!hasPrimaryServiceTerritory){
                stmsToInsert.add(new ServiceTerritoryMember(ServiceResourceId=sr.Id, ServiceTerritoryId=territory.Id, TerritoryType='P',EffectiveStartDate=Date.Today().addDays(-1), EffectiveEndDate=Date.Today().addDays(1)));
            }
        }
        if(stmsToInsert.size()>0){
            insert stmsToInsert;
        }
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

    //Create the custom settings Email Service Settings
    public static void createEmailServiceSettingsCS(Id accountId){
        Email_Service_Settings__c emailServiceSettingsCS = Email_Service_Settings__c.getOrgDefaults();
        emailServiceSettingsCS.SetupOwnerId=UserInfo.getOrganizationId();
        emailServiceSettingsCS.NCR_Account_Id__c = accountId;
        upsert emailServiceSettingsCS;
    }

    public static void createLocationSettingsCS(){
        OperatingHours opHours = new OperatingHours(Name='Operating Hours', TimeZone='Australia/Sydney');
        insert opHours;

        ServiceTerritory location = new ServiceTerritory(Name = 'Test Location', 
                                                         OperatingHoursId = opHours.Id,
                                                         IsActive=true);
        insert location;

        Location_Settings__c locationSettingsCS = Location_Settings__c.getOrgDefaults();
        locationSettingsCS.Australia_Location_Id__c = location.Id;
        upsert locationSettingsCS;
    }

    public static void createActivateTriggerCS(){
        ActivateTriggers__c activateTriggerCS = ActivateTriggers__c.getOrgDefaults();
        activateTriggerCS.Enabled__c = true;
        upsert activateTriggerCS;       
    }

    public static List<ServiceTerritory> createServiceTerritories(Integer nbServiceTerritory){
        OperatingHours opHours = new OperatingHours(Name='Operating Hours', TimeZone='Australia/Sydney');
        insert opHours;

        List<ServiceTerritory> territories = new List<ServiceTerritory>();
        for(Integer i=0; i<nbServiceTerritory; i++){
            ServiceTerritory territory = new ServiceTerritory(Name = 'Test Service Territory '+i, 
                                                             OperatingHoursId = opHours.Id,
                                                             IsActive=true);
            territories.add(territory);
        }
        insert territories;
        return territories;
    }

    public static List<Usage_FSL__c> createUsages(Id recTypeId, WorkOrder parentWorkorder, ServiceContract serviceContract, Contract_Pricing__c contractPricing, WorkOrder childWorkOrder, Integer count) {

        List<Usage_FSL__c> usages = new List<Usage_FSL__c>();
        for(Integer i=0; i<count; i++){
            usages.add(new Usage_FSL__c(RecordTypeId = recTypeId,
                                        Work_Order__c = parentWorkorder.Id,
                                        Service_Contract__c = serviceContract.Id,
                                        Contract_Pricing__c = contractPricing.Id,
                                        Service_Work_Order__c = childWorkOrder.Id));
        }
        return usages;
    }

    public static List<WorkType> createWorkTypes(Integer count) {
        List<WorkType> workTypes = new List<WorkType>();
        for(Integer i=0; i<count; i++){
            workTypes.add(new WorkType(Name = 'Test Work Type', 
                                        EstimatedDuration = 60.00, 
                                        DurationType='Minutes'));
        }
        return workTypes;
    }

    //Return list of ProductItems of a Van given length of number of products to create
    public static List<ProductItem> createNewProductItems(integer len){
        List<Product2> prodList = new list<Product2>();
        for(integer i=0;i<len;i++){
            prodList.add(new Product2(Name='Product-'+i,ProductCode='Code-'+i,Description='Description-'+i,IsActive=true,QuantityUnitOfMeasure='Each'));
        }
        insert prodList;

        Schema.Location van = new Schema.Location(Name='Van', LocationType='Van',IsInventoryLocation=true,isMobile=true);
        insert van;

        List<ProductItem> items = new List<ProductItem>();
        for(Product2 p : prodList){
            ProductItem pi = new ProductItem(Product2Id=p.Id, LocationId=van.Id, QuantityUnitOfMeasure=p.QuantityUnitOfMeasure,QuantityOnHand=10);
            items.add(pi);
        }
        return items;
    }

    //Return list of Service Parts for a Service Work Order
    public static List<Service_Part__c> createNewServiceParts(WorkOrder woService, List<ProductItem> productList){
        List<Service_Part__c> spList = new List<Service_Part__c>();
        for(ProductItem pit:productList){
            Service_Part__c sp = new Service_Part__c(Work_Order_Service__c=woService.Id,Product_Item__c=pit.Id,Quantity_Consumed__c=1);
            spList.add(sp);
        }

        return spList;
    }

    //public retunr list of Request_Part__c for a Service Work Order
    public static List<Request_Part__c> createNewPartRequest(WorkOrder woService, List<ProductItem> productList){
        List<Request_Part__c> partsList = new List<Request_Part__c>();
        for(ProductItem pit:productList){
            Request_Part__c part = new Request_Part__c(Work_Order_Service__c=woService.Id,Product_Name__c=pit.Product2Id,Quantity__c=5);
            partsList.add(part);
        }

        return partsList;
    }
}