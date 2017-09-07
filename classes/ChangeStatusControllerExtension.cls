public class ChangeStatusControllerExtension {
    
    public WorkOrder theWorkOrder;
    public List<String> nextStatusSelected {get; set;}
    public string woStatus {get; set;}
    
    public ApexPages.StandardController sc;

    public ChangeStatusControllerExtension(ApexPages.StandardController stdController){
        theWorkOrder = (WorkOrder)stdController.getRecord();
        nextStatusSelected = getNextStatusSelected(theWorkOrder.Status);
        this.sc = stdController;
    }

    public List<String> getNextStatusSelected(String fromStatus){
        List<Technician_Status_Transition__mdt> technicianStatusTransitions = CustomMetadataTypeDAO.getTechnStatusTransitionByFromStatusAPI(new String[]{fromStatus});
        List<String> options = new List<String>();
        for(Technician_Status_Transition__mdt statusTransition: technicianStatusTransitions){
            options.add(statusTransition.To_Status__c);
        }
        return options;
    }

    public PageReference updateWorkOrderStatus(){
        theWorkOrder.Status = woStatus;
        if(woStatus == Constants.WORK_ORDER_STATUS_CAPTURE_SIGNATURE){
            PageReference p = new PageReference(Url.getSalesforceBaseUrl().toExternalForm()+'/Technicians/apex/WOSignatureCapture?Id='+theWorkOrder.Id);
            return p;     
        }
        else{
            return sc.save();
        }
    }
}