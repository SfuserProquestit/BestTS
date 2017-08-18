public class COMM_Utils_Reports_UT {
	
	public static testmethod void test(){
		try{
			test.startTest();
			RecordType rtRMA;
			string strUserID = UserInfo.getUserId();
			string strSessionID = UserInfo.getSessionId();
			list<SVMXC__RMA_Shipment_Order__c> lstRMA = new list<SVMXC__RMA_Shipment_Order__c>();
			
			list<RecordType> AllRecordTypes =[SELECT Id , Name,SobjectType  FROM RecordType];
			for ( RecordType rectype:AllRecordTypes){
				if ((rectype.Name =='RMA')&&(rectype.SobjectType =='SVMXC__RMA_Shipment_Order__c'))                
	                rtRMA = rectype;                
			}
			
			Account account = new Account(Name ='Account',ShippingStreet='ABC',ShippingCity='PQR ',ShippingState = 'XYZ',ShippingPostalCode='111',ShippingCountry='XYZ',BillingStreet='ABC',BillingCity='PQR ',BillingState = 'XYZ',BillingPostalCode='111',BillingCountry='XYZ'); 
			insert account;
			        
			Contact contact = new Contact(LastName='Last',AccountId =account.Id,Email='svmxmailfortest@gmail.com');
			insert contact;
			
			Case case1 = new Case(Status ='New', Priority = 'Medium',Origin = 'Email',ContactId =contact.Id,AccountId=account.Id); 
			insert case1;
			
			SVMXC__Site__c sourceLocation = new SVMXC__Site__c(SVMXC__Zip__c ='90909090',SVMXC__Street__c ='ABC',SVMXC__State__c ='ABC',SVMXC__Country__c ='ABC',SVMXC__City__c ='ABC',SVMXC__Account__c=account.Id);
			insert sourceLocation;    
			
			SVMXC__Site__c destLocation = new SVMXC__Site__c(SVMXC__Zip__c ='90909090',SVMXC__Street__c ='ABC',SVMXC__State__c ='ABC',SVMXC__Country__c ='ABC',SVMXC__City__c ='ABC',SVMXC__Account__c=account.Id);
			insert destLocation;
			
			SVMXC__RMA_Shipment_Order__c o1 = new SVMXC__RMA_Shipment_Order__c(SVMXC__Source_Location__c =sourceLocation.Id,SVMXC__Expected_Delivery_Date__c =System.today(),SVMXC__Destination_Location__c=destLocation.Id,SVMXC__Contact__c =contact.Id,SVMXC__Company__c=account.Id,SVMXC__Case__c =case1.Id,RecordTypeId = rtRMA.Id,SVMXC__Order_Status__c='Open');                  
			lstRMA.add(o1);
			insert lstRMA;
	        
	        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>();
	        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c ( SVMXC__Object_Id__c =o1.Id, SVMXC__Salesforce_Session_ID__c ='ServiceMax', SVMXC__User__c = strUserID);
	        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c ( SVMXC__Object_Id__c =o1.Id, SVMXC__Salesforce_Session_ID__c = strSessionID, SVMXC__User__c = strUserID);
	        lstSL.add(oSL1);
	        lstSL.add(oSL2);
	        insert lstSL;
	                
	        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(lstRMA);
	        setController.setselected(lstRMA);
	        
	        COMM_Utils_Reports controller = new COMM_Utils_Reports();
	        controller.getServiceMaxList(setController, 'SVMXC.RMA_Shipment_Order.Shipment', strUserID, strSessionID);
	
			//controller.getSelectTempPage(lstSL, 'SVMXC.RMA_Shipment_Order.Shipment',true, '' );
			//controller.getSelectTempPage(lstSL, 'SVMXC.RMA_Shipment_Order.Shipment',false, oSL1.Id );
	     
	        COMM_Utils_Reports.SVMX_ListCleanUp(strUserID, strSessionID);
	        COMM_Utils_Reports.getcontype('pdf');
	        COMM_Utils_Reports.getcontype('xls');
	        COMM_Utils_Reports.getcontype('doc');
	        
	        Date d;
	        DateTime dt;
	        COMM_Utils_Reports.getFormattedDate(System.today());
	        COMM_Utils_Reports.getFormattedDate(System.now());
	        COMM_Utils_Reports.getFormattedDate(d);
	        COMM_Utils_Reports.getFormattedDate(dt);
	    	test.stopTest();
    	}
		catch(exception ex){Apexpages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,ex.getmessage()));}
        
    }
}