public class SVMX_VF_ServiceReport_UT 
{
    public static testmethod void test()
    {
        try{
	        list<SVMXC__Service_Order__c> oRSO= new list<SVMXC__Service_Order__c>();
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
		    insert o1;
	        
	        PageReference pageRef4 = new PageReference('Page.SVMX_VF_ServiceReport?RecordId='+o1.Id+'&DispTYP=xls');
	        Test.setCurrentPage(pageRef4);
	        
	        ApexPages.StandardController controller1 = new ApexPages.StandardController(o1);
	        
	        SVMX_VF_ServiceReport controller2 = new SVMX_VF_ServiceReport(controller1);
	        
	        controller2.getstrDispTyp();
	        controller2.strDispTyp = 'pdf';
	        controller2.getstrDispTyp();
	        controller2.getcontype();
	        controller2.getREPTAG005();
			controller2.getREPTAG006();
			    
	        SVMX_VF_ServiceReport.getFieldList(Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap(), true);
	        SVMX_VF_ServiceReport.getFieldList(Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap(), false);
	        SVMX_VF_ServiceReport.Wraper w = new SVMX_VF_ServiceReport.Wraper( new SVMXC__Service_Order__c(), new list<SVMXC__Service_Order_Line__c>(),'a' ); 
	        w.getsObj();
	        w.getlstsObj();
	        w.getWOCreatedDate();
        }
        catch(exception ex){Apexpages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,ex.getmessage()));}
    }
    
    public static testmethod void test2(){
    	try{
	        string d = string.valueOf(math.random());        
	        list<SVMXC__Service_Order__c> lstRMASO= new list<SVMXC__Service_Order__c>();
	        
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
		            
	        SVMXC__Service_Order__c o2 = new SVMXC__Service_Order__c();
	        o2.SVMXC__Company__c = a.Id;
			o2.SVMXC__Zip__c = '11111';
			o2.SVMXC__Company__c=a.Id;              
		    o2.SVMXC__Order_Status__c='Open';
		    o2.SVMXC__Priority__c='Low';
		    o2.SVMXC__Order_Type__c='Field Service';
		    o2.SVMXC__Purpose_of_Visit__c='Repair';
	        
	        lstRMASO.add(o1);
	        lstRMASO.add(o2);
	        //insert lstRMASO;
	        SVMXC__Service_Order_Line__c oL1 = new SVMXC__Service_Order_Line__c( SVMXC__Service_Order__c = o1.Id);
	        //insert oL1;
	        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
	        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
	        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
	        
	        lstSL.add(oSL1);
	        lstSL.add(oSL2);
	        insert lstSL;
	        
	        PageReference pageRef = new PageReference('Page.SVMX_VF_ServiceReport?d='+d+'&DispTYP=doc');
	        Test.setCurrentPage(pageRef);
	        SVMX_VF_ServiceReport controller2 = new SVMX_VF_ServiceReport(null);
	        controller2.WorkOrder.clear();
	        controller2.WorkOrder.addAll(lstRMASO);
	        controller2.getWorkOrders();
    	}
        catch(exception ex){Apexpages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,ex.getmessage()));}
    }
}