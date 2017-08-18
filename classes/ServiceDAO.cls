public class ServiceDAO {

	public static List<CKSW_BASE__Service__c> getServicesById(Set<Id> serviceIds) {

		return [SELECT 	Id, 
						Name,
						Work_Order__c, 
					   	Service_Engineering_Cost__c,
					   	Service_Engineering_Revenue__c,
					   	Service_Pass_Through_Cost__c,
					   	Service_Pass_Through_Revenue__c,
					   	Resource_User_Id__c 
				FROM  	CKSW_BASE__Service__c 
	            WHERE 	Id IN: serviceIds];
	}
}