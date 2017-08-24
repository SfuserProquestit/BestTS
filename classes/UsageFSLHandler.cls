public class UsageFSLHandler {

	public static void calculateRollups(Map<Id, Usage_FSL__c> usages, Boolean isdelete) {

	    Map<Id, Usage_FSL__c> usagesMap;
	    List<Id> serviceIds = new List<Id>();

	    for(Usage_FSL__c usage : UsageDAO.getUsagesById(usages.keySet())) {
			serviceIds.add(usage.Service__c); 
	    }

	    if(serviceIds.isEmpty()) return;

	    usagesMap = (isdelete) ? UsageDAO.getUsageMap(serviceIds, usages.keySet()) : 
	    						 UsageDAO.getUsageMap(serviceIds);

	   	Map<Id, Decimal> serviceIdVsEnggCostMap = new Map<Id, Decimal>();
	    Map<Id, Decimal> serviceIdVsEnggRevenueMap = new Map<Id, Decimal>();
	    Map<Id, Decimal> serviceIdVsPassThrCostMap = new Map<Id, Decimal>();
	    Map<Id, Decimal> serviceIdVsPassThrRevenueMap = new Map<Id, Decimal>();

	    for(AggregateResult ar : UsageDAO.getUsagesAggregateResult(usagesMap.keySet())) {

	         	serviceIdVsEnggCostMap.put((Id)ar.get('Service__c'), (Decimal)ar.get('totalenggcost'));
	         	serviceIdVsEnggRevenueMap.put((Id)ar.get('Service__c'), (Decimal)ar.get('totalenggrevenue'));
	         	serviceIdVsPassThrCostMap.put((Id)ar.get('Service__c'), (Decimal)ar.get('totalpassthrcost'));
	         	serviceIdVsPassThrRevenueMap.put((Id)ar.get('Service__c'), (Decimal)ar.get('totalpassthrrevenue'));
	    }
	    
	    if(serviceIdVsEnggCostMap.isEmpty()) return;

	    List<CKSW_BASE__Service__c> servicesToBeUpdates = new List<CKSW_BASE__Service__c>();
	    
	    for(CKSW_BASE__Service__c service : ServiceDAO.getServicesById(serviceIdVsEnggCostMap.keySet())) {

			service.Service_Engineering_Cost__c     = serviceIdVsEnggCostMap.get(service.Id);
			service.Service_Engineering_Revenue__c  = serviceIdVsEnggRevenueMap.get(service.Id);
			service.Service_Pass_Through_Cost__c    = serviceIdVsPassThrCostMap.get(service.Id);
			service.Service_Pass_Through_Revenue__c = serviceIdVsPassThrRevenueMap.get(service.Id);
			servicesToBeUpdates.add(service);
	    }

	    if(!servicesToBeUpdates.isEmpty()) {
	    	try {
	    		update servicesToBeUpdates;
    		} catch(Exception exp) {
    			System.debug('==An exception occurred while updating service roll up fields==' + exp.getMessage());
    			// add error
    		}
	    	
	    }
	    
	}

	public static void preventInvoicedUsageDeletion(List<Usage_FSL__c> usages) {
		for(Usage_FSL__c usage : usages) 
			if(usage.Invoice_Created__c) 
				usage.addError(Label.CannotDeleteUsage);
	}
}