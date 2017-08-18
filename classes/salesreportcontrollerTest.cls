/*
 * Written by Joey Ho. 5/5/16
 * Test Class for salesreportcontroller.apxc 
*/
@isTest
public class salesreportcontrollerTest{
    
    @isTest(SeeAllData='true')
    public static void runSalesReportFunction() {
        salesreportcontroller rep = new salesreportcontroller();
        
        test.startTest();
        rep.getGeneralPipelineTable();
        rep.getQuickQuoteTable();
        rep.getSolutionsTable();
        
        //Test scheduler
        salesreportscheduler sched = new salesreportscheduler();
        sched.execute(null);
        test.stopTest();
    }
}