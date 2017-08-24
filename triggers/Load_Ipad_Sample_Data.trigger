trigger Load_Ipad_Sample_Data on SVMXC__ServiceMax_List__c (before insert, after insert) {
	/*	
	if (Trigger.isBefore) {
		Trigger.new[0].SVMXC__Discount__c = 10.0;
	} else {
		System.debug('Id is' + trigger.new[0].Id);
	//	Setup_Data_For_Ipad.doDataLoad(trigger.new[0].Id);
		Id bpid = Database.executeBatch(new Setup_Data_For_Ipad(trigger.new[0].Id), 1);
	}
	*/
}