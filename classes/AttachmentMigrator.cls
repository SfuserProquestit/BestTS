global class AttachmentMigrator implements Database.Batchable<sObject> {
	
	String query;
	
	global AttachmentMigrator() {
		this.query = 'Select Id, SFPS_FSMT_BaseId__c From WorkOrder Where SFPS_FSMT_BaseId__c != null';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		Set<String> parentIds = new Set<String>();
   		Map<String,Id> serviceToWO = new Map<String,Id>();
		for(sObject sObj : scope){
			WorkOrder wo = (WorkOrder)sObj;
			parentIds.add(wo.SFPS_FSMT_BaseId__c);
			serviceToWO.put(wo.SFPS_FSMT_BaseId__c, wo.Id);
		}
		List<Attachment> newattachments = new List<Attachment>();
		for(Attachment attach : [SELECT Id, ParentId, Body, BodyLength, ContentType, Description, Name From Attachment Where parentId = :parentIds]){
			Attachment newAttach = attach;
			newAttach.Id = null;
			newAttach.ParentId = serviceToWO.get(attach.ParentId);
			newattachments.add(newAttach);
		}
		if(!newattachments.isEmpty()){
			insert newattachments;
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}