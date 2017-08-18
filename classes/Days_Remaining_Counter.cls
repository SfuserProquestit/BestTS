public with sharing class Days_Remaining_Counter {
	public Days_Remaining_Counter(){}
	public Integer getTrialDays(){
		DateTime dt = [select CreatedDate From Organization].CreatedDate;
		//30 days ahead of Trial Day - Current DateTime
		Decimal counter = dt.getTime()+(30*60.0*60*24*1000)-System.now().getTime();
		Integer count = (counter/(60.0*60*24*1000)).setScale(0).intValue();
		return count;
	} 
	
	static testmethod void test1(){
		Days_Remaining_Counter drc = new Days_Remaining_Counter();
		drc.getTrialDays();
	}
}