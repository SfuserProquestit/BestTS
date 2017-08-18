public class SVMX_VF_Work_Order_Int_UT 
{
	public static testmethod void test()
	{
		try{
			PageReference pageRef = new PageReference('Page.SVMX_VF_Work_Order_Int');
			Test.setCurrentPage(pageRef);
			list<SVMXC__Service_Order__c> lstSC= new list<SVMXC__Service_Order__c>();
			list<BusinessHours> lBH = [ select WednesdayStartTime, WednesdayEndTime, TuesdayStartTime, TuesdayEndTime, ThursdayStartTime, ThursdayEndTime, SundayStartTime, SundayEndTime, SaturdayStartTime, SaturdayEndTime, MondayStartTime, MondayEndTime, IsDefault, IsActive, Id, FridayStartTime, FridayEndTime from BusinessHours where isDefault = true limit 1];
			list<Account> AccList = new list<Account>();
	        
	        Account a = new Account(Name = 'test');        
	        a.SVMXC__Access_Hours__c = lBH[0].Id;
	        insert a;
	        AccList.add(a);
	        
			SVMXC__Service_Order__c o1 = new SVMXC__Service_Order__c();
			o1.SVMXC__Company__c = a.Id;
			o1.SVMXC__Zip__c = '11111';
			o1.SVMXC__Company__c=a.Id;              
		    o1.SVMXC__Order_Status__c='Open';
		    o1.SVMXC__Priority__c='Low';
		    o1.SVMXC__Order_Type__c='Field Service';
		    o1.SVMXC__Purpose_of_Visit__c='Repair';
			
			lstSC.add(o1);
			insert lstSC;
			
			ApexPages.StandardSetController setController = new ApexPages.StandardSetController(lstSC);
			setController.setselected(lstSC);
			SVMX_VF_Work_Order_Int controller = new SVMX_VF_Work_Order_Int(setController);
			
			controller.insertRec();
			controller.getisInsert(); 
			
			SVMXC__Service_Order__c o2 = new SVMXC__Service_Order__c();
			o2.SVMXC__Company__c = a.Id;
			o2.SVMXC__Zip__c = '11111';
			o2.SVMXC__Company__c=a.Id;              
		    o2.SVMXC__Order_Status__c='Open';
		    o2.SVMXC__Priority__c='Low';
		    o2.SVMXC__Order_Type__c='Field Service';
		    o2.SVMXC__Purpose_of_Visit__c='Repair';
			insert o2;
			lstSC.add(o2);
			
			PageReference pageRef2 = new PageReference('Page.SVMX_VF_Work_Order_Int');
	        Test.setCurrentPage(pageRef2);
			
			ApexPages.StandardSetController setController2 = new ApexPages.StandardSetController(lstSC);
			setController2.setselected(lstSC);
			SVMX_VF_Work_Order_Int controller2 = new SVMX_VF_Work_Order_Int(setController2);
			
			ApexPages.StandardSetController setController3 = new ApexPages.StandardSetController(lstSC);
			SVMX_VF_Work_Order_Int controller3 = new SVMX_VF_Work_Order_Int(setController3);
			controller3.insertRec();
		}
		catch(exception ex){Apexpages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,ex.getmessage()));}
	}
}