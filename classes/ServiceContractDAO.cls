public class ServiceContractDAO {
	public static List<ServiceContract> getServiceContractByContractNumber(List<String> contractNumbers) {
		return [SELECT Id FROM ServiceContract WHERE ContractNumber IN :contractNumbers];
	}
}