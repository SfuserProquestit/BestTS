public with sharing class PS_ServiceReport_UT {
	static Account ac; static Contact ct; static Case cs; static SVMXC__Service_Order__c svo;
	public static void setupTest(){
		//Create Account
        ac = new Account(
                                        Name ='Account',
                                        ShippingStreet='ABC',
                                        ShippingCity='PQR ',
                                        ShippingState = 'XYZ',
                                        ShippingPostalCode='111',
                                        ShippingCountry='XYZ'
                                        ); 
        insert ac;    
        //Create Contact
        ct = new Contact(LastName='Last',AccountId =ac.Id); 
        insert ct;      
        //Create Case    
        cs = new Case(Status ='New', Priority = 'Medium', 
                                            Origin = 'Email', 
                                            //SVMX_Serial_Number__c ='123',
                                            //CurrencyIsoCode = 'USD',                                          
                                            ContactId =ct.Id,
                                            AccountId=ac.Id
                                            ); 
        insert cs;     
        
        //Create Work Order
        svo = new SVMXC__Service_Order__c (
                                        SVMXC__Case__c = cs.Id ,
                                        SVMXC__Company__c = ac.Id , 
                                        SVMXC__Order_Status__c = 'Open',
                                        SVMXC__Priority__c ='Medium',
                                        SVMXC__Order_Type__c='Field Service'
                                        );
         insert svo;		
	}
	
	static testMethod void SVMX_PS_ServiceReport_Test()
    {        
    	ac=null; ct=null; cs=null; svo=null;
        setupTest();
        
        //Test converage for the PS_ServiceReport visualforce page
        PageReference pageRef = Page.PS_ServiceReport;
        pageRef.getParameters().put('RecordId',svo.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        PS_ServiceReport myPageCon = new PS_ServiceReport();
        
        //try calling methods/properties of the controller in all possible scenarios
        // to get the best coverage.
        SVMXC__Service_Order__c pWO = myPageCon.getWorkOrder();
    
        List<SVMXC__Service_Order_Line__c> pWOLines =  myPageCon.getWorkOrderDetail();
     
        String strWOdt =  myPageCon.getWODate();
        String strCurrDt =  myPageCon.getCurrentDate();
        
        Date dat = System.today();
        String strDt =  myPageCon.getFormattedDate(dat);
        String str1 =  myPageCon.getcontype();
        String str2 =  myPageCon.getrender();  
            
    } 
    static testMethod void SVMX_PS_ServiceReportEST_Test()
    { 
        ac=null; ct=null; cs=null; svo=null;
        setupTest();
        
        //Test converage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.SVMX_PS_ServiceReportEST;
        pageRef.getParameters().put('RecordId',svo.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_PS_ServiceReportEST myPageCon = new SVMX_PS_ServiceReportEST();
        
        //try calling methods/properties of the controller in all possible scenarios
        // to get the best coverage.
        SVMXC__Service_Order__c pWO = myPageCon.getWorkOrder();
    
        List<SVMXC__Service_Order_Line__c> pWOLines =  myPageCon.getWorkOrderDetail();
     
        String strWOdt =  myPageCon.getWODate();
        String strCurrDt =  myPageCon.getCurrentDate();
        
        Date dat = System.today();
        String strDt =  myPageCon.getFormattedDate(dat);
        String str1 =  myPageCon.getcontype();
        String str2 =  myPageCon.getrender();  
            
    } 
}