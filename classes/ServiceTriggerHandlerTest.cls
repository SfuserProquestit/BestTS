@isTest(seeAllData=true)
public class ServiceTriggerHandlerTest {
	static testmethod void testDynamicLicensing(){
		List<Account> accounts = TestUtility.createAccounts(2);
                insert accounts;

                List<CKSW_BASE__Service_Type__c> serviceTypes = TestUtility.createServiceTypes(2);
                insert serviceTypes;

                List<WorkOrder> workorders = TestUtility.createWorkOrders(accounts.get(0), 10);
                insert workorders;

                List<CKSW_BASE__Location__c> locations = TestUtility.createLocations(accounts.get(0), 2);
                insert locations;

                List<CKSW_BASE__Service__c> services = new List<CKSW_BASE__Service__c>();
                for(WorkOrder workOrder : workorders){
                	services.addAll(TestUtility.createServices(workOrder, serviceTypes.get(0), locations.get(0), Constants.SERVICE_STATUS_IN_PROGRESS, 1));
                }
                insert services;

                Profile techProfile = [Select Id From Profile Where Name LIKE :Constants.PROFILE_NAME_FOR_TECHNICIAN];
                Profile adminProfile = [Select Id From Profile Where Name LIKE :Constants.PROFILE_NAME_FOR_DISPATCHER];
                Profile dispatcherProfile = [Select Id From Profile Where Name LIKE :Constants.PROFILE_NAME_FOR_ADMIN];

                List<User> users = TestUtility.createUsers(10, techProfile.Id);
                for(Integer i=5; i<10; i++){
                	users.get(i).isActive = false;
                }
                insert users;

                List<User> admins = TestUtility.createUsers(1, adminProfile.Id);
                admins.get(0).Username = 'admin@proquestit.com';
                admins.get(0).COMMUNITYNICKNAME = 'admin';
                admins.get(0).ALIAS = 'admin';
                insert admins;


                List<CKSW_BASE__Resource__c> resources = TestUtility.createResource(users, locations.get(0));
                insert resources;
                System.debug('***assignment:');
                Integer serCount = 0;
                Set<Id> servIds = new Set<Id>();
                for(CKSW_BASE__Service__c service : services){
                	if(resources.size() > serCount){
                		service.CKSW_BASE__Resource__c = resources.get(serCount).Id;
                		service.CKSW_BASE__Status__c = Constants.SERVICE_STATUS_ASSIGNED;
                		service.CKSW_BASE__Finish__c = System.now().addHours(1);
                		service.CKSW_BASE__Start__c = System.now();
                		serCount++;
                        }
                }
                update services;

                Set<Id> userIds = new Set<Id>();
                for(User user: users){
                        userIds.add(user.Id);
                }


                Test.startTest();
                        for(CKSW_BASE__Service__c service : services){
        	        	if(service.CKSW_BASE__Status__c == Constants.SERVICE_STATUS_ASSIGNED){
        	        		service.CKSW_BASE__Status__c = Constants.SERVICE_STATUS_DISPACTHED;
                                        servIds.add(service.Id);
        	        	}
        	        }
        	        update services;

                        services = [Select Id From CKSW_BASE__Service__c Where Id IN :servIds AND CKSW_BASE__Status__c = :Constants.SERVICE_STATUS_ASSIGNED];
                        System.assertEquals(services.size(), 3);

                        services = [Select Id From CKSW_BASE__Service__c Where Id IN :servIds AND CKSW_BASE__Status__c = :Constants.SERVICE_STATUS_DISPACTHED];
                        System.assertEquals(services.size(), 7);

                        users = [Select Id From User Where Id IN :userIds AND IsActive = false];
                        System.assertEquals(users.size(),5);

                        users = [Select Id From User Where Id IN :userIds AND IsActive = true];
                        System.assertEquals(users.size(),5);
                Test.stopTest();

        

	}
}