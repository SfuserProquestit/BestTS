public class SVMX_VF_ServiceQuote_UT 
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
			Contact  contact = new Contact(          
	                                        LastName='Last',
	                                        AccountId = account.Id,
	                                        Email='svmxmailfortest@gmail.com'
	                                        );
	        insert contact;
	        Case case1 = new Case(Status ='New', Priority = 'Medium', 
	                                        Origin = 'Email',                                        
	                                        //CurrencyIsoCode = 'USD',                                        
	                                        ContactId =contact.Id,
	                                        AccountId=account.Id
	                                        ); 
	        insert case1;
	        SVMXC__Service_Order__c workorder = new SVMXC__Service_Order__c(
	                                        SVMXC__Company__c = account.Id,
	                                        SVMXC__Contact__c = contact.Id,
	                                        SVMXC__Case__c = case1.Id,
	                                        SVMXC__Order_Status__c = 'Open',
	                                        SVMXC__Priority__c = 'Medium',
	                                        SVMXC__Order_Type__c = 'Field Service'
	                                        //CurrencyIsoCode = 'USD'
	                                        
	                                        );
	        insert workorder;
	        
	        
	        
	        list<SVMXC__Quote__c> oRSO= new list<SVMXC__Quote__c>();
	        SVMXC__Quote__c o1 = new SVMXC__Quote__c();
	        o1.SVMXC__Company__c = account.id;
	        o1.SVMXC__Contact__c = contact.id;
	        o1.SVMXC__Service_Order__c = workorder.id;
	        o1.SVMXC__Status__c = 'New';
	        o1.SVMXC__Quote_Amount2__c =123;
	        o1.SVMXC__Valid_Until__c = system.today() + 30;
	        o1.SVMXC__Discount_Type__c = 'Amount';
	        insert o1;
	        PageReference pageRef4 = new PageReference('Page.SVMX_VF_ServiceQuote?RecordId='+o1.Id+'&DispTYP=xls');
	        Test.setCurrentPage(pageRef4);
	        ApexPages.StandardController controller1 = new ApexPages.StandardController(o1);
	        SVMX_VF_ServiceQuote controller2 = new SVMX_VF_ServiceQuote(controller1);
	        controller2.getstrDispTyp();
	        controller2.strDispTyp = 'pdf';
	        controller2.getstrDispTyp();
	        controller2.getcontype();
	        
	        controller2.getREPTAG001();
	        controller2.getREPTAG002();
	        controller2.getREPTAG003();
	        controller2.getREPTAG004();
	        controller2.getREPTAG005();       
			Date d;
	        DateTime dt;
	        controller2.getFormattedDate(System.today());
	        controller2.getFormattedDate(System.now());
	        controller2.getFormattedDate(d);
	        controller2.getFormattedDate(dt);
	        
	        SVMX_VF_ServiceQuote.getFieldList(Schema.SObjectType.SVMXC__Quote_Line__c.fields.getMap(), true);
	        SVMX_VF_ServiceQuote.getFieldList(Schema.SObjectType.SVMXC__Quote_Line__c.fields.getMap(), false);
	        SVMX_VF_ServiceQuote.Wraper w = new SVMX_VF_ServiceQuote.Wraper( new SVMXC__Quote__c(), new list<SVMXC__Quote_Line__c>()); 
	        w.getSVQDate();
	        w.getValUnll();
	        w.getsObj();
	        w.getlstsObj();
       	} 
       	catch(Exception e){ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,e.getmessage()));}  
	
	 }
	 public static testmethod void test2()
	 {
	 	try
	 	{
	        string d = string.valueOf(math.random());
	        
	        list<SVMXC__Quote__c> lstRMASO= new list<SVMXC__Quote__c>();
	        SVMXC__Quote__c o1 = new SVMXC__Quote__c();
	        SVMXC__Quote__c o2 = new SVMXC__Quote__c();
	        lstRMASO.add(o1);
	        lstRMASO.add(o2);
	        insert lstRMASO;
	        SVMXC__Quote_Line__c oL1 = new SVMXC__Quote_Line__c( SVMXC__Quote__c = o1.Id);
	        insert oL1;
	        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
	        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
	        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
	        
	        lstSL.add(oSL1);
	        lstSL.add(oSL2);
	        insert lstSL;
	        
	        PageReference pageRef = new PageReference('Page.SVMX_VF_ServiceQuote?d='+d+'&DispTYP=doc');
	        Test.setCurrentPage(pageRef);
	        SVMX_VF_ServiceQuote controller2 = new SVMX_VF_ServiceQuote(null);
	        controller2.SVQuote.clear();
	        controller2.SVQuote.addAll(lstRMASO);
	        controller2.getSVQuote();
	    }
	    catch(Exception e){ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,e.getmessage()));}
    }
      
}