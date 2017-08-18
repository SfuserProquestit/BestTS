public class WorkOrderDAO {
	public static List<WorkOrder> getWorkOrdersById(List<Id> workOrderIds) {
		return 	[SELECT Id, Status, (SELECT Id, Name, CKSW_BASE__Status__c FROM Services__r)
				 FROM WorkOrder
				 WHERE Id IN: workOrderIds];
	}

    public static List<WorkOrder> getWorkOrdersBySRNumber(List<String> srNumbers) {
        return  [SELECT Id, WorkOrderNumber
                 FROM WorkOrder
                 WHERE Customer_s_Reference__c IN :srNumbers];
    }
}