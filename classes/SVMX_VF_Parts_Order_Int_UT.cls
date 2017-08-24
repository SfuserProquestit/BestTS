public class SVMX_VF_Parts_Order_Int_UT 
{
	public static testmethod void test()
	{
		PageReference pageRef = new PageReference('Page.SVMX_VF_Parts_Order_Int');
        Test.setCurrentPage(pageRef);

        Account  account = new Account(Name ='Account',ShippingStreet='ABC',ShippingCity='PQR ',ShippingState = 'XYZ',ShippingPostalCode='111',ShippingCountry='XYZ',BillingStreet='ABC',BillingCity='PQR ',BillingState = 'XYZ',BillingPostalCode='111',BillingCountry='XYZ'); 
        insert account;
        
        Contact contact = new Contact(LastName='Last',AccountId =account.Id,Email='svmxmailfortest@gmail.com');
        insert contact;
        
        Case case1 = new Case(Status ='New', Priority = 'Medium',Origin = 'Email',ContactId =contact.Id,AccountId=account.Id); 
        insert case1; 
        
        RecordType[] rts = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'SVMXC__RMA_Shipment_Order__c'];
        SVMXC__RMA_Shipment_Order__c PartsOrder;

        Product2 pr2 = new Product2(Name = 'prodPR2',ProductCode='prodPR2',SVMXC__Inherit_Parent_Warranty__c =True);
        insert pr2; 
         
        SVMXC__Site__c location1 = new SVMXC__Site__c(Name = 'loc1',SVMXC__Stocking_Location__c = true,SVMXC__Account__c = account.Id,SVMXC__Street__c = 'millers road',SVMXC__Country__c = 'india',SVMXC__Zip__c = '123456');
        //SVMXC__Stocking_Location__c =true,  
        insert location1;
         
        SVMXC__Site__c location2 = new SVMXC__Site__c(Name = 'loc2',SVMXC__Stocking_Location__c = true,SVMXC__Account__c = account.Id,SVMXC__Street__c = 'millers road',SVMXC__Country__c = 'india',SVMXC__Zip__c = '123456');
        //SVMXC__Stocking_Location__c =true,  
        insert location2;
        
		list<SVMXC__RMA_Shipment_Order__c> oRSO= new list<SVMXC__RMA_Shipment_Order__c>();
        SVMXC__RMA_Shipment_Order__c o1;
        SVMXC__RMA_Shipment_Order__c o2;
        for(RecordType rt : rts){ //Loop to take a record type at a time
        // Create Module Record
        if(rt.Name == 'Shipment'){
            o1 = new SVMXC__RMA_Shipment_Order__c(RecordTypeId =rt.Id,SVMXC__Company__c = account.Id,SVMXC__Contact__c = contact.Id,SVMXC__Case__c = case1.id,SVMXC__Order_Status__c = 'open',SVMXC__Expected_Delivery_Date__c = system.today(),SVMXC__Source_Location__c = location1.Id,SVMXC__Destination_Location__c = location2.id);
            o2 = new SVMXC__RMA_Shipment_Order__c(RecordTypeId =rt.Id,SVMXC__Company__c = account.Id,SVMXC__Contact__c = contact.Id,SVMXC__Case__c = case1.id,SVMXC__Order_Status__c = 'open',SVMXC__Expected_Delivery_Date__c = system.today(),SVMXC__Source_Location__c = location1.Id,SVMXC__Destination_Location__c = location2.id);
            } 
        }
        try{
        o1.SVMXC__Order_Status__c = 'Open';
        o2.SVMXC__Order_Status__c = 'Open';
        
		oRSO.add(o1);
		insert oRSO;
		ApexPages.StandardSetController setController = new ApexPages.StandardSetController(oRSO);
		setController.setselected(oRSO);
		SVMX_VF_Parts_Order_Int controller = new SVMX_VF_Parts_Order_Int(setController);
		
		controller.insertRec();
		controller.getisInsert(); 
		
		oRSO.add(o2);
		PageReference pageRef2 = new PageReference('Page.SVMX_VF_Parts_Order_Int');
        Test.setCurrentPage(pageRef2);
		ApexPages.StandardSetController setController2 = new ApexPages.StandardSetController(oRSO);
		setController2.setselected(oRSO);
		SVMX_VF_Parts_Order_Int controller2 = new SVMX_VF_Parts_Order_Int(setController2);
		
		ApexPages.StandardSetController setController3 = new ApexPages.StandardSetController(oRSO);
		SVMX_VF_Parts_Order_Int controller3 = new SVMX_VF_Parts_Order_Int(setController3);
		controller3.insertRec();
		
		 }catch(exception ex){
        	
        }
	}
}