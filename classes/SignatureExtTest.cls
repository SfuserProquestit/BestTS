@isTest
private class SignatureExtTest {
    static testMethod void runPositiveTestCases(){
        
        List<Account> accounts = TestUtility.createAccounts(2);
        insert accounts;

        List<CKSW_BASE__Service_Type__c> serviceTypes = TestUtility.createServiceTypes(2);
        insert serviceTypes;

        List<WorkOrder> workorders = TestUtility.createWorkOrders(accounts.get(0), 10);
        insert workorders;

        List<CKSW_BASE__Location__c> locations = TestUtility.createLocations(accounts.get(0), 2);
        insert locations;

        List<CKSW_BASE__Service__c> services = new List<CKSW_BASE__Service__c>();
        for(WorkOrder workOrder : workorders){
          services.addAll(TestUtility.createServices(workOrder, serviceTypes.get(0), locations.get(0), Constants.SERVICE_STATUS_ON_SITE, 1));
        }
        insert services;
        
      
        ApexPages.StandardController sc = new ApexPages.StandardController(services[0]);
        SignatureExt sp = new SignatureExt(sc);
        String result = SignatureExt.uploadSignature('123456',services[0].ID, 'Safety_Induction');
        System.debug('Result is ' + result);
        System.assert(result!=null);
    }
}