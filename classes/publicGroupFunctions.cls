/*
 * Written by Joey Ho 05/05/16
 * PublicGroupFunctions purpose is to be a global class accessible by every apex class 
 * Contains functions that relates to the Salesforce public group
*/
Global class publicGroupFunctions {

    //GetUserIdFromGroup taken from https://developer.salesforce.com/forums/?id=906F00000008yBGIAY
    //Retrieves any User Ids from a given Group Id
    //Note this may reach governor limits if group is nested within groups
    Global static Set<id> GetUserIdsFromGroup(Id groupId){
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        
        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :groupId]){
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType)){
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            // Note: there may be a problem with governor limits if this is called too many times
            else if (((String)m.UserOrGroupId).startsWith(groupType)){
                // Call this function again but pass in the group found within this group
                result.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
            }
        }
        
        return result;  
    }
    
}