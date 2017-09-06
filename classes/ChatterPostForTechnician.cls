public class ChatterPostForTechnician {
    @InvocableMethod(label='Create Chatter Post for the Service Resource for Dispatch' description='Returns the list of work orders.')
	public static List<Id> createChatterPostForTechnician(List<Id> ids) {
        CommunityNetworkId__c  communityNetwork = CommunityNetworkId__c.getOrgDefaults();
        List<Id> postIds = new List<Id>();
        if(communityNetwork != null){
            for(Id userId : ids){
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    
                mentionSegmentInput.id = userId;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
    
                textSegmentInput.text = ' '+Label.Work_Order_Dispatched;
                messageBodyInput.messageSegments.add(textSegmentInput);
    
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = 'me';
                feedItemInput.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;
                
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(communityNetwork.Network_Id__c , feedItemInput);     
                postIds.add(feedElement.Id);
            }
        }
		
        return postIds;
	}
}