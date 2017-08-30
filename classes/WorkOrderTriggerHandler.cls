public class WorkOrderTriggerHandler {

    public static void setTimeStamps(List<WorkOrder> newWorkOrders, Map<Id,WorkOrder> oldWorkOrders){
        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.WorkOrder);
        Id masterWORecordTypeId = rtMap.get(Constants.RECORD_TYPE_MASTER_WORK_ORDER).getRecordTypeId();

        for(WorkOrder newWO : newWorkOrders){
            WorkOrder oldWO = oldWorkOrders.get(newWO.Id);
            if(newWo.RecordTypeId == masterWORecordTypeId && newWO.Status != oldWO.Status && newWo.Status == Constants.WORK_ORDER_STATUS_CLOSED){
                newWO.Closed_On__c=Datetime.now();
            }
        }
    }

    public static Boolean runUpdateSAStatus = true;

    public static void preventInvoicedWODeletion(List<WorkOrder> workOrders) {
        for(WorkOrder wo : workOrders) {
            if(wo.Invoice_Created__c) {
                wo.addError(Label.CannotDeleteWO);
            }
        }
    }

    //update the status of the related Service Appointment for a not Master Work Order 
    public static void updateSAStatus(List<WorkOrder> newWorkOrders, Map<Id,WorkOrder> oldWorkOrders){
        
        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.WorkOrder);
        Id masterWORecordTypeId = rtMap.get(Constants.RECORD_TYPE_MASTER_WORK_ORDER).getRecordTypeId();
        
        Map<Id,WorkOrder> workOrders = new Map<Id,WorkOrder>();
        for(WorkOrder newWO : newWorkOrders){
            WorkOrder oldWO = oldWorkOrders.get(newWO.Id);
            if(newWo.RecordTypeId != masterWORecordTypeId && newWO.Status != oldWO.Status){
                workOrders.put(newWO.Id,newWO);
            }
        }

        if(workOrders.size()>0){
            List<ServiceAppointment> serviceAppointments = ServiceAppointmentDAO.getSerAppointmentsByParentRecordId(workOrders.keySet());
            
            if(serviceAppointments.size()>0){
                for(ServiceAppointment sa : serviceAppointments){
                    sa.Status = workOrders.get(sa.ParentRecordId).Status;
                }
                try{
                    ServiceAppointmentTriggerHandler.runUpdateWorkOrderStatus=false;
                    update serviceAppointments;
                }
                catch(DMLException e){
                    Trigger.new[0].addError(e.getDmlMessage(0)); //To display a nice error message when status can't be changed from value to another based on SA status transition
                }
            }
        }
    }

    public static void updateParentWorkOrderStatus(List<WorkOrder> newWorkOrders, Map<Id,WorkOrder> oldWorkOrders){
        
        Map<String,Schema.RecordTypeInfo> rtMap = RecordTypeDAO.getRecordTypes(Schema.SObjectType.WorkOrder);
        Id masterWORecordTypeId = rtMap.get(Constants.RECORD_TYPE_MASTER_WORK_ORDER).getRecordTypeId();

        Set<Id> parentWorkOrderIds = new Set<Id>();

        for(WorkOrder newWO : newWorkOrders){
            WorkOrder oldWO = oldWorkOrders.get(newWO.Id);
            if(newWO.RecordTypeId != masterWORecordTypeId 
                && newWO.Status != oldWO.Status
                && (newWO.Status == Constants.WORK_ORDER_STATUS_CLOSED || newWO.Status == Constants.WORK_ORDER_STATUS_COMPLETED)){
                parentWorkOrderIds.add(newWO.ParentWorkOrderId);
            }
        }

        List<WorkOrder> parentWorkOrders = WorkOrderDAO.getWorkOrdersById(parentWorkOrderIds);
        List<WorkOrder> parentWorkOrdersToUpdate = new List<WorkOrder>();

        for(WorkOrder parentWO : parentWorkOrders){
            Boolean hasOpenWOService = false;

            for(WorkOrder childWorkOrder : parentWO.ChildWorkOrders){
                if(childWorkOrder.Status != Constants.WORK_ORDER_STATUS_CLOSED && childWorkOrder.Status != Constants.WORK_ORDER_STATUS_COMPLETED) {
                    hasOpenWOService = true;
                }
            }
            if(!hasOpenWOService) {
                parentWO.Status = Constants.WORK_ORDER_STATUS_COMPLETED;
                parentWorkOrdersToUpdate.add(parentWO);
            }
        }

        if(!parentWorkOrdersToUpdate.isEmpty()) {
            try {
                update parentWorkOrdersToUpdate;
            } catch(Exception exp) {
                System.debug('==An exception occurred while updating wo status==' + exp.getMessage());
            }
        }
    }

    //Remove sharing on a Work Order and Parent Work Order for a technician when the Service Resource is changed
    public static void deleteWorkOrderSharing(List<WorkOrder> newWorkOrders, Map<Id,WorkOrder> oldWorkOrders){
        Set<Id> workOrderIds = new Set<Id>();
        for(WorkOrder newWO : newWorkOrders){
            WorkOrder oldWO = oldWorkOrders.get(newWO.Id);
            if(oldWO.ParentWorkOrderId != null && newWO.Service_Resource__c != oldWO.Service_Resource__c && oldWO.Service_Resource__c != null){
                workOrderIds.add(oldWO.Id);
            }
        }

        if(workOrderIds.size()>0){
            List<WorkOrder> workOrders = WorkOrderDAO.getWorkOrdersById(workOrderIds);
            
            Set<Id> removeSharingUserIds = new Set<Id>();
            Set<Id> removeSharingWorkOrderIds = new Set<Id>();

            for(WorkOrder wo : workOrders){
                removeSharingUserIds.add(wo.Service_Resource__r.RelatedRecordId);
                removeSharingWorkOrderIds.add(wo.ParentWorkOrderId);
                removeSharingWorkOrderIds.add(wo.Id);
            }

            List<WorkOrderShare> workOrderShare = ObjectShareDAO.getWorkOrderShareByParentIdUserId(removeSharingWorkOrderIds, removeSharingUserIds);
            if(workOrderShare.size()>0){
                delete workOrderShare;
            }
        }
    }

    //Create sharing on Parent Work Order for a technician
    public static void createParentWorkOrderSharing(List<WorkOrder> newWorkOrders, Map<Id,WorkOrder> oldWorkOrders){
        Set<Id> workOrderIds = new Set<Id>();
        for(WorkOrder newWO : newWorkOrders){
            WorkOrder oldWO = oldWorkOrders.get(newWO.Id);
            if(newWO.ParentWorkOrderId != null && newWO.Service_Resource__c != null  
                && newWO.Service_Resource__c != oldWO.Service_Resource__c){
                workOrderIds.add(newWO.Id);
            }
        }

        if(workOrderIds.size()>0){
            List<WorkOrder> workOrders = WorkOrderDAO.getWorkOrdersById(workOrderIds);

            List<WorkOrderShare> workOrderShare = new List<WorkOrderShare>();
            for(WorkOrder wo : workOrders){
                workOrderShare.add(new WorkOrderShare(ParentId=wo.ParentWorkOrderId,
                                                    UserOrGroupId=wo.Service_Resource__r.RelatedRecordId,
                                                    AccessLevel=Constants.OBJECT_ACCESS_LEVEL));
            }
            System.debug('debugShare '+workOrderShare);
            insert workOrderShare;
        }
    }

    //Create sharing on Parent Work Order for a technician when Owner Change ()
    public static void createParentWorkOrderSharingOnOwnerChange(List<WorkOrder> newWorkOrders, Map<Id,WorkOrder> oldWorkOrders){
        Set<Id> workOrderIds = new Set<Id>();
        for(WorkOrder newWO : newWorkOrders){
            WorkOrder oldWO = oldWorkOrders.get(newWO.Id);
            if(newWO.ParentWorkOrderId == null && newWO.OwnerId != oldWO.OwnerId){
                workOrderIds.add(newWO.Id);
            }
        }

        if(workOrderIds.size()>0){
            List<WorkOrder> workOrders = WorkOrderDAO.getWorkOrdersById(workOrderIds);
            List<WorkOrderShare> workOrderShare = new List<WorkOrderShare>();
            for(WorkOrder wo : workOrders){
                for(WorkOrder child : wo.ChildWorkOrders){
                    workOrderShare.add(new WorkOrderShare(ParentId=child.ParentWorkOrderId,
                                                        UserOrGroupId=child.Service_Resource__r.RelatedRecordId,
                                                        AccessLevel=Constants.OBJECT_ACCESS_LEVEL));
                }
            }
            insert workOrderShare;
        }
    }
}