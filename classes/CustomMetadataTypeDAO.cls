public with sharing class CustomMetadataTypeDAO {
	public static List<Licensing__mdt> getLicensingForProfile(String profileName){
		return [Select  Total_Number_of_Licenses__c
				From	Licensing__mdt
				Where 	MasterLabel = :profileName];
	}

    public static List<Email_Parsing_Field_Mapping__mdt> getEmailParsingMapping(){
        return [SELECT Email_Field__c, SF_Field__c, SF_Field_Type__c, SF_Object_Type__c
                FROM Email_Parsing_Field_Mapping__mdt];
    }

    public static List<Month_Mapping__mdt> getMonthMappingByMonthText(List<String> monthTexts){
        return [SELECT Month_Digit__c, Month_Text__c
                FROM Month_Mapping__mdt 
                WHERE Month_Text__c IN :monthTexts];
    }

    public static List<Technician_Status_Transition__mdt> getTechnStatusTransitionByFromStatusAPI(List<String> fromStatus){
        return [SELECT From_Status__c, From_Status_API_Name__c, To_Status__c, To_Status_API_Name__c
                FROM Technician_Status_Transition__mdt 
                WHERE From_Status_API_Name__c IN :fromStatus];
    }
    
    
    public static boolean getTriggerSettingForFSLMigration(){
        boolean enabled = true;
        if(Test.isRunningTest()){
            return enabled;
        }
       
        ActivateTriggers__c trigSetting = ActivateTriggers__c.getOrgDefaults();
      
       
        if(trigSetting!=null  && trigSetting.Enabled__c == false) {
           enabled = false;
        }
        return enabled;        
   }
}