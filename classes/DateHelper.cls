public class DateHelper {
    //Convert string date in format 'dd-MM-YYYY HH:mm' where months are in format text (JAN,FEB,...)
    public static DateTime convertStringToDateTime(String strDate){
        String monthText = strDate.subString(3,6);
        Month_Mapping__mdt monthMapping = CustomMetadataTypeDAO.getMonthMappingByMonthText(new List<String>{monthText})[0];
        String monthNumber = monthMapping.Month_Digit__c;
        strDate = strDate.replace(monthText, monthNumber);
        return DateTime.newInstance(Integer.valueOf(strDate.subString(6,10)), Integer.valueOf(strDate.subString(3,5)), Integer.valueOf(strDate.subString(0,2)), Integer.valueOf(strDate.subString(11,13)), Integer.valueOf(strDate.subString(14,16)), 0);
    }
}