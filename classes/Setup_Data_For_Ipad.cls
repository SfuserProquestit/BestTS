global public class Setup_Data_For_Ipad implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {

	Map <String, Setup_Data_For_Ipad.ObjectInfo> objectInfoMap = new Map<String, Setup_Data_For_Ipad.ObjectInfo>();
//	Map<String, StaticResource> resourceMap = new Map<String, StaticResource>();
	private global final Id svmxlist_id;
	User g_user;
	
	Map<String, Schema.Sobjecttype>m_global_objects;
		
	List <Setup_Data_For_Ipad.objectXML> oxmllist = new List <Setup_Data_For_Ipad.objectXML>();

	String sampleData;
	
	Double g_percentComplete;
	
	global Setup_Data_For_Ipad(Id list_id) {
		svmxlist_id = list_id;
		m_global_objects = Schema.getGlobalDescribe();
	}
	
	global Iterable<Integer> start(Database.BatchableContext BC) {
		g_user = [Select Id, Name, Email, Phone from User where Id = :UserInfo.getUserId()];
		try {
			setUsersTimeZone();
		} catch (Exception ex) {}
		List <StaticResource> srlist = [Select Id, Name, Body from StaticResource where Name like '%SVMX_iPad_%Data%' Order by Name] ;
		List <Integer> ilist = new List<Integer>();
		Integer ix=0;
		for (StaticResource sr: srlist) {
			String str = sr.Body.toString();
			sampleData = str;
			Dom.Document myDoc = new Dom.Document();
			myDoc.load(str);
			Dom.XMLNode myRoot = myDoc.getRootElement();
			
		   	for(Dom.XMLNode child : myRoot.getChildElements()) {
/*		   		ObjectXML oxml = new ObjectXML();
		   		oxml.objectNode = child;
     			oxmllist.add(oxml);
*/
     			ilist.add(ix++);
			}
		}
		// add recordTypes and Pricebook2 here.
		ObjectInfo recInfo = new ObjectInfo('RecordType');
		recInfo.name = 'RecordType';
		for (RecordType rt: [Select Id, Name from RecordType])
			recInfo.idMap.put(rt.Name, rt.Id);
		objectInfoMap.put('RecordType', recInfo);

		ObjectInfo pricebookInfo = new ObjectInfo('Pricebook2');
		pricebookInfo.name = 'Pricebook2';
		for (PriceBook2 pb2: [Select Id, Name from PriceBook2])
			pricebookInfo.idMap.put(pb2.Name, pb2.Id);
		objectInfoMap.put('Pricebook2', pricebookInfo);

		g_percentComplete = 20;
		updatePercentComplete(g_percentComplete);		
		return ilist;
	}
	static Dom.XmlNode returnNode(String str, Integer offset) {
		Dom.Document myDoc = new Dom.Document();
		myDoc.load(str);
		Integer ix = 0;
		Dom.XmlNode myRoot = myDoc.getRootElement();
		return myRoot.getChildElements().get(offset);
	}
	global void execute(Database.BatchableContext BC, List<Integer> scope) {
		// Get the sObject describe result for the Account object 
		//		Schema.DescribeSObjectResult r = Account.sObjectType.getDescribe();
		System.debug('execute');
		System.debug(oxmllist);
		System.debug('Size is' + oxmllist.size());
		for (Integer ix: scope) {
			parseObjectData(returnNode(sampleData, ix), objectInfoMap);
		}
	}
	global void finish(Database.BatchableContext BC) {
		updatePercentComplete(100.0d);
	}
	//@future (callout=true )
	public static void doDataLoad(Id svmxlist_id) {
		Map <String, ObjectInfo> objMap = new Map<String, ObjectInfo>();
		SVMXC__ServiceMax_List__c svl = new SVMXC__ServiceMax_List__c(Id = svmxlist_id);
		svl.SVMXC__Discount__c = 100.0;
		if (svmxlist_id != null)
			update svl;
		
		List <StaticResource> srlist = [Select Id, Name, Body from StaticResource where Name = 'SVMX_iPad_Sample_Data'] ;
		for (StaticResource sr: srlist) {
			String str = sr.Body.toString();
			Dom.Document myDoc = new Dom.Document();
			myDoc.load(str);
			Dom.XMLNode myRoot = myDoc.getRootElement();
		   	for(Dom.XMLNode child : myRoot.getChildElements()) {
     		//	parseObjectData(child, objMap);
			}
		}
	}

	public void parseObjectData(Dom.XMLNode objNode, Map <String, ObjectInfo> oMap) {
		ObjectInfo oinfo;
		Schema.Sobjecttype T = null;
		
		/*
        */
		Map<String, Schema.DescribeFieldResult> mapFields = new Map<String, Schema.DescribeFieldResult>();
		
		for(Dom.XMLNode child : objNode.getChildElements()) {
			System.debug('child is ' + child.getName());
			String chname = child.getName();
			
			if (chname == 'DataRecord') {
				SObject sobj = makeSObject(oinfo.name, T, mapFields, child);
				if (sobj != null)
					oinfo.newobjlist.add(sobj);
			} else if (chname == 'ObjectName') {
				oinfo = new ObjectInfo(child.getText());
				System.debug('Adding metadata for ' + child.getText());
				T = m_global_objects.get(oinfo.name);
				Schema.DescribeSObjectResult R1 = T.getDescribe();
				Map<String, Schema.SobjectField> fieldMap = R1.fields.getMap();
				for (String fieldKey : fieldMap.keySet()) {
		            Schema.SObjectField fsObj = fieldMap.get(fieldKey);
		        	Schema.DescribeFieldResult f = fsObj.getDescribe();
		        	mapFields.put(fieldKey.trim().toLowerCase(), f);
		        }
			} else if (chname == 'KeyField') {
				oinfo.keyfield = child.getText();
			} else if (chname == 'Master') {
				oinfo.master = child.getText() == 'Yes'? true:false;
			}
		}
		// Query for existing records & get ids
		Set <String> whereset = new Set<String>();
		List <SObject> existingrecs;
		if (oinfo.keyfield != null && oinfo.master == true) { // Query existing only for master data.
			for (SObject sobj : oinfo.newobjlist) {			
				whereset.add((String) sobj.get(oinfo.keyfield));
			}
			existingrecs = Database.Query('Select Id, ' + oinfo.keyfield + ' from ' + oinfo.name + ' Where ' + oinfo.keyfield + ' in :whereset');
		}
		if (existingrecs != null && existingrecs.size() > 0) {
			// records already exist. So use the values.
		} else {
			if (oinfo.name == 'SVMXC__Service_Order__c') {
				cleanupWorkOrders(oinfo);
			} else if (oinfo.name == 'FeedPost') 
				cleanupFeedPost();
			// Insert new records here.
			printval('before', oinfo.newobjlist);
			try {
				insert oinfo.newobjlist;
			} catch (Exception ex) {}
			printval('after', oinfo.newobjlist);
			existingrecs = oinfo.newobjlist;
		}
		if (oinfo.keyfield != null) {
			System.debug('keyfield is' + oinfo.keyfield);
			for (SObject sobj: existingrecs) {
				oinfo.idMap.put((String) sobj.get(oinfo.keyfield), sobj.Id);
			}
		}

		System.debug('oinfo is ' + oinfo);
		oMap.put(oinfo.name, oinfo);
		g_percentComplete += 5;
		updatePercentComplete(g_percentComplete);
	}
	public void cleanupWorkOrders(ObjectInfo oinfo) {
		Set <String> whereset = new Set<String>();
		for (SObject sobj : oinfo.newobjlist) {			
			whereset.add((String) sobj.get(oinfo.keyfield));
		}
		Id userId = UserInfo.getUserId();
		Set <Id> wo_id_set = new Set <Id>();
		List <SVMXC__Service_Order__c>existingrecs = Database.Query('Select Id, ' + oinfo.keyfield + ' from ' + oinfo.name + ' Where ' + oinfo.keyfield + ' in :whereset and OwnerId = :userId');
		for (SVMXC__Service_Order__c svo: existingrecs)
			wo_id_set.add(svo.Id);
		List <Event> evlist = [Select Id from Event where WhatId in :wo_id_set];
		delete evlist;
		delete existingrecs;		
	}
	public void cleanupFeedPost() {
		Set <Id> productset = new Set<Id>(objectInfoMap.get('Product2').idMap.values());

		List <Product2Feed> fplist = [Select Id from Product2Feed where ParentId in :productset and Type = 'TextPost'];
		delete fplist;
	}
	public SObject makeSObject(String objname, Schema.Sobjecttype T, Map<String, Schema.DescribeFieldResult> mapFields, Dom.XMLNode node) {
		SObject sobj = objname == 'Account'? new Account():(objname == 'Contact'? new Contact():(objname=='Event'?new Event():
					(objname == 'SVMXC__Site__c'?new SVMXC__Site__c():(objname == 'Product2'?new Product2():(objname == 'SVMXC__Installed_Product__c'?new SVMXC__Installed_Product__c():
						(objname == 'SVMXC__Service_Group__c'?new SVMXC__Service_Group__c():(objname == 'SVMXC__Service_Group_Members__c'?new SVMXC__Service_Group_Members__c():
						(objname == 'SVMXC__Service_Group_Costs__c'? new SVMXC__Service_Group_Costs__c():(objname == 'PricebookEntry'?new PricebookEntry():
						(objname == 'SVMXC__Service_Level__c'? new SVMXC__Service_Level__c():(objname == 'SVMXC__Service_Order__c'? (SObject) new SVMXC__Service_Order__c():
						(objname == 'SVMXC__Service_Order_Line__c'? (SObject)new SVMXC__Service_Order_Line__c():null
						))))))))))));

		if (sobj == null) {
			if (objname == 'Folder')
				sobj = new Folder();
			else if (objname == 'Document')
				sobj = new Document();
			else if (objname == 'Attachment')
				sobj = new Attachment();
			else if (objname == 'FeedPost')
				sobj = new FeedPost();
			
		}
//		SObject sobj = T.newSObject();
		String chname, attr_value, value;
		Integer offset;
		Date d;
		Datetime dt;
		Time tm;
		String [] arr_tm;
		Schema.DescribeFieldResult f;
		System.debug(mapFields);

		for(Dom.XMLNode child : node.getChildElements()) {
			chname = child.getName();
			value = child.getText();
			f = mapFields.get(chname.trim().toLowerCase());
			System.debug('Field name is ' + chname + ' : data type is ' + f);
			Schema.DisplayType ftype = f != null? f.getType() : Schema.DisplayType.String;
			if (ftype == Schema.Displaytype.Currency || ftype == Schema.Displaytype.Double || ftype == Schema.Displaytype.Percent) {
				sobj.put(chname, Double.valueOf(value));
			} else if (ftype == Schema.Displaytype.Integer) {
				sobj.put(chname, Integer.valueOf(value));
			} else if (ftype == Schema.Displaytype.Reference) {
				attr_value = child.getAttributeValue('FKey', '');
				if (attr_value != null) {
					System.debug('fkey is ' + attr_value + ' : objectInfoMap is ' + objectInfoMap.get(attr_value));
				}
				ObjectInfo oinfo = objectInfoMap.get(attr_value);
				if (oinfo != null) 
					sobj.put(chname, oinfo.idMap.get(value));
				else {
					if (value == 'CURRENT_USER_ID')
						sobj.put(chname, UserInfo.getUserId());
					else if (value == 'CURRENT_USER_NAME')
						sobj.put(chname, oinfo.idMap.get(g_user.Name));
				}				
			} else if (ftype == Schema.Displaytype.BOOLEAN){
				sobj.put(chname, Boolean.valueOf(value));
			} else if (ftype == Schema.Displaytype.DATE) {
				attr_value = child.getAttributeValue('Offset', '');
				if (attr_value != null) {
					offset = Integer.valueOf(attr_value);
					System.debug('date offset is ' + attr_value);
					d = System.today().addDays(offset);
					sobj.put(chname, d);
				} else {
					sobj.put(chname, Date.valueOf(value));
				}
			} else if (ftype == Schema.Displaytype.DATETIME) {
				attr_value = child.getAttributeValue('Offset', ''); // Offset for datetime field is w.r.t now.
				if (attr_value != null) {
					offset = Integer.valueOf(attr_value);
					System.debug('dt offset is ' + attr_value);
					dt = System.now().addMinutes(offset);
					sobj.put(chname, dt);
					System.debug('Field name is :' + chname + ' : dt offset is ' + attr_value + ': Time Value is :' + sobj.get(chname));
				} else {
					// If Offset is not found, then look for DateField
					attr_value = child.getAttributeValue('DateField', ''); // Offset for datetime field is w.r.t now.
					if (attr_value == null)
						sobj.put(chname, Date.valueOf(value));
					else {
						arr_tm = value.split(':');
						tm = Time.newInstance(Integer.valueOf(arr_tm[0]), Integer.valueOf(arr_tm[1]), 0, 0);
						dt = DateTime.newInstance((Date)sobj.get(attr_value), tm);
						sobj.put(chname, dt);
					}
				}
			} else if (ftype == Schema.Displaytype.BASE64) {
				// sobj.put(chname, resourceMap.get(value).Body);
				if (objname == 'Attachment') { // handle attachment separately due to heap size limit
					// Assuming that the Body is being fetched.
					try {
						StaticResource sr = [Select Id, Name, Body from StaticResource where Name = :value];
						sobj.put(chname, sr.Body);
					} catch (Exception ex){return null;}
				}				
			} else { // Catchall is string.
				if (value.startsWith('CURRENT_')) {
					value = value == 'CURRENT_USER_EMAIL'?g_user.Email:(value == 'CURRENT_USER_NAME'?g_user.Name:(value == 'CURRENT_USER_PHONE'?g_user.Phone:value));
				}
				sobj.put(chname, value);				
			}
		}
		return sobj;	
	}
	
	public void updatePercentComplete(Double percentComplete) {
		SVMXC__ServiceMax_List__c svl = new SVMXC__ServiceMax_List__c(Id = svmxlist_id);
		svl.SVMXC__Discount__c = percentComplete;
		try {
			if (svmxlist_id != null)
				update svl;
		} catch (Exception ex){}		
	}
	global class ObjectInfo {
		String name;
		List <SObject> newobjlist = null;
		Map<String, Id> idMap = new Map<String, Id>();
		String keyfield;
		Boolean master;
		public ObjectInfo(String objname) {
			this.name = objname;
/*				newobjlist = objname == 'Account'? new List<Account>():(objname == 'Contact'? new List<Contact>():(objname=='Event'?new List<Event>():
				(objname == 'SVMXC__Site__c'?new List<SVMXC__Site__c>():(objname == 'Product2'?new List <Product2>():(objname == 'SVMXC__Installed_Product__c'?new List<SVMXC__Installed_Product__c>():
					(objname == 'SVMXC__Service_Group__c'?new List<SVMXC__Service_Group__c>():(objname == 'SVMXC__Service_Group_Members__c'?new List<SVMXC__Service_Group_Members__c>():
					(objname == 'SVMXC__Service_Group_Costs__c'? new List <SVMXC__Service_Group_Costs__c>():(objname == 'PricebookEntry'?(List <PricebookEntry>)new List<PricebookEntry>():
					(objname == 'SVMXC__Service_Level__c'?(List<SVMXC__Service_Level__c>) new List<SVMXC__Service_Level__c>():(objname == 'SVMXC__Service_Order__c'? (List <Sobject>)new List<SVMXC__Service_Order__c>():
					(objname == 'SVMXC__Service_Order_Line__c'? (List <SObject>)new List<SVMXC__Service_Order_Line__c>():null
					))))))))))));
*/
			if (objname == 'Account') 
				newobjlist = new List<Account>();
			else if (objname == 'Contact')
				newobjlist = new List<Contact>();
			else if (objname=='Event')
				newobjlist = new List<Event>();
			else if (objname == 'SVMXC__Site__c')
				newobjlist = new List<SVMXC__Site__c>();
			else if(objname == 'Product2')
				newobjlist = new List <Product2>();
			else if (objname == 'SVMXC__Installed_Product__c')
				newobjlist = new List<SVMXC__Installed_Product__c>();
			else if (objname == 'SVMXC__Service_Group__c')
				newobjlist = new List<SVMXC__Service_Group__c>();
			else if (objname == 'SVMXC__Service_Group_Members__c')
				newobjlist = new List<SVMXC__Service_Group_Members__c>();
			else if (objname == 'SVMXC__Service_Group_Costs__c')
				newobjlist = new List <SVMXC__Service_Group_Costs__c>();
			else if (objname == 'PricebookEntry')
				newobjlist = new List<PricebookEntry>();
			else if (objname == 'SVMXC__Service_Level__c')
				newobjlist = new List<SVMXC__Service_Level__c>();
			else if (objname == 'SVMXC__Service_Order__c')
				newobjlist = new List<SVMXC__Service_Order__c>();
			else if (objname == 'SVMXC__Service_Order_Line__c')
				newobjlist = new List<SVMXC__Service_Order_Line__c>();
			else if (objname == 'Folder')
				newobjlist = new List<Folder>();
			else if (objname == 'Document')
				newobjlist = new List<Document>();
			else if (objname == 'Attachment')
				newobjlist = new List<Attachment>();
			else if (objname == 'FeedPost')
				newobjlist = new List<FeedPost>();
			else
				newobjlist = new List<SObject>();
		
		}
	}
	private void setUsersTimeZone() {
		Schema.DescribeFieldResult f = User.TimeZoneSidKey.getDescribe();
		List<Schema.PicklistEntry> P = F.getPicklistValues();
		SVMXC__ServiceMax_List__c svl = [Select Id, SVMXC__Additional_Information__c
										FROM SVMXC__ServiceMax_List__c
										WHERE Id = :svmxlist_id];
		String [] str = null;
		if (svl.SVMXC__Additional_Information__c != null)
			str = svl.SVMXC__Additional_Information__c.split('<GMTOffset>');	
		String tzPickStart = null;							
		if (str != null && str.size() > 0) {
			String offset = str[1].substring(0, str[1].indexOf('</GMTOffset>'));
			tzPickStart = '(GMT' + offset;
		} else
			return;
		for (Schema.PicklistEntry pe: P) {
			if (pe.getLabel().startsWith(tzPickStart)) {
				User u = new User(TimeZoneSidKey = pe.getValue(), Id = g_user.Id);
				update u;
				break;
			}
		}
	}
	
	global class objectXML {
		String name;
		Dom.XMLNode objectNode;
	}
	
	private void printval(String debugval, List<SObject> sobj) {
		try {
			System.debug(debugval + ' : SVMXC__Resolution_Customer_By__c val :' + sobj[0].get('SVMXC__Resolution_Customer_By__c'));
			if (debugval == 'before')
				return;
			List <SVMXC__Service_Order__c> updsvolist = new List<SVMXC__Service_Order__c>();
			Set <Id> idset = new Set <Id>();
			for (SObject so1:sobj) {
				SVMXC__Service_Order__c so = (SVMXC__Service_Order__c) so1;
				updsvolist.add(new SVMXC__Service_Order__c(Id = so.Id, SVMXC__Restoration_Internal_By__c = so.SVMXC__Restoration_Internal_By__c,
							SVMXC__Restoration_Customer_By__c = so.SVMXC__Restoration_Customer_By__c, SVMXC__Resolution_Internal_By__c = so.SVMXC__Resolution_Internal_By__c,
							SVMXC__Resolution_Customer_By__c = so.SVMXC__Resolution_Customer_By__c));
				idset.add(so.Id);
			}
			update updsvolist;
			for (SVMXC__Service_Order__c svo: [Select SVMXC__Resolution_Customer_By__c from SVMXC__Service_Order__c where Id in :idset])
				System.debug('time is ' + svo.SVMXC__Resolution_Customer_By__c);
		} catch (Exception e){}
	}
}