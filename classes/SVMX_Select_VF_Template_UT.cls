public class SVMX_Select_VF_Template_UT 
{ 
    public static testmethod void test()
    {
		try{
			list<SVMXC__Service_Order__c> WorkOrder= new list<SVMXC__Service_Order__c>();        
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
	        SVMXC__Service_Order__c o2 = new SVMXC__Service_Order__c();
	        o2.SVMXC__Company__c = a.Id;
			o2.SVMXC__Zip__c = '11111';
			o2.SVMXC__Company__c=a.Id;              
	        o2.SVMXC__Order_Status__c='Open';
	        o2.SVMXC__Priority__c='Low';
	        o2.SVMXC__Order_Type__c='Field Service';
	        o2.SVMXC__Purpose_of_Visit__c='Repair';
	        SVMXC__Service_Order__c o3 = new SVMXC__Service_Order__c();
	        o3.SVMXC__Company__c = a.Id;
			o3.SVMXC__Zip__c = '11111';
			o3.SVMXC__Company__c=a.Id;              
	        o3.SVMXC__Order_Status__c='Open';
	        o3.SVMXC__Priority__c='Low';
	        o3.SVMXC__Order_Type__c='Field Service';
	        o3.SVMXC__Purpose_of_Visit__c='Repair';
	        
	        Product2 pr = new Product2 (Name ='Prod',ProductCode='Prod',SVMXC__Inherit_Parent_Warranty__c =True); 
        	insert pr; 
	        string d = string.valueOf(math.random());
	        RecordType rtSvoLine = [SELECT Id FROM RecordType WHERE SobjectType = 'SVMXC__Service_Order_Line__c' AND Name = 'Estimate' Limit 1];
        	
        	
        	
	        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
	        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d,SVMXC__Object_Id__c =o1.Id );
	        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d,SVMXC__Object_Id__c =o1.Id );
	        lstSL.add(oSL1);
	        lstSL.add(oSL2);
	        insert lstSL;
	        
	        WorkOrder.add(o1);
	        WorkOrder.add(o2);
	        WorkOrder.add(o3);
	        upsert WorkOrder;
	        
	        SVMXC__Service_Order_Line__c oSOL = new SVMXC__Service_Order_Line__c(SVMXC__Service_Order__c = o1.Id,SVMXC__Product__c = pr.id,SVMXC__Line_Type__c = 'Parts',SVMXC__Estimated_Quantity2__c = 2,SVMXC__Estimated_Price2__c =2,SVMXC__Actual_Quantity2__c  =2,RecordTypeId = rtSvoLine.id);
	        insert oSOL;
	        
	        PageReference pageRef1 = new PageReference('Page.SVMXC.SVMX_Select_VF_Template?id='+o1.Id+'&DispTYP=pdf');
	        Test.setCurrentPage(pageRef1);
	        SVMX_Select_VF_Template controller2 = new SVMX_Select_VF_Template();
	        
	        controller2.getd();
	        controller2.getisInsert();
	        controller2.setstrDispTyp(null);
	        controller2.getstrDispTyp();
	        controller2.setstrDispTyp('pdf');
	        controller2.getstrDispTyp();
	        controller2.getstrReportType();
	        controller2.getAttachFile();
	        controller2.setAttachFile(true);
	        controller2.getSId();
	        controller2.getList();
	        controller2.getMMDetail();
	        controller2.getPageName();
	        controller2.setPageName('SVMX_Select_VF_Template');
	     //   controller2.getallowAttachment();
	        controller2.AttachFile = true;
	        controller2.strReportType = 'SingleRecord';
	        controller2.Generate();
	        controller2.Cancel();
	        controller2.getREPTAG001();
	        controller2.getREPTAG002();
	        controller2.getREPTAG003();
	        controller2.getREPTAG004();
	        controller2.getREPTAG005();
	        controller2.getREPTAG006();
	        controller2.getREPTAG007();
	        controller2.getREPTAG008();
	        
	        
	        
	        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();
	        SVMX_Select_VF_Template.getFieldList(fieldMap, false);
	        controller2.tlst = lstSL;
	        controller2.strReportType = 'MultipalRecord';
	        controller2.ObjName = '';
	        controller2.getItems();
	        controller2.ObjName = 'asdf\'asdf';
	        controller2.getItems();
	
	        controller2.ObjName = 'SVMXC.Service_Order';
	        controller2.getItems();
	        
	        PageReference pageRef3 = new PageReference('Page.SVMXC.SVMX_Select_VF_Template?d='+d+'&DispTYP=doc');
	        Test.setCurrentPage(pageRef3);
	        SVMX_Select_VF_Template controller8 = new SVMX_Select_VF_Template();
	        controller8.setPageName('SVMX_VF_ServiceReport');
	        controller8.AttachFile = true;
	        controller8.strReportType = 'MultipalRecord';
	        controller8.Generate();
	        controller8.Cancel();
		}
		catch(exception ex){Apexpages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,ex.getmessage()));}
        
    }

}