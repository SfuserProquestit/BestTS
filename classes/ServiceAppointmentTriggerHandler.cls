public class ServiceAppointmentTriggerHandler {

    public static Boolean runUpdateWorkOrderStatus = true;

    //update the status of the parent Work Order
    public static void updateWorkOrderStatus(List<ServiceAppointment> newServiceAppointments, Map<Id,ServiceAppointment> oldServiceAppointments){
        List<WorkOrder> workOrdersToUpdate = new List<WorkOrder>();
        for(ServiceAppointment newSA : newServiceAppointments){
            ServiceAppointment oldSA = oldServiceAppointments.get(newSA.Id);
            if(newSA.ParentRecordId.getSObjectType() == WorkOrder.sObjectType 
                && newSA.Status != oldSA.Status){
                workOrdersToUpdate.add(new WorkOrder(Id=newSA.Work_Order__c,
                                                Status=newSA.Status));
            }
        }

        if(workOrdersToUpdate.size()>0){
            try{
                WorkOrderTriggerHandler.runUpdateSAStatus = false;
                update workOrdersToUpdate;
            }catch(DMLException e){
                Trigger.new[0].addError(e.getDmlMessage(0)); //To display a nice error message when status can't be changed from value to another based on SA status transition
            }
        }
    }

    public static void setWorkOrderRelationship(List<ServiceAppointment> newServiceAppointments){
        for(ServiceAppointment newSA : newServiceAppointments){
            if(newSA.ParentRecordId.getSObjectType() == WorkOrder.sObjectType){
                newSA.Work_Order__c = newSA.ParentRecordId;
            }
        }
    }

    public static void setServiceAppointmentOnWorkOrder(List<ServiceAppointment> newServiceAppointments){
        List<WorkOrder> workOrders = new List<WorkOrder>();
        for(ServiceAppointment newSA : newServiceAppointments){
            if(newSA.ParentRecordId.getSObjectType() == WorkOrder.sObjectType){
                workOrders.add(new WorkOrder(Id=newSA.ParentRecordId,
                                            Service_Appointment__c=newSA.Id));
            }
        }
        if(workOrders.size()>0){
            update workOrders;
        }
    }
}