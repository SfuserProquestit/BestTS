public class SVMX_VF_Service_Contract_Int_UT
{

	public static testmethod void test()
	{
		try
		{
			Account account = new Account(
		                                        Name ='Account',
		                                        ShippingStreet='ABC',
		                                        ShippingCity='PQR ',
		                                        ShippingState = 'XYZ',
		                                        ShippingPostalCode='111',
		                                        ShippingCountry='XYZ',
		                                        BillingStreet='ABC',
		                                        BillingCity='PQR ',
		                                        BillingState = 'XYZ',
		                                        BillingPostalCode='111',
		                                        BillingCountry='XYZ'
		                                        ); 
		    insert account;
		    Account account1 = new Account(
		                                        Name ='Account1',
		                                        ShippingStreet='ABC',
		                                        ShippingCity='PQR ',
		                                        ShippingState = 'XYZ',
		                                        ShippingPostalCode='111',
		                                        ShippingCountry='XYZ',
		                                        BillingStreet='ABC',
		                                        BillingCity='PQR ',
		                                        BillingState = 'XYZ',
		                                        BillingPostalCode='111',
		                                        BillingCountry='XYZ'
		                                        ); 
		    insert account1;
			SVMXC__Service_Level__c SLA = new SVMXC__Service_Level__c();
			SLA.Name = 'SLA';
			insert SLA;
			SVMXC__Service_Level__c SLA1 = new SVMXC__Service_Level__c();
			SLA.Name = 'SLA1';
			insert SLA1;
					
			
			PageReference pageRef = new PageReference('Page.SVMX_VF_Service_Contract_Int');
	        Test.setCurrentPage(pageRef);
			
			list<SVMXC__Service_Contract__c> oSC= new list<SVMXC__Service_Contract__c>();
			SVMXC__Service_Contract__c o1 = new SVMXC__Service_Contract__c();
			o1.SVMXC__Company__c = account.id;
			o1.Name = 'contract1';
			o1.SVMXC__Start_Date__c = system.today();
			o1.SVMXC__End_Date__c = system.today() + 300;
			o1.SVMXC__Active__c = true;
			o1.SVMXC__Service_Level__c = SLA.id;
			oSC.add(o1);
			
			insert oSC;
			ApexPages.StandardSetController setController = new ApexPages.StandardSetController(oSC);
			setController.setselected(oSC);
			SVMX_VF_Service_Contract_Int controller = new SVMX_VF_Service_Contract_Int(setController);
			
			controller.insertRec();
			controller.getisInsert(); 
			controller.getREPTAG009();
			controller.getREPTAG010();
			SVMXC__Service_Contract__c o2 = new SVMXC__Service_Contract__c();
			o2.SVMXC__Company__c = account1.id;
			o2.Name = 'contract2';
			o2.SVMXC__Start_Date__c = system.today();
			o2.SVMXC__End_Date__c = system.today() + 300;
			o2.SVMXC__Active__c = true;
			o2.SVMXC__Service_Level__c = SLA1.id;
			insert o2;
			oSC.add(o2);
			PageReference pageRef2 = new PageReference('Page.SVMX_VF_Service_Contract_Int');
	        Test.setCurrentPage(pageRef2);
			ApexPages.StandardSetController setController2 = new ApexPages.StandardSetController(oSC);
			setController2.setselected(oSC);
			SVMX_VF_Service_Contract_Int controller2 = new SVMX_VF_Service_Contract_Int(setController2);
			
			ApexPages.StandardSetController setController3 = new ApexPages.StandardSetController(oSC);
			SVMX_VF_Service_Contract_Int controller3 = new SVMX_VF_Service_Contract_Int(setController3);
			controller3.insertRec();
			controller3.SVMX_Back();
			
		}
		catch(Exception e){ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,e.getmessage()));}	
		
		
	}
}