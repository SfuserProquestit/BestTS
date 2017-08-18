public class SLADAO{
    public static List<SLA__c> getSLAByServiceContractId(Set<Id> serviceContractIds){
        return [SELECT Id 
                FROM SLA__c 
                WHERE Service_Contract__c IN :serviceContractIds
                ORDER BY CreatedDate ASC];
    }
}