/**
 *   Taken from http://www.jitendrazaa.com/blog/salesforce/apex/send-email-with-generated-pdf-as-attachment-from-trigger/ 
 *   Forms part of the process to send PDF on Closed Opportuntiies (reused by Joey Ho)
 *   Created By  :   Jitendra Zaa
 *   Description :   Apex based REST API which exposes POST method to send Email
*/
@RestResource(urlMapping='/sendPDFEmail/*')
Global class GETPDFContent{
     @HttpPost
    global static void sendEmail(String EmailIdCSV, String Subject, String body,string OppId) {

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
        email.setToAddresses( EmailIds  );
        email.setPlainTextBody(Body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

    }
}