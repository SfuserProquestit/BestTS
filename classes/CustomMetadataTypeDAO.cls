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
}