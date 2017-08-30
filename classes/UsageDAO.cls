public class UsageDAO {

    //public static List<Usage_FSL__c> getUsagesById(Set<Id> usageIds) {
    //    return [SELECT  Service__c FROM    Usage_FSL__c
    //             WHERE   Id IN : usageIds];
    //}

    //public static List<AggregateResult> getUsagesAggregateResult(Set<Id> usageIds) {
    //    return [SELECT  Service__c , 
    //                     SUM(Total_Engineering_Cost__c) totalenggcost, 
    //                     SUM(Total_Engineering_Revenue__c) totalenggrevenue, 
    //                     SUM(Total_Pass_Through_Cost__c) totalpassthrcost, 
    //                     SUM(Total_Pass_Through_Revenue__c) totalpassthrrevenue 
    //            FROM Usage_FSL__c
    //            WHERE Id IN : usageIds
    //            GROUP BY ROLLUP(Service__c)];
    //}

    //public static Map<Id, Usage_FSL__c> getUsageMap(List<Id> serviceIds, Set<Id> usageIds) {

    //    return new Map<Id, Usage_FSL__c>([SELECT Id  FROM Usage_FSL__c 
    //                                       WHERE Service__c IN : serviceIds AND 
    //                                             Id NOT IN: usageIds]);
    //}

    //public static Map<Id, Usage_FSL__c> getUsageMap(List<Id> serviceIds) {

    //    return new Map<Id, Usage_FSL__c>([SELECT Id FROM Usage_FSL__c 
    //                                      WHERE Service__c IN : serviceIds]);
    //}
    public static List<Usage_FSL__c> getUsagesById(Set<Id> usageIds) {
        return [SELECT Service_Work_Order__c 
                FROM   Usage_FSL__c
                WHERE  Id IN : usageIds];
    }

    public static List<AggregateResult> getUsagesAggregateResult(Set<Id> usageIds) {
        return [SELECT  Service_Work_Order__c , 
                         SUM(Total_Engineering_Cost__c) totalenggcost, 
                         SUM(Total_Engineering_Revenue__c) totalenggrevenue, 
                         SUM(Total_Pass_Through_Cost__c) totalpassthrcost, 
                         SUM(Total_Pass_Through_Revenue__c) totalpassthrrevenue 
                FROM Usage_FSL__c
                WHERE Id IN : usageIds
                GROUP BY ROLLUP(Service_Work_Order__c)];
    }

    public static Map<Id, Usage_FSL__c> getUsageMap(Set<Id> woServiceIds, Set<Id> usageIds) {

        return new Map<Id, Usage_FSL__c>([  SELECT Id,
                                                    Service_Work_Order__c
                                            FROM Usage_FSL__c 
                                            WHERE Service_Work_Order__c IN : woServiceIds AND 
                                                 Id NOT IN: usageIds]);
    }

    public static Map<Id, Usage_FSL__c> getUsageMap(Set<Id> woServiceIds) {

        return new Map<Id, Usage_FSL__c>([  SELECT  Id,
                                                    Service_Work_Order__c
                                            FROM Usage_FSL__c 
                                            WHERE Service_Work_Order__c IN : woServiceIds]);
    }
}