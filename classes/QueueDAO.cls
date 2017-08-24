public class QueueDAO {
    public static List<Group> getQueueByDeveloperNames(List<String> developerNames) {
        return [SELECT Id FROM Group WHERE DeveloperName = :developerNames AND Type = :Constants.QUEUE];
    }
}