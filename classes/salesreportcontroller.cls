/*
 * Written by Joey Ho. 5/5/16
 * Builds a customised sales report from a set of API reports 
*/
public with sharing class salesreportcontroller {

    public Boolean showBoolean {get; private set;}
    public string showRender{get; private set;}
    
    public transient string totalSalesLastWeek {get; private set;}
    public transient string totalSalesThisMonth {get; private set;}
    public transient string forcastThisMonth {get; private set;}
    public transient string totalSalesThisQtr {get; private set;}
    public transient string forcastThisQtr {get; private set;}
    public transient string totalNewOppsThisWeek {get; private set;}
    public transient string numNewOppsThisWeek {get; private set;}
    public transient integer weightedPipeline {get; private set;}
    public transient string forecastedPipeline {get; private set;}
    public transient string totalNewOppslastWeek {get; private set;}
    public transient string numNewOppslastWeek {get; private set;}

    public transient list<string> solutionsAggregate {get; private set;}
    public transient list<string> quoteAggregate {get; private set;}
    public transient list<string> pipelineAggregate {get; private set;}
    
    private transient Reports.reportResults mainResults;
    private transient list<Reports.GroupingValue> groupingValueList;
    
    /*private transient map<String,string> forcastMAP;

    public transient map<string,Reports.ReportFact> mapRFD {get;set;}
    
    public transient list<Reports.ReportFactWithDetails> factDetailsList {get;set;}
    
    public transient list<reportLineWrapper> reportWrap {get;set;}
    */
    
    //Constructor intilising the load of the reports to build the custom report.
    public salesreportcontroller(){
        //set renderAs Variable
        string renderAs = ApexPages.currentPage().getParameters().get('renderas');        
		this.showRender = (renderAs=='PDF') ? 'PDF':null;
        this.showBoolean = (renderAs=='PDF') ? false:true;
        
        //Set up reports to query
        list<string> reportDevNames = new list <string>();
        reportDevNames.add('API_Report_Closed_Won_Last_Week');
        reportDevNames.add('API_Report_Closed_Won_This_Month');
        reportDevNames.add('API_Report_Forecast_Quota_This_Month');
        
        reportDevNames.add('API_Report_Closed_Won_This_Qtr');
        reportDevNames.add('API_Report_Forecast_Quota_for_this_Qtr');
        reportDevNames.add('API_Report_New_Opportunities_this_Week2');
        reportDevNames.add('API_Report_New_Opportunities_last_Week');
        reportDevNames.add('API_Report_Weighted_Pipeline_Value2');
        
        map<Id,Report> reportMap = new map<Id,Report>([SELECT Id,DeveloperName FROM Report where DeveloperName IN: reportDevNames]);
        
        for(Id reportId:reportMap.keySet()){
            //Declare results from report query
            Reports.reportResults results = Reports.ReportManager.runReport(reportId,true);
            
            string devName = reportMap.get(reportId).DeveloperName;
            
            if(devName == 'API_Report_Closed_Won_Last_Week'){
                //Get the grand total T!T for API_Report_Closed_Won_Last_Week
                list<Reports.SummaryValue> totalLastWeek_agg = results.getFactMap().get('T!T').getAggregates();
                this.totalSalesLastWeek = totalLastWeek_agg[0].getLabel();
            }else if(devName == 'API_Report_Closed_Won_This_Month'){
                //Get the grand total T!T for API_Report_Closed_Won_This_Month
                list<Reports.SummaryValue> totalThisMonth_agg = results.getFactMap().get('T!T').getAggregates();
                this.totalSalesThisMonth = totalThisMonth_agg[0].getLabel();
            }else if(devName =='API_Report_Forecast_Quota_This_Month'){
                //Grand total for Quota this month report
                list<Reports.SummaryValue> forcastThisMonth_agg = results.getFactMap().get('T!T').getAggregates();
                this.forcastThisMonth = forcastThisMonth_agg[0].getLabel(); 
            }else if(devName =='API_Report_Closed_Won_This_Qtr'){
                //Grand Total for Closed one this Qtr
                list<Reports.SummaryValue> totalSalesThisQtr_agg = results.getFactMap().get('T!T').getAggregates();
                this.totalSalesThisQtr = totalSalesThisQtr_agg[0].getLabel(); 
            }else if(devName =='API_Report_Forecast_Quota_for_this_Qtr'){
                list<Reports.SummaryValue> forcastThisQtr_agg = results.getFactMap().get('T!T').getAggregates();                
                this.forcastThisQtr = forcastThisQtr_agg[0].getLabel();
            }else if(devName =='API_Report_New_Opportunities_this_Week2'){
                //Grand total and number of records for New opportunities this week report
                list<Reports.SummaryValue> newOppsThisWeek_agg = results.getFactMap().get('T!T').getAggregates();
                this.totalNewOppsThisWeek = newOppsThisWeek_agg[0].getLabel();
                this.numNewOppsThisWeek = newOppsThisWeek_agg[1].getLabel();
            }else if(devName =='API_Report_New_Opportunities_last_Week'){
                //Grand total and number of records for New opportunities last week report
                list<Reports.SummaryValue> newOppsLastWeek_agg = results.getFactMap().get('T!T').getAggregates();
                this.totalNewOppslastWeek = newOppsLastWeek_agg[0].getLabel();
                this.numNewOppslastWeek = newOppsLastWeek_agg[1].getLabel();
            }else if(devName =='API_Report_Weighted_Pipeline_Value2'){
                //Grand total for weighted pipeline value
                list<Reports.SummaryValue> forecastPipeline_agg = results.getFactMap().get('T!T').getAggregates();
                this.forecastedPipeline = forecastPipeline_agg[0].getLabel();
            
                integer totalForecast = 0;	
                Map<String,Reports.ReportFact> weightedPipeline_agg = results.getFactMap();
                list<string> keys = new list<string>{'0!T','1!T','2!T'};
                for(string k:keys){
                    if(weightedPipeline_agg.containsKey(k)){
                        integer val = integer.valueOf(weightedPipeline_agg.get(k).getAggregates().get(1).getValue());
                        totalForecast += val;     
                    }
                }
                this.weightedPipeline = totalForecast;
                
                /*
                for(string key : forecastPipeline_agg.keySet()){
                    system.debug('key -- ' + key);
                    system.debug('agg :: ' + forecastPipeline_agg.get(key).getAggregates());
                }
*/
            }
            
        }
        
        //Get main report
        list<Report> reportList = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'API_Report_Open_Sales_Opportunities'];
        String reportId = (String)reportList.get(0).get('Id');
        
        // Run a report synchronously
        this.mainResults = Reports.ReportManager.runReport(reportId, true);
        
        //Get list of GroupingValue downwards. This should be forecase values such as Solutions,Quick Quote, Pipeline and further grouping by  user
        this.groupingValueList = mainResults.getGroupingsDown().getGroupings();
        
        //Compile the main sales report for displayin
        //comipileSalesReport();
    }
    
    //The below commented section has been replaced by the new datatable functions that render in pdf
    /*
    public list<reportLineWrapper> getSolutionsGroup(){

        return getReportWrapperGroup('Solutions');        
    }
    
    public list<reportLineWrapper> getQuickQuoteGroup(){
        return getReportWrapperGroup('Quick Quote');
    }
    
    public list<reportLineWrapper> getGeneralPipelineGroup(){
        return getReportWrapperGroup('General Pipeline');
    }
	*/

    public list<tableLineWrapper> getSolutionsTable(){
		//Set Agregate
		this.solutionsAggregate = new list<string>();
        //Return details of table
        return getCustomTableGroup('Solutions',this.solutionsAggregate);        
    }
    
    public list<tableLineWrapper> getQuickQuoteTable(){
        this.quoteAggregate = new list<string>();
        return getCustomTableGroup('Quick Quote',this.quoteAggregate);
    }
    
    public list<tableLineWrapper> getGeneralPipelineTable(){
        this.pipelineAggregate = new list<string>();
        return getCustomTableGroup('General Pipeline',this.pipelineAggregate);
    }
    
    //Send through the type or report with the groupAggregate summary list
    //This is required because renderAs PDF can not handle repeat tags in VF so a datatable tag is used hence create custom class tableLineWrapper
    private list<tableLineWrapper> getCustomTableGroup(string forecastGroup, list<string> groupAggregate){

        list<tableLineWrapper> tableWrap = new list<tableLineWrapper>();
        
		//Traverse through group values and only add values of rows that match to the same forecast Group
		list<string> factMapKeys = new list<string>();
        for(Reports.GroupingValue gv: this.groupingValueList){
            if(gv.getLabel() == forecastGroup){
                //First level grouping key
                string key = gv.getKey() +'!T';
                
                //Get the factDetails with details and place in wrapper
                //factDetails is the summary field of the group, e.g. totl GMV, total New Opportunity Amountd, Total Forecasted Amount and #records
                Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)mainResults.getFactMap().get(key);
                //wrap.add(new reportLineWrapper('forecast',gv.getLabel(),factDetails));
                
                //Check if metaGroupingColumn has anyfurther groupings 
                //The innerGroup is the detail information
                List<Reports.GroupingValue> innerGroup =  gv.getGroupings();           
                if(innerGroup!=null){
                    //Has grouping, add key  
                    for(Reports.GroupingValue g:innerGroup){
                        //Each innerKey represents a level by the owner in the report, e.g. John or Alper
                        string innerKey = g.getKey()+'!T';
                        //Get all rows based on each owner's section and pass it into tableLineWrapper
                        Reports.ReportFactWithDetails innerFactDetails = (Reports.ReportFactWithDetails)mainResults.getFactMap().get(innerKey);

                        //Each section has many rows                
                        for(Reports.ReportDetailRow row :innerFactDetails.getRows()){
                            //Get each column seperately and place them into the corresponding column names
                            list<Reports.ReportDataCell> column = row.getDataCells();
                            tableWrap.add(new tableLineWrapper(column));
                        }                                   
                    }              
                }  
                
                //Set global aggregate
                for(Reports.SummaryValue agg:factDetails.getAggregates()){
                    groupAggregate.add(agg.getLabel());
                }
            }                
        }
        
        return tableWrap;

    }
    
    //The below commented section has been replaced by the new datatable functions that render in pdf
    /*
    private list<reportLineWrapper> getReportWrapperGroup(string forecastGroup){
        list<reportLineWrapper> wrap = new list<reportLineWrapper>();
        
		//Traverse through group values and only add values of rows that match to the same forecast Group
		list<string> factMapKeys = new list<string>();
        for(Reports.GroupingValue gv: this.groupingValueList){
            if(gv.getLabel() == forecastGroup){
                //First level grouping key
                string key = gv.getKey() +'!T';
                
                //Get the factDetails with details and place in wrapper
                //factDetails is the summary field of the group, e.g. totl GMV, total New Opportunity Amountd, Total Forecasted Amount and #records
                Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)mainResults.getFactMap().get(key);
                //wrap.add(new reportLineWrapper('forecast',gv.getLabel(),factDetails));
                
                //Check if metaGroupingColumn has anyfurther groupings 
                //The innerGroup is the detail information
                List<Reports.GroupingValue> innerGroup =  gv.getGroupings();           
                if(innerGroup!=null){
                    //Has grouping, add key  
                    for(Reports.GroupingValue g:innerGroup){
                        //Each innerKey represents a level by the owner in the report, e.g. John or Alper
                        string innerKey = g.getKey()+'!T';
                        //Get all rows based on each owner's section and pass it into tableLineWrapper
                        Reports.ReportFactWithDetails innerFactDetails = (Reports.ReportFactWithDetails)mainResults.getFactMap().get(innerKey);

                        //Send to reportLineWrapper to create custom wrapper to displaying in VF - note this will not work with renderAs PDF due to CS3 - http://salesforce.stackexchange.com/questions/87622/apexrepeat-styling-does-not-work-with-renderas-pdf
                        wrap.add(new reportLineWrapper('owner',gv.getLabel(),innerFactDetails));
                        wrap.add(new reportLineWrapper('detail',gv.getLabel(),innerFactDetails));              
                    }              
                }  
                
                wrap.add(new reportLineWrapper('forecast',gv.getLabel(),factDetails)); 
            }                
        }
        return wrap;       
    }
	    	
    public class reportLineWrapper{
        public string level {get;set;}													
        public string forecastCategory {get;set;}										//Either Solutions, Quick Quote or General Pipeline
        public Reports.ReportFactWithDetails factDetails {get;set;}
        
        public reportLineWrapper(string lv,string forecastG, Reports.ReportFactWithDetails f){
        	this.level = lv;
            this.forecastCategory = forecastG;
            this.factDetails = f;
        }
        
    }
    */    
    
    //Wrapper class mimics the table columns in the standard sales report format and returns into VF to be rendered in dataTable
    public class tableLineWrapper{
        public string acc {get; set;}
        public string opp {get; set;}
        public string nextStep {get; set;}
        public string owner {get; set;}
        public string createdDate {get; set;}
        public string closeDate {get; set;}
        public string stage {get; set;}
        public string age {get; set;}
        public string gmv {get; set;}
        public string newOpp {get; set;}					//New Opportinity Last Week
        public string newOppAmount {get; set;}
        public string forecastedAmount {get; set;}
        public string oppStrategy {get;set;}

        //Rows are passed in from Reports.ReportFactWithDetails - this level is the detail rows
        public tableLineWrapper(list<Reports.ReportDataCell>  column){
            this.acc = (column[0]!=null) ? column[0].getLabel():'';
            this.opp = (column[1]!=null) ? column[1].getLabel():'';
            this.nextStep = (column[2]!=null) ? column[2].getLabel():'';
            this.owner = (column[3]!=null) ? column[3].getLabel():'';
            this.createdDate = (column[4]!=null) ? column[4].getLabel():'';
            this.closeDate = (column[5]!=null) ? column[5].getLabel():'';
            this.stage = (column[6]!=null) ? column[6].getLabel():'';
            this.age = (column[7]!=null) ? column[7].getLabel():'';
            this.gmv = (column[8]!=null) ? column[8].getLabel():'';            
            this.newOpp = (column[9]!=null) ? column[9].getLabel():'';
            this.forecastedAmount = (column[10]!=null) ? column[10].getLabel():''; 
            this.oppStrategy = (column[11]!=null) ? column[11].getLabel():''; 
        }
        
    }
    
}