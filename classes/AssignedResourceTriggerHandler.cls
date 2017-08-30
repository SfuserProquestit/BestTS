public class AssignedResourceTriggerHandler {

    public static void setServiceResourceOnWorkOrder(Map<Id,AssignedResource> newAssignedResources,Map<Id,AssignedResource> oldAssignedResources){

        Set<Id> assignedResourceIds = new Set<Id>();

        if(oldAssignedResources== null && newAssignedResources != null){
            assignedResourceIds.addAll(newAssignedResources.keySet());
        }
        else if(oldAssignedResources!= null && newAssignedResources != null){
            for(AssignedResource newAssignedResource : newAssignedResources.values()){
                AssignedResource oldAssignedResource = oldAssignedResources.get(newAssignedResource.Id);
                if(newAssignedResource.ServiceResourceId != oldAssignedResource.ServiceResourceId){
                    assignedResourceIds.add(newAssignedResource.Id);
                }
            }
        }

        if(assignedResourceIds.size()>0){
            List<AssignedResource> assignedResources = AssignedResourceDAO.getAssignedResourceByIds(assignedResourceIds);

            Map<Id,WorkOrder> workOrders = new Map<Id,WorkOrder>();
            for(AssignedResource assignedResource : assignedResources){
                if(assignedResource.ServiceAppointment.Work_Order__c!=null){
                    workOrders.put(assignedResource.ServiceAppointment.Work_Order__c,new WorkOrder(Id=assignedResource.ServiceAppointment.Work_Order__c,
                                                                                                    Service_Resource__c=assignedResource.ServiceResourceId));
                }
            }
            if(workOrders.size()>0){
                update workOrders.values();
            }
        }
    }

    public static void setServiceResourceOnWorkOrderWhenDelete(Map<Id,AssignedResource> oldAssignedResources){
        List<AssignedResource> assignedResources = AssignedResourceDAO.getAssignedResourceByIds(oldAssignedResources.keySet());
        Map<Id,WorkOrder> workOrders = new Map<Id,WorkOrder>();
        for(AssignedResource assignedResource : assignedResources){
            if(assignedResource.ServiceAppointment.Work_Order__c!=null){
                workOrders.put(assignedResource.ServiceAppointment.Work_Order__c,new WorkOrder(Id=assignedResource.ServiceAppointment.Work_Order__c,
                                                                                                Service_Resource__c=null));
            }
        }
        if(workOrders.size()>0){
            update workOrders.values();
        }
    }
}