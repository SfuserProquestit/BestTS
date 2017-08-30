public class ServiceTriggerHandler {

	/*public static void updateWorkOrdersStatus(Map<Id, CKSW_BASE__Service__c> services, Boolean isdelete) {
		
	    List<Id> workOrderIds = new List<Id>();

	    for(CKSW_BASE__Service__c service : ServiceDAO.getServicesById(services.keySet())) {
			workOrderIds.add(service.Work_Order__c); 
	    }

	    List<WorkOrder> workorders = new List<WorkOrder>();
	    for(WorkOrder wo : WorkOrderDAO.getWorkOrdersById(workOrderIds)) {
	    	Boolean isopenService = false;

	    	for(CKSW_BASE__Service__c service : wo.Services__r) {
	    		if(service.CKSW_BASE__Status__c <> Constants.SERVICE_STATUS_CLOSED && service.CKSW_BASE__Status__c <> Constants.SERVICE_STATUS_COMPLETED) {
	    			isopenService = true;
	    		}
	    	}
	    	if(!isopenService) {
	    		wo.Status = Constants.SERVICE_STATUS_COMPLETED;
				workorders.add(wo);
	    	}
	    }

		if(!workorders.isEmpty()) {
	    	try {
	    		update workorders;
    		} catch(Exception exp) {
    			System.debug('==An exception occurred while updating wo status==' + exp.getMessage());
    		}
	    	
	    }
	}

	public static void preventInvoicedWOServiceDeletion(List<CKSW_BASE__Service__c> services) {
		for(CKSW_BASE__Service__c service : services) 
			if(service.Invoice_Created__c) 
				service.addError(Label.CannotDeleteService);
	}

	public static void allocateLicensing(Map<Id, CKSW_BASE__Service__c> services, List<CKSW_BASE__Service__c> newServices){
		Set<Id> userIds = new Set<Id>();
		Set<Id> serviceIds = new Set<Id>();
		Map<Id,Set<CKSW_BASE__Service__c>> userIdToServices = new Map<Id,Set<CKSW_BASE__Service__c>>();
		
		//Check whether the service is open and whether the service status or the service resource is changed
		for(CKSW_BASE__Service__c service: newServices){
			if(	services != null 
				&& service.CKSW_BASE__Status__c != services.get(service.Id).CKSW_BASE__Status__c
				&& service.CKSW_BASE__Resource__c != null
				&& service.CKSW_BASE__Status__c == Constants.SERVICE_STATUS_DISPACTHED
				&& service.Is_Service_Open__c
				&& !service.Is_Resource_Active__c ){
				System.debug('***old status:'+services.get(service.Id).CKSW_BASE__Status__c);
				System.debug('***new status:'+service.CKSW_BASE__Status__c);
				serviceIds.add(service.Id);
				userIds.add(service.Resource_User_Id__c);
				if(userIdToServices.containsKey(service.Resource_User_Id__c)){
					userIdToServices.get(service.Resource_User_Id__c).add(service);
				}else{
					Set<CKSW_BASE__Service__c> tempSet = new Set<CKSW_BASE__Service__c>();
					tempSet.add(service);
					userIdToServices.put(service.Resource_User_Id__c, tempSet);
				}
			}
		}

		if(!userIds.isEmpty() && !serviceIds.isEmpty()){
			List<Id> userIdList = new List<Id>();
			userIdList.addAll(userIds);
			System.debug('***allocateLicensing:');
			resolveDynamicLicensing(serviceIds, userIdList, userIdToServices);
		}
	}

	//@future
	public static void resolveDynamicLicensing(Set<Id> serviceIds, List<Id> userIds, Map<Id,Set<CKSW_BASE__Service__c>> userIdToServices){
		List<Licensing__mdt> licensing = CustomMetadataTypeDAO.getLicensingForProfile(Constants.PROFILE_NAME_FOR_TECHNICIAN);
		//find resources who have ac active license without an open service
		List<CKSW_BASE__Resource__c> resources = ResourceDAO.getActiveResource(Constants.PROFILE_NAME_FOR_TECHNICIAN);

		Integer totalLicences = Test.isRunningTest() ? 20 : Integer.valueOf(licensing.get(0).Total_Number_of_Licenses__c);
		Integer licenseInUse = resources.size();
		Integer licenseCanBeReleased = 0;
		Integer licenseNeeded = userIds.size();
		Integer availableLicence = totalLicences - licenseInUse;
		List<Id> techsToDeallocate = new List<Id>();
		if(!resources.isEmpty()){
			for(CKSW_BASE__Resource__c resource : resources){
				if(resource.CKSW_BASE__Services__r.size() == 0){
					System.debug('***resource:'+resource.Name+'service:'+resource.CKSW_BASE__Services__r);
					licenseCanBeReleased++;
					techsToDeallocate.add(resource.CKSW_BASE__User__c);
				}
			}	
		}
		System.debug('***licenseCanBeReleased:'+licenseCanBeReleased);
		System.debug('***availableLicence:'+availableLicence);
		licenseCanBeReleased = Test.isRunningTest() ? 2 : licenseCanBeReleased+availableLicence;

		List<User> updateUsers= new List<User>();
		Set<Id> licenseNotAllocated = new Set<Id>();
		Set<Id> inactivateUsers = new Set<Id>();
		Set<Id> activateUsers = new Set<Id>();
		System.debug('***totalLicences:'+totalLicences);
		System.debug('***licenseInUse:'+licenseInUse);	
		System.debug('***licenseCanBeReleased:'+licenseCanBeReleased);	
		System.debug('***licenseNeeded:'+licenseNeeded);	

		if(licenseCanBeReleased == 0){
			for(Id userId: userIdToServices.keySet()){
				licenseNotAllocated.add(userId);
			}
		}else{
			Set<Id> licenseAllocated = new Set<Id>();
			
			//release the licenses which can be release, for others send an email
			Integer numberofLicence = licenseNeeded > licenseCanBeReleased ? licenseCanBeReleased : licenseNeeded;
			for(Integer rCount = 0; rCount < numberofLicence; rCount++){
				//updateUsers.add(new User(Id = techsToDeallocate.get(rCount), IsActive = false));
				if(techsToDeallocate.size() > rCount){
					inactivateUsers.add(techsToDeallocate.get(rCount));
				}
				//updateUsers.add(new User(Id = userIds.get(rCount), IsActive = true));
				if(userIds.size() > rCount){
					activateUsers.add(userIds.get(rCount));
					licenseAllocated.add(userIds.get(rCount));
				}
			}
			//find the users where the license was not allocated
			for(Id userId: userIdToServices.keySet()){
				if(!licenseAllocated.contains(userId)){
					licenseNotAllocated.add(userId);
				}
			}
		}
		System.debug('***licenseNotAllocated:'+licenseNotAllocated);
		if(!licenseNotAllocated.isEmpty()){
			Set<String> serviceNames = getServicesWhichCannotBeDispatched(userIdToServices, licenseNotAllocated);
			sendEmailToCoordinator(serviceNames);
		}

		System.debug('***inactivateUsers:'+inactivateUsers);
		System.debug('***activateUsers:'+activateUsers);

		if(!inactivateUsers.isEmpty()){
			changeUsers(inactivateUsers, false);
		}

		if(!activateUsers.isEmpty()){
			changeUsers(activateUsers, true);
		}

		//updateUsers.get(0).addError('Contact Imalka');
		
	}

	@future
	private static void changeUsers(Set<Id> userIds, Boolean isActive){
		List<User> users = UserDAO.getUsers(userIds);
		for(User user: users){
			user.IsActive = isActive;
		}
		update users;
	}

	private static Set<String> getServicesWhichCannotBeDispatched(Map<Id,Set<CKSW_BASE__Service__c>> userIdToServices, Set<Id> licenseNotAllocated){
		Set<String> serviceNames = new Set<String>();
		List<CKSW_BASE__Service__c> services = new List<CKSW_BASE__Service__c>();
		for(Id userId : userIdToServices.keySet()){
			if(licenseNotAllocated.contains(userId)){
				for(CKSW_BASE__Service__c service : userIdToServices.get(userId)){
					serviceNames.add(service.Name);
					services.add(new CKSW_BASE__Service__c(Id = service.Id, CKSW_BASE__Status__c = Constants.SERVICE_STATUS_ASSIGNED));
				}
			}
		}
		if(!services.isEmpty()){
			update services;
		}
		System.debug('***services:'+services);
		return serviceNames;
	}

	private static void sendEmailToCoordinator(Set<String> serviceNames){
		Profile dispatcher = [Select Id From Profile Where Name LIKE :Constants.PROFILE_NAME_FOR_DISPATCHER];
		Profile admin = [Select Id From Profile Where Name LIKE :Constants.PROFILE_NAME_FOR_ADMIN];
		Set<Id> profileIds = new Set<Id>();
		profileIds.add(dispatcher.Id);
		profileIds.add(admin.Id);
		System.debug('***profileIds:'+profileIds);
		List<User> users = UserDAO.getUsersForProfiles(profileIds);
		System.debug('***users:'+users);
		String[] emailAddresses;
		if(users.size() > 0){
			emailAddresses = new String[users.size()];
			Integer userCount = 0;
			for(User user: users){
				emailAddresses[userCount]=user.Email;
				userCount++;
			}
		}

		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		// Set recipients to two contact IDs.
		// Replace IDs with valid record IDs in your org.
		message.toAddresses = emailAddresses;
		message.subject = 'NO FIELD SERVICE LICENCES AVAILABLE';
		String htmlBody = 'Hi,<br/><br/>The following Services were unable to be scheduled as no Technician licences are available.<br/><br/>';
		
		for(String sName : serviceNames){
			htmlBody += 'Service '+sName+'<br/>';
		}
		htmlBody += '<br/>Please contact your Field Service Manager';
		message.setHtmlBody(htmlBody);

		Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
		if (results[0].success) {
		    System.debug('The email was sent successfully.');
		} else {
		    System.debug('The email failed to send: '
		          + results[0].errors[0].message);
		}

	}*/
}