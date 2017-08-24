/*
*   Pure test data for test classes
*   Created by Joey Ho 02/08/2017
*/
@isTest
public class TestDataFactory{

	//Return list of ProductItems of a Van given length of number of products to create
	public static list<ProductItem> createNewProductItems(integer len){
		list<Product2> prodList = new list<Product2>();
		for(integer i=0;i<len;i++)
			prodList.add(new Product2(Name='Product-'+i,ProductCode='Code-'+i,Description='Description-'+i,IsActive=true,QuantityUnitOfMeasure='Each'));

		insert prodList;

		Schema.Location van = new Schema.Location(Name='Van', LocationType='Van',IsInventoryLocation=true,isMobile=true);
		insert van;

		list<ProductItem> items = new list<ProductItem>();
		for(Product2 p : prodList){
			ProductItem pi = new ProductItem(Product2Id=p.Id, LocationId=van.Id, QuantityUnitOfMeasure=p.QuantityUnitOfMeasure,QuantityOnHand=10);
			items.add(pi);
		}
		return items;
	}

	//Returns service contract from a create account and Contact without inserting record
	public static list<ServiceContract> createNewSCRecords(integer len){
		Account acc = new Account(Name='Company Name', type='Clien');
		insert acc;
		Contact con = new Contact(AccountId=acc.id, FirstName='FirstName', LastName='LastName', email='email@test.email.com');
		insert con;

		list<ServiceContract> scList = new list<ServiceContract>();
		for(integer i=0; i<len;i++){
			ServiceContract sc = new ServiceContract(Name='Contract-Name'+i, AccountId=acc.Id, ContactId=con.Id,Global_ContracT__c='No',
													StartDate=system.today(), EndDate=system.today()+30);
			scList.add(sc);
		}

		return scList;
	}

	//returns new Work Order based on a SC input
	public static list<WorkOrder> createNewWOs(ServiceContract sc,integer len){
		list<WorkOrder> woList = new list<WorkOrder>();
		for(integer i=0; i<len;i++){
			WorkOrder wo = new WorkOrder(AccountId=sc.AccountId,ServiceContractId=sc.Id,Site_Name__c='Site-Name'+i);
			woList.add(wo);
		}
		return woList;
	}

	//Returns a Service Type record for a Service 
	public static list<CKSW_BASE__Service_Type__c> createNewServiceTypes(integer len){
		list<CKSW_BASE__Service_Type__c> stList = new list<CKSW_BASE__Service_Type__c>();
		for(integer i=0; i<len;i++){
			CKSW_BASE__Service_Type__c st = new CKSW_BASE__Service_Type__c(Name='ServiceType'+i, CKSW_BASE__Duration__c=60+i);
			stList.add(st);
		}
		return stList;
	}	

	//REturns Service records for field service lightning
	public static list<CKSW_BASE__Service__c> createNewServices(WorkOrder wo,integer len){
		list<CKSW_BASE__Service__c> services = new list<CKSW_BASE__Service__c>();
		for(integer i=0; i<len;i++){
			CKSW_BASE__Service__c s = new CKSW_BASE__Service__c(CKSW_BASE__Status__c='In Progress',Work_Order__c=wo.Id,Site_Name__c=wo.Site_Name__c,
											CKSW_BASE__Account__c=wo.AccountId);
			services.add(s);
		}

		return services;
	}

	//Return list of Service Parts for a Service
	public static list<Service_Part__c> createNewServiceParts(CKSW_BASE__Service__c serv, list<ProductItem> productList){
		list<Service_Part__c> spList = new list<Service_Part__c>();
		for(ProductItem pit:productList){
			Service_Part__c sp = new Service_Part__c(Service__c=serv.Id,Product_Item__c=pit.Id,Quantity_Consumed__c=1);
			spList.add(sp);
		}

		return spList;
	}

	//public retunr list of Request_Part__c for a Service.
	public static list<Request_Part__c> createNewPartRequest(CKSW_BASE__Service__c serv, list<ProductItem> productList){
		list<Request_Part__c> partsList = new list<Request_Part__c>();
		for(ProductItem pit:productList){
			Request_Part__c part = new Request_Part__c(Service__c=serv.Id,Product_Name__c=pit.Product2Id,Quantity__c=5);
			partsList.add(part);
		}

		return partsList;
	}
    
    //Sets data up
    public static void setData(){   
        list<ProductItem> productItems;
        ServiceContract sContract;
        WorkOrder wOrder;
        CKSW_BASE__Service_Type__c sType; 
        CKSW_BASE__Service__c service;
        
    	productItems = TestDataFactory.createNewProductItems(5);
        insert productItems;                
        
        sContract = TestDataFactory.createNewSCRecords(1)[0];
        insert sContract;
        
        wOrder = TestDataFactory.createNewWOs(sContract, 1)[0];
        insert wOrder;
        
        sType = TestDataFactory.createNewServiceTypes(1)[0];
        insert sType;
        
        service = TestDataFactory.createNewServices(wOrder, 1)[0];
        service.CKSW_BASE__Service_Type__c = sType.Id;
        insert service;       
    }
}