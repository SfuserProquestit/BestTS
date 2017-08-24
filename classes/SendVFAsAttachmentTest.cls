@isTest  
public class SendVFAsAttachmentTest{	

    /* The following oppUpdateTrigger test sendPDfForClosedWondTrigger.apxt on update. 
	*  This also test @futures method by invoking SendVFAsAttachment.sendVF method however ignoring the http web service call
	*/
    public static testMethod void oppUpdateTrigger(){ 
        list<Opportunity> oppList = new List<Opportunity>();    
    	Account a = new Account(Name='Test Account');
        insert a;
        Contact c = new Contact(FirstName='Jake',LastName='Spears',AccountId=a.id);
        insert c;
        
        for(integer i=0;i<10;i++){
            Opportunity o = new Opportunity();
            o.Name = 'Opp Name ' + i;
            o.AccountId = a.Id;
            o.Amount = 10000;
            o.StageName = 'Proposal';
            o.CloseDate = System.today() + 5;
            oppList.add(o);
        }
        
        Opportunity newOp = new Opportunity(
            Name = 'Opp Name Additional',
            AccountId = a.Id,
            Amount = 10000,
            StageName = 'Proposal',
            CloseDate = System.today() + 5
            );
        
        insert newOp;
        insert oppList;        
              
        
        test.startTest();
		
        for(Opportunity o:oppList){
        	o.StageName = 'Closed Won';
            o.Reason__c = 'Value';
            o.Engagement_Type__c = 'Projects';
            o.Strategic_Or_Tactical__c = 'Tactical';
            o.Start_Date__c = System.today() + 10;
            o.End_Date__c = System.today() + 15;
            o.New_Business_or_Renewal__c = 'New Business';
            o.LeadSource = 'Call in';
            o.Engineering_Revenue__c = 200;
            o.Engineering_Margin__c = 50;
            o.Total_Revenue__c = 500;
            o.Project_Lead__c = c.Id;
            o.VF_Closed_Won__c = true;
            o.VF_Closed_Won_Notification_Sent__c = false;
        }
                                            
        update oppList;
        
        newOp.StageName = 'Closed Won';
        newOp.Reason__c = 'Value';
        newOp.Engagement_Type__c = 'Projects';
        newOp.Strategic_Or_Tactical__c = 'Tactical';
        newOp.Start_Date__c = System.today() + 10;
        newOp.End_Date__c = System.today() + 15;
        newOp.New_Business_or_Renewal__c = 'New Business';
        newOp.LeadSource = 'Call in';
        newOp.Engineering_Revenue__c = 200;
        newOp.Engineering_Margin__c = 50;
        newOp.Total_Revenue__c = 500;
        newOp.Project_Lead__c = c.Id;
        newOp.VF_Closed_Won__c = true;
        newOp.VF_Closed_Won_Notification_Sent__c = false;
        
        oppList.add(newOp);
        update oppList;
        
        SendVFAsAttachment.sendVF('joey_hoey19@hotmail.com','Sample Test from Trigger','Sample Email Body',oppList[0].id,UserInfo.getSessionId());          		
        
    }
	
 	/*  Rest API Test executed in this manner as follows
	*/     
    public static testMethod void testCallout() {
        // Set mock callout class 
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
             
        /*
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
		*/
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        
        request.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/sendPDFEmail';  
        request.httpMethod = 'POST';
        
        RestContext.request = request;
        RestContext.response = response;
		GETPDFContent.sendEmail('joey@cloudycode.com.au', 'Subject', 'body', '');
    }
    
}