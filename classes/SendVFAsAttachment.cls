/**  
*   Taken from http://www.jitendrazaa.com/blog/salesforce/apex/send-email-with-generated-pdf-as-attachment-from-trigger/ 
*   Forms part of the process to send PDF on Closed Opportuntiies (reused by Joey Ho)
*   Created By  :   Jitendra Zaa
*   Description :   This class exposes @future method to send VF page rendered as PDF as attachment in Email
*
*	As of 02/11/2016, changes to this Rest call from GetPDFContent.apxc (unsused) is incorporate directly into the below futures call
*	based on Winter 16' release that allows this change to https://developer.salesforce.com/forums/?id=906F0000000BP6DIAW
*	http://releasenotes.docs.salesforce.com/en-us/winter16/release-notes/rn_apex_pagereference_getcontent.htm#rn_apex_pagereference_getcontent
*	addtion of Static inSendVF and adding userID arguement to sendVF
*/
public without sharing class SendVFAsAttachment{
	Public static boolean inSendVF = false;
    
    @future(callout=true)
    public static void sendVF(String EmailIdCSV, String Subject,String body,String OppId, String userSessionId)
    {        
        inSendVF = true;
        List<string> EmailIds = EmailIdCSV.split(',');
            
        //PageReference ref = Page.PDF_DEMO;  
        PageReference ref =  new PageReference('/apex/PDF_DEMO?id='+OppId);             
        Blob b = (!Test.isRunningTest()) ? ref.getContentAsPDF():Blob.valueOf('UNIT.TEST');

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setFileName('attachment_WORK.pdf');
        efa1.setBody(b);

        String addresses;
        //email.setSubject('Closed Deal Alert');      
        email.setSubject(Subject);
        email.setToAddresses( EmailIds);
        email.setPlainTextBody(body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
    }
    
    /*
    @future(callout=true)
    public static void sendVF(String EmailIdCSV, String Subject,String body,String OppId, String userSessionId)
    {        
        //Replace below URL with your Salesforce instance host
        //String addr = 'https://cs6.salesforce.com/services/apexrest/sendPDFEmail';
        String addr = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/sendPDFEmail';	//Note sendPDFEmail is the RestAPI call
        HttpRequest req = new HttpRequest();
        req.setEndpoint( addr );
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + userSessionId);        
        req.setHeader('Content-Type','application/json');
        Map<string,string> postBody = new Map<string,string>();
        postBody.put('EmailIdCSV',EmailIdCSV);
        postBody.put('Subject',Subject);
        postBody.put('body',body);
        postBody.put('OppId',OppId);
        String reqBody = JSON.serialize(postBody);
        
        req.setBody(reqBody);
        Http http = new Http();
        if(!Test.isRunningTest()){
            HttpResponse response = http.send(req);
        }    
    }
	*/
    
    
}