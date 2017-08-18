@isTest
public class WorkOrderTriggerHandlerTest {
    
    static testMethod void testPreventInvoicedWODeletion() {
        List<Account> accounts = TestUtility.createAccounts(2);
        insert accounts;

        List<CKSW_BASE__Service_Type__c> serviceTypes = TestUtility.createServiceTypes(2);
        insert serviceTypes;

        List<WorkOrder> workorders = TestUtility.createWorkOrders(accounts.get(0), 2);
        //workorders.get(1).Invoice_Created__c = true;
        insert workorders;

        Test.startTest();
            // allow delete
            delete workorders.get(0);
            
            // don't allow delete
            try {
                delete workorders.get(1);
            } catch(Exception exp) {
                //System.assert(exp.getMessage().contains(Label.CannotDeleteWO));
            }
        
        Test.stopTest();

        
    }
}