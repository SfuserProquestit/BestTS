public with sharing class CreateWOTests_UT {
	
 	static testmethod void testCreateWOfromLocation(){
		//Create Location
		SVMXC__Site__c loc = new SVMXC__Site__c(Name ='Location1'); 
        insert loc; 	
        							
        //Test coverage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.CreateWOfromLocation;
        pageRef.getParameters().put('lid',loc.Id);
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        ApexPages.StandardController mc = new Apexpages.Standardcontroller(loc);
        CreateWOfromLocation myPageCon1 = new CreateWOfromLocation();
		myPageCon1.getLocationHeader();
		myPageCon1.getObjectRecordTypes();
		myPageCon1.AddToErrorsList('String msg');  myPageCon1.getSelectedRecordType();
		myPageCon1.Cancel(); myPageCon1.getErrorsList(); myPageCon1.getDisplayBlockLevelMessage(); myPageCon1.setSelectedRecordType('Service Order'); 
		myPageCon1.getShowValidData(); myPageCon1.setShowValidData(True);
		myPageCon1.getTAG001();myPageCon1.getTAG002(); myPageCon1.getTAG007();
		myPageCon1.getTAG003();myPageCon1.getTAG004();myPageCon1.getTAG005();
		myPageCon1.getTAG006();myPageCon1.getTAG008();myPageCon1.getTAG009();myPageCon1.getTAG010();myPageCon1.getHLPURL();
		myPageCon1.getRecTypSize(); myPageCon1.getWOHeader(); myPageCon1.newTargetObj(); myPageCon1.DisplayErrorsNWarnings();
		Test.stopTest();
 	}
 	
 	static testmethod void testCreateWOfromInstalledProduct(){
		//Create Location
		SVMXC__Installed_Product__c ip = new SVMXC__Installed_Product__c(Name ='Ip1'); 
        insert ip; 	
        							
        //Test coverage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.CreateWOfromInstalledProduct;
        pageRef.getParameters().put('ipid',ip.Id);
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        ApexPages.StandardController mc = new Apexpages.Standardcontroller(ip);
        CreateWOfromInstalledProduct myPageCon1 = new CreateWOfromInstalledProduct();
		myPageCon1.getInstalledProductHeader();
		myPageCon1.getObjectRecordTypes();
		myPageCon1.AddToErrorsList('String msg');  myPageCon1.getSelectedRecordType();
		myPageCon1.Cancel(); myPageCon1.getErrorsList(); myPageCon1.getDisplayBlockLevelMessage(); myPageCon1.setSelectedRecordType('Service Order'); 
		myPageCon1.getShowValidData(); myPageCon1.setShowValidData(True);
		myPageCon1.getTAG001();myPageCon1.getTAG002(); myPageCon1.getTAG007();
		myPageCon1.getTAG003();myPageCon1.getTAG004();myPageCon1.getTAG005();
		myPageCon1.getTAG006();myPageCon1.getTAG008();myPageCon1.getTAG009();myPageCon1.getTAG010();myPageCon1.getHLPURL();
		myPageCon1.getRecTypSize(); myPageCon1.getWOHeader(); myPageCon1.newTargetObj(); myPageCon1.DisplayErrorsNWarnings();
		Test.stopTest();
 	} 	
}