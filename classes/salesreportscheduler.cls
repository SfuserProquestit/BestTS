/*
* Written by Joey Ho 5/5/16
* salesreportscheduler sends salesreport.vfp via pdf every Sunday using Apex Scheduled jobs
*/
global class salesreportscheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        //Set page and parameter to PDF
        PageReference pdf = Page.salesreport;
        pdf.getParameters().put('renderas','PDF');			//The parameter sets the render as pdf
        pdf.setRedirect(true);
        
        //Take PDF content
        Blob b = (system.Test.isRunningTest()) ? Blob.valueOf('UNIT.TEST') : pdf.getContent();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('WeeklySalesReport.pdf');
        efa.setBody(b);
        
        //Get the email receipient based on Sales Report Group
        Id groupId = [SELECT Id FROM Group WHERE Name = 'Sales Report Group' LIMIT 1].Id;
        set<Id> userIdSet = publicGroupFunctions.GetUserIdsFromGroup(groupId);
        list<string> toAddress = new list<string>();
        for(User u:[SELECT Email, Email_Weekly_Sales_Report__c FROM User WHERE Id IN:userIdSet OR Email_Weekly_Sales_Report__c = true]){
            toAddress.add(u.Email);
        }
        
        //Define email
        string dateStr = system.today().format();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Weekly Sales Report '+ dateStr);
        
        email.setToAddresses(toAddress);
        email.setPlainTextBody('Please see attached the latest weekly sales report.');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        email.setReplyTo('no-replay@best-ite.com');
        email.setSenderDisplayName('Best-ITE Sales');
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 

   }
}