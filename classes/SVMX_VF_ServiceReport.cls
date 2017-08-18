public class SVMX_VF_ServiceReport
{
    
    public Document document = new Document();
    String cId = System.currentPageReference().getParameters().get('DispTyp');
    public String getrender(){ String b; if (cId == 'pdf'){b = 'pdf';} return b; }
    public list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();
    public list<SVMXC__Service_Order__c> WorkOrder= new list<SVMXC__Service_Order__c>();
    List<Wraper> WOInfoArray = new List<Wraper>();
    public string strDispTyp = System.currentPageReference().getParameters().get('DispTyp');
    public string getstrDispTyp(){if(this.strDispTyp == 'pdf') return this.strDispTyp; else return null;}
    public string contype = System.currentPageReference().getParameters().get('DispTyp');
    public string getcontype (){return COMM_Utils_Reports.getcontype(strDispTyp);}
    
    String strRecordId = System.currentPageReference().getParameters().get('RecordId');
    
    public SVMX_VF_ServiceReport(ApexPages.StandardController controller)
    {
        try
        {
            document = [Select d.Url, d.Type, d.SystemModstamp, d.NamespacePrefix, d.Name, d.LastModifiedDate, d.LastModifiedById, d.Keywords, d.IsPublic, d.IsInternalUseOnly, d.IsDeleted, d.IsBodySearchable, d.Id, d.FolderId, d.DeveloperName, d.Description, d.CreatedDate, d.CreatedById, d.ContentType, d.BodyLength, d.Body, d.AuthorId From Document d where Name = 'Servicemax Three'];
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();
            String fieldNames = getFieldNamesFromList(getFieldList(fieldMap,true));
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Company__r.Name';
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Contact__r.Name';
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Contact__r.Phone';
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Contact__r.Fax';
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Contact__r.Email';
            fieldNames +=' ,   SVMXC__Component__r.SVMXC__Product__r.Name ';
            fieldNames +=' ,   SVMXC__Component__r.SVMXC__Serial_Lot_Number__c ';

            string d = System.currentPageReference().getParameters().get('d');
            if(d<> null && d.length() > 0 )
            {
                mlst = [select SVMXC__Object_Id__c from SVMXC__ServiceMax_List__c where SVMXC__Source_Location__c = :d ];
                list<string> s= new list<string>();
                string strIds = '(';
                for(SVMXC__ServiceMax_List__c o :mlst )
                {
                    s.add(o.ID);
                    if (mlst[0].Id != o.ID)
                        strIds += ', ';
                    strIds += '\''+o.SVMXC__Object_Id__c +'\'';
                }
                strIds +=')';
                 string q = 'select '+ fieldNames +'  from SVMXC__Service_Order__c s where s.id in ' + strIds;
                if (mlst.size()>0 && fieldNames <> null && fieldNames.length() > 0 && strIds <> null && strIds.length() > 0)
                    WorkOrder = database.query(q );
            } 
            else
            {
                if(strRecordId <> null && strRecordId.length() > 0 && fieldNames <> null && fieldNames.length() > 0)
                {
                    string q = 'select '+ fieldNames +'  from SVMXC__Service_Order__c s where s.id = \'' + strRecordId + '\'';
                    WorkOrder = database.query(q);
                }
            }
        }
        catch(Exception ex)
        {
        } 
    }
    public  List<Wraper> getWorkOrders()
    {
        try
        {
           set<id> setID = new set<id>();
           for(SVMXC__Service_Order__c wo:WorkOrder)
           {
             setId.add(wo.id);
           }
           List<SVMXC__Service_Order_Line__c> lines = getWorkOrderDetail(setId);
           for(SVMXC__Service_Order__c wo:WorkOrder)
           {              
                 List<SVMXC__Service_Order_Line__c> lines2 = new List<SVMXC__Service_Order_Line__c>(); 
                for(SVMXC__Service_Order_Line__c o :lines )
                { 
                    if(wo.id == o.SVMXC__Service_Order__c )
                        lines2.add(o);
                }
                WOInfoArray.add( new Wraper(wo, lines2, COMM_Utils_Reports.getFormattedDate(wo.CreatedDate)));
           }
        }
        catch(Exception ex)
        {
        }
        return WOInfoArray;
    } 
               
    public  List<SVMXC__Service_Order_Line__c> getWorkOrderDetail(set<id> setID)   
    {
        List<SVMXC__Service_Order_Line__c> WorkOrderDetailArray = new List<SVMXC__Service_Order_Line__c> (); 
        try
        {
            WorkOrderDetailArray = [SELECT id, SVMXC__Line_Type__c, SVMXC__Service_Order__c, SVMXC__Activity_Type__c, SVMXC__Expense_Type__c, SVMXC__Product__r.Name, SVMXC__Reference_Information__c, SVMXC__Actual_Quantity2__c, SVMXC__Actual_Price2__c FROM SVMXC__Service_Order_Line__c where SVMXC__Service_Order__c in :setId];     
        } 
        catch (Exception e)
        {
        }
        return WorkOrderDetailArray;            
    }         
    public static List<String> getFieldList( Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields)
    {
        List<String> fieldList = new List<String>();
        try
        {
            //build dynamic list of fieldnames
            for (String fieldKey : fieldMap.keySet()) 
            {
                Schema.SObjectField fsObj = fieldMap.get(fieldKey);
                Schema.DescribeFieldResult f = fsObj.getDescribe();
                String fieldName;
                fieldName = f.getName();
                if (selectAllFields) 
                        fieldList.add(fieldName);         
                else
                {
                    if (f.getName()=='Id' || f.isNameField() || f.isCustom()) 
                    {
                        fieldList.add(fieldName);
                    }
                }
            }
        } 
        catch (Exception e)
        {
        }    
        return fieldList;
    }
    public static String getFieldNamesFromList(List<String> fieldList) 
    {
        String fieldNames = '';
        for (String field : fieldList) 
        {
            if (fieldNames.length()>0) 
                fieldNames += ',';
            fieldNames += field;
        }
        return fieldNames;
    }  
    /*SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
    public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('WORDREP001');*/
    public String getREPTAG005(){ return system.Label.WORDREP001_REPTAG005;}
    public String getREPTAG006(){ return system.Label.WORDREP001_REPTAG006;}
    public String getREPTAG007(){return null;}//{ return svmxTagList.containsKey('REPTAG007')?svmxTagList.get('REPTAG007') : '';}
	public Document getdocument(){return document;}  
    public class Wraper 
    {
        public SVMXC__Service_Order__c sObj;
            public SVMXC__Service_Order__c getsObj(){return this.sObj;}
        public list<SVMXC__Service_Order_Line__c> lstsObj;
            public list<SVMXC__Service_Order_Line__c> getlstsObj(){return this.lstsObj;}
        public string WOCreatedDate;
            public string getWOCreatedDate() {return this.WOCreatedDate;}
        public Wraper(SVMXC__Service_Order__c b , list<SVMXC__Service_Order_Line__c> lstb, string strb)
        {
            sObj = b;
            lstsObj=lstb;
            WOCreatedDate=strb;
        }
    }     
}