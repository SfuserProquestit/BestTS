public class UserDAO {
	public static List<User> getUsersForProfiles(Set<Id> profiles) {
		return [Select 	Id,
						Email
				From	User
				Where	ProfileId IN :profiles];
	}

	public static List<User> getUsers(Set<Id> userIds){
		return [Select 	Id,
						IsActive
				From	User
				Where	ID IN :userIds];
	}
}