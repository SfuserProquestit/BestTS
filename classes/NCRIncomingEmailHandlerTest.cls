@isTest
public class NCRIncomingEmailHandlerTest {

    @testSetup static void testDataSetup(){
        Account account = TestUtility.createAccounts(1)[0];
        insert account;
        TestUtility.createEmailServiceSettingsCS(account.Id);

        List<ServiceContract> serviceContracts = TestUtility.createServiceContracts(account,2);
        insert serviceContracts;

        ServiceContract serviceContract = [SELECT ContractNumber FROM ServiceContract WHERE Id = :serviceContracts[0].Id];

        Territory_Contract_Mapping__c territoryMapping = new Territory_Contract_Mapping__c();
        territoryMapping.Name = 'TerritoryName';
        territoryMapping.Contract_Number__c = String.valueOf(serviceContract.ContractNumber);
        insert territoryMapping;

        TestUtility.createLocationSettingsCS();
    }
    
    @isTest
	static void testHandleInboundEmailSuccess() {

        // Create a new email and envelope object
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        // Create the email body
        Integer i = 0;
        List<Email_Parsing_Field_Mapping__mdt> fieldMapping = [SELECT Email_Field__c, SF_Field__c, SF_Field_Type__c, SF_Object_Type__c
                                                                        FROM Email_Parsing_Field_Mapping__mdt WHERE SF_Object_Type__c = 'WorkOrder'];
        email.htmlBody = '<html><body>';
        email.htmlBody += '<tr><td>Attribute Name</td><td>Attribute Value</td></tr>';
        for(Email_Parsing_Field_Mapping__mdt mapping : fieldMapping){
            if(mapping.SF_Field_Type__c == 'DateTime'){
                email.htmlBody += '<tr><td>' + mapping.Email_Field__c + '</td><td>19-JUL-2017 08:06</td></tr>';
            }
            else if(mapping.SF_Field_Type__c == 'Text'){
                email.htmlBody += '<tr><td>' + mapping.Email_Field__c + '</td><td>test' + i + '</td></tr>';
            }
            i++;
        }
        email.htmlBody += '<tr><td>Territory</td><td>TerritoryName</td></tr>';
        email.htmlBody += '<tr><td>Equipment Address3</td><td>SYDNEY NSW AU 2000</td></tr>';
        email.htmlBody += '</body></html>';

        email.fromAddress ='test@test.com';
        String contactEmail = 'john@test.com';
        email.ccAddresses = new String[] {' John Test <' + contactEmail + '>'};
        email.subject = 'Email-Test-SR:123456789-Test';
        
        NCRIncomingEmailHandler emailHandler = new NCRIncomingEmailHandler();
        
        Test.startTest();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(email, env);
        Test.stopTest();
        
        System.assert(result.success, 'InboundEmailResult returned a failure message');
        List<WorkOrder> workOrders = [SELECT Id FROM WorkOrder];
        System.assertEquals(1,workOrders.size(),'Work Order not created as expected');

        List<CKSW_BASE__Service__c> services = [SELECT Id FROM CKSW_BASE__Service__c];
        System.assertEquals(1,services.size(),'Service not created as expected');
	}

    @isTest
    static void testhandleInboundEmailNoContractMapping() {

        // Create a new email and envelope object
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        // Create the email body
        Integer i = 0;
        List<Email_Parsing_Field_Mapping__mdt> fieldMapping = [SELECT Email_Field__c, SF_Field__c, SF_Field_Type__c, SF_Object_Type__c
                                                                        FROM Email_Parsing_Field_Mapping__mdt WHERE SF_Object_Type__c = 'WorkOrder'];
        email.htmlBody = '<html><body>';
        email.htmlBody += '<tr><td>Attribute Name</td><td>Attribute Value</td></tr>';
        for(Email_Parsing_Field_Mapping__mdt mapping : fieldMapping){
            if(mapping.SF_Field_Type__c == 'DateTime'){
                email.htmlBody += '<tr><td>' + mapping.Email_Field__c + '</td><td>19-JUL-2017 08:06</td></tr>';
            }
            else if(mapping.SF_Field_Type__c == 'Text'){
                email.htmlBody += '<tr><td>' + mapping.Email_Field__c + '</td><td>test' + i + '</td></tr>';
            }
            i++;
        }
        email.htmlBody += '</body></html>';

        email.fromAddress ='test@test.com';
        String contactEmail = 'john@test.com';
        email.ccAddresses = new String[] {' John Test <' + contactEmail + '>'};
        email.subject = 'Email-Test-SR:123456789-Test';
        
        NCRIncomingEmailHandler emailHandler = new NCRIncomingEmailHandler();
        
        Test.startTest();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(email, env);
        Test.stopTest();
        
        System.assert(result.success, 'InboundEmailResult returned a failure message');

        List<Email_Log__c> emailLogs = [SELECT Id, Status__c FROM Email_Log__c];
        System.assertEquals(1,emailLogs.size(),'Email Log not created as expected');
        System.assertEquals('Error',emailLogs[0].Status__c,'Email Log not create with the right status');
    }

    @isTest
    static void testhandleInboundEmailError() {

        // Create a new email and envelope object
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        // Create the email body
        Integer i = 0;
        List<Email_Parsing_Field_Mapping__mdt> fieldMapping = [SELECT Email_Field__c, SF_Field__c, SF_Field_Type__c, SF_Object_Type__c
                                                                        FROM Email_Parsing_Field_Mapping__mdt WHERE SF_Object_Type__c = 'WorkOrder'];
        email.htmlBody = '<html><body>';
        email.htmlBody += '<tr><td>Attribute Name</td><td>Attribute Value</td></tr>';
        for(Email_Parsing_Field_Mapping__mdt mapping : fieldMapping){
            if(mapping.SF_Field_Type__c == 'DateTime'){
                email.htmlBody += '<tr><td>' + mapping.Email_Field__c + '</td><td>19-JUL-2017 08:06</td></tr>';
            }
            else if(mapping.SF_Field_Type__c == 'Text'){
                email.htmlBody += '<tr><td>' + mapping.Email_Field__c + '</td><td>Test value too long for some fields' + i + '</td></tr>';
            }
            i++;
        }
        email.htmlBody += '<tr><td>Territory</td><td>TerritoryName</td></tr>';
        email.htmlBody += '</body></html>';

        email.fromAddress ='test@test.com';
        String contactEmail = 'john@test.com';
        email.ccAddresses = new String[] {' John Test <' + contactEmail + '>'};
        email.subject = 'Email-Test-SR:123456789-Test';
        
        NCRIncomingEmailHandler emailHandler = new NCRIncomingEmailHandler();
        
        Test.startTest();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(email, env);
        Test.stopTest();
        
        System.assert (!result.success, 'InboundEmailResult should have returned a failure message');

        List<Email_Log__c> emailLogs = [SELECT Id, Status__c FROM Email_Log__c];
        System.assertEquals(1,emailLogs.size(),'Email Log not created as expected');
        System.assertEquals('Error',emailLogs[0].Status__c,'Email Log not create with the right status');
    }
}