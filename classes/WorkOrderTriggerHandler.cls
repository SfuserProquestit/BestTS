public class WorkOrderTriggerHandler {
	public static void preventInvoicedWODeletion(List<WorkOrder> workOrders) {
		for(WorkOrder wo : workOrders) {
			if(wo.Invoice_Created__c) {
				wo.addError(Label.CannotDeleteWO);
			}
		}
	}
}