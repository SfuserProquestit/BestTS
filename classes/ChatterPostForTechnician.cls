public class ChatterPostForTechnician {
    @InvocableMethod(label='Create Chatter Post for the Service Resource for Dispatch' description='Returns the list of work orders.')
	public static List<Id> createChatterPostForTechnician(List<ChatterPost> chatterPosts) {
        CommunityNetworkId__c  communityNetwork = CommunityNetworkId__c.getOrgDefaults();
        List<Id> postIds = new List<Id>();
        if(communityNetwork != null){
            for(ChatterPost chatPost : chatterPosts){
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    
                mentionSegmentInput.id = chatPost.resourceId;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                textSegmentInput.text = ' '+Label.Work_Order_Dispatched;
                messageBodyInput.messageSegments.add(textSegmentInput);
    
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = chatPost.woId;
                feedItemInput.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;
                
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(communityNetwork.Network_Id__c , feedItemInput);     
                postIds.add(feedElement.Id);
            }
        }
		
        return postIds;
	}
    
    public class ChatterPost{
        @InvocableVariable(label='Work Order Number' required=true) 
        public String workOrderNumber;
        @InvocableVariable(label='Service Resource Id' required=true) 
        public Id resourceId;
        @InvocableVariable(label='Work Order Id' required=true)
        public Id woId;
    }
    
}