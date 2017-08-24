public class RecordTypeDAO {
	public static Map<String,Schema.RecordTypeInfo> getRecordTypes(Schema.DescribeSObjectResult describe) {
		Map<String,Schema.RecordTypeInfo> rtMapByName = describe.getRecordTypeInfosByName();
		return rtMapByName;	    	
    }
}