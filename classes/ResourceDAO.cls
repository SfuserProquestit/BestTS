public class ResourceDAO {
	public static List<CKSW_BASE__Resource__c> getActiveResource(String profileName) {
		return [Select	Id,
						Name,	
						CKSW_BASE__User__c,
						CKSW_BASE__User__r.LastLoginDate,
						(Select Id,Name From CKSW_BASE__Services__r Where Is_Service_Open__c = true)
				From	CKSW_BASE__Resource__c
				Where 	CKSW_BASE__User__r.IsActive = true
				And		CKSW_BASE__User__r.Profile.Name LIKE :profileName
				Order By CKSW_BASE__User__r.LastLoginDate ASC ];
	}
}