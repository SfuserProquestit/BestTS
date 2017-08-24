public with sharing class HomeNotification {
	public HomeNotification(){}
	public Organization org = [Select Name, Id From Organization];
	public User us = [select Id, Name, Email, Username, CompanyName from User where LastLoginDate!=null ORDER BY LastLoginDate DESC limit 1];	
	public List<SVMXC__ServiceMax_List__c> lists = [select id, name from SVMXC__ServiceMax_List__c];
	public Integer getlistsize(){
		return lists.size();
	}
	public User getCurrentUser(){
		return us;
	} 
	public Boolean IpadLite{get; set;}
	public Boolean getipadtrial(){
		us = getCurrentUser();
		if(us.CompanyName!=null){
			if(us.CompanyName.contains('Ipad')==true || us.Username.contains('ipad')) {
				return true;
			}
			if(us.CompanyName.contains('Ipad Trial4')==true||us.CompanyName.contains('IPAD TRIAL4')==true){
				IpadLite=false;
			} else {IpadLite=true;}
		}
		
		System.debug('IpadLite1: '+IpadLite);
		return false;
	}
	
	// ** Create ServiceMax List record **//
	// ** Triggers Data XML in Static Resources into the org **//
	public void insertList(){
		if(org.Id!='00DA0000000aj6X' && org.Id!='00DA0000000aj6XMAQ' && us.CompanyName!=null){  // not Titanium Base Org
			if(us.CompanyName!=null){
				if(us.CompanyName.contains('Ipad')==true || us.Username.contains('ipad')) {				
					if(lists.size()==0){
						SVMXC__ServiceMax_List__c l = new SVMXC__ServiceMax_List__c();
						insert l;	
					}					
				}
				if(us.CompanyName.contains('Ipad Trial4')==true){
					IpadLite=false;
				} else {IpadLite=true;}
			}
		}
		System.debug('IpadLite2: '+IpadLite);
	}
	public void reset(){
		if(org.Id!='00DA0000000aj6X' && org.Id!='00DA0000000aj6XMAQ' && us.CompanyName!=null){  // not Titanium Base Org
			AlldeleteList();
			insertList();
		}
	}
	public void AlldeleteList(){
		if(org.Id!='00DA0000000aj6X' && org.Id!='00DA0000000aj6XMAQ' && us.CompanyName!=null ){  // not Titanium Base Org
			List<SVMXC__ServiceMax_List__c> lists = [select id, name from SVMXC__ServiceMax_List__c];
			delete lists;
		}
	}
	
	static testmethod void test1(){
		SVMXC__ServiceMax_List__c lister = new SVMXC__ServiceMax_List__c(name='Data Load Test');
		insert lister;
	}
	static testmethod void test2(){			
        //Test coverage for the ServiceMaxMassDataEdit
        PageReference pageRef = Page.HomeNotification;
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        HomeNotification myPageCon1 = new HomeNotification();
		myPageCon1.getlistsize(); myPageCon1.getCurrentUser();
		myPageCon1.getipadtrial(); myPageCon1.reset(); myPageCon1.AlldeleteList(); myPageCon1.insertList();
		Test.stopTest();		
	}	
}