public class NetworkMemberCtrl {
    public NetworkMember netObj{get; set;}
    public boolean followme {get; set;}
    public NetworkMemberCtrl(){
        string userId = UserInfo.getUserId();
        Network AlumniCommunity = [SELECT Id FROM Network WHERE Name ='Alumni'];
        // netList = new List<NetworkMember>(); 
        netobj=[SELECT MemberId,PreferencesDisableAllFeedsEmail,PreferencesDisableBookmarkEmail,
                    PreferencesDisableChangeCommentEmail,PreferencesDisableDirectMessageEmail,
                    PreferencesDisableEndorsementEmail,PreferencesDisableFollowersEmail,
                    PreferencesDisableItemFlaggedEmail,PreferencesDisableLaterCommentEmail,
                    PreferencesDisableLikeEmail,PreferencesDisableMentionsPostEmail,
                    PreferencesDisableMessageEmail,PreferencesDisablePendingReviewEmail,
                    PreferencesDisableProfilePostEmail,PreferencesDisableSharePostEmail,
                    PreferencesDisCommentAfterLikeEmail,PreferencesDisMentionsCommentEmail,
                    PreferencesDisProfPostCommentEmail
                    FROM NetworkMember WHERE MemberId =:userId and NetworkId=:AlumniCommunity.id];
        followme = (netObj.PreferencesDisableFollowersEmail ? false:true);
        
    }
    
    public pageReference save(){
        NetworkMember nmb = [SELECT MemberId,PreferencesDisableAllFeedsEmail,PreferencesDisableBookmarkEmail,
                    PreferencesDisableChangeCommentEmail,PreferencesDisableDirectMessageEmail,
                    PreferencesDisableEndorsementEmail,PreferencesDisableFollowersEmail,
                    PreferencesDisableItemFlaggedEmail,PreferencesDisableLaterCommentEmail,
                    PreferencesDisableLikeEmail,PreferencesDisableMentionsPostEmail,
                    PreferencesDisableMessageEmail,PreferencesDisablePendingReviewEmail,
                    PreferencesDisableProfilePostEmail,PreferencesDisableSharePostEmail,
                    PreferencesDisCommentAfterLikeEmail,PreferencesDisMentionsCommentEmail,
                    PreferencesDisProfPostCommentEmail
                    FROM NetworkMember where Id =: netObj.Id];
        if(followme == true){
            nmb.PreferencesDisableFollowersEmail = false;
        }else{
            nmb.PreferencesDisableFollowersEmail = true;
        }
        update nmb;
        return null;
    }
}