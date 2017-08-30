public class UsageFSLHandler {

    public static void calculateRollups(Map<Id, Usage_FSL__c> usages, Boolean isdelete) {

        Map<Id, Usage_FSL__c> usagesMap;
        Set<Id> woServiceIds = new Set<Id>();

        for(Usage_FSL__c usage : UsageDAO.getUsagesById(usages.keySet())) {
            woServiceIds.add(usage.Service_Work_Order__c); 
        }

        if(woServiceIds.isEmpty()) return;

        usagesMap = (isdelete) ? UsageDAO.getUsageMap(woServiceIds, usages.keySet()) : 
                                 UsageDAO.getUsageMap(woServiceIds);

        Map<Id, Decimal> woServiceIdVsEnggCostMap = new Map<Id, Decimal>();
        Map<Id, Decimal> woServiceIdVsEnggRevenueMap = new Map<Id, Decimal>();
        Map<Id, Decimal> woServiceIdVsPassThrCostMap = new Map<Id, Decimal>();
        Map<Id, Decimal> woServiceIdVsPassThrRevenueMap = new Map<Id, Decimal>();

        for(AggregateResult ar : UsageDAO.getUsagesAggregateResult(usagesMap.keySet())) {

                woServiceIdVsEnggCostMap.put((Id)ar.get('Service_Work_Order__c'), (Decimal)ar.get('totalenggcost'));
                woServiceIdVsEnggRevenueMap.put((Id)ar.get('Service_Work_Order__c'), (Decimal)ar.get('totalenggrevenue'));
                woServiceIdVsPassThrCostMap.put((Id)ar.get('Service_Work_Order__c'), (Decimal)ar.get('totalpassthrcost'));
                woServiceIdVsPassThrRevenueMap.put((Id)ar.get('Service_Work_Order__c'), (Decimal)ar.get('totalpassthrrevenue'));
        }
        
        if(woServiceIdVsEnggCostMap.isEmpty()) return;

        List<WorkOrder> woServicesToBeUpdates = new List<WorkOrder>();
        
        for(WorkOrder woService : WorkOrderDAO.getWorkOrdersById(woServiceIdVsEnggCostMap.keySet())) {

            woService.Service_Engineering_Cost__c     = woServiceIdVsEnggCostMap.get(woService.Id);
            woService.Service_Engineering_Revenue__c  = woServiceIdVsEnggRevenueMap.get(woService.Id);
            woService.Service_Pass_Through_Cost__c    = woServiceIdVsPassThrCostMap.get(woService.Id);
            woService.Service_Pass_Through_Revenue__c = woServiceIdVsPassThrRevenueMap.get(woService.Id);
            woServicesToBeUpdates.add(woService);
        }

        if(!woServicesToBeUpdates.isEmpty()) {
            try {
                update woServicesToBeUpdates;
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

    public static void setParentWorkOrder(List<Usage_FSL__c> usages){
        Set<Id> workOrderIds = new Set<Id>();
        for(Usage_FSL__c usage : usages){
            if(usage.Service_Work_Order__c != null && (usage.Service_Work_Order__c == usage.Work_Order__c || usage.Work_Order__c==null)){
                workOrderIds.add(usage.Service_Work_Order__c);
            }
        }

        if(workOrderIds.size()>0){
            Map<Id,WorkOrder> workOrders = new Map<Id,WorkOrder>(WorkOrderDAO.getWorkOrdersById(workOrderIds));
            for(Usage_FSL__c usage : usages){
                usage.Work_Order__c=workOrders.get(usage.Service_Work_Order__c).ParentWorkOrderId;
                usage.Service_Contract__c=workOrders.get(usage.Service_Work_Order__c).ServiceContractId;
            }
        }
    }
}