public class classfortesting {
public void Fortesting()
    {
          
          NetworkMember[] nwlist=[SELECT ID, MemberId, SystemModstamp, PreferencesDisableAllFeedsEmail, PreferencesDisableFollowersEmail,PreferencesDisableBookmarkEmail, PreferencesDisableChangeCommentEmail, 
          PreferencesDisableDirectMessageEmail, PreferencesDisableEndorsementEmail,  PreferencesDisableItemFlaggedEmail, PreferencesDisableLaterCommentEmail, PreferencesDisableLikeEmail,
          PreferencesDisableMentionsPostEmail, PreferencesDisableMessageEmail, PreferencesDisablePendingReviewEmail, PreferencesDisableProfilePostEmail, 
          PreferencesDisableSharePostEmail, PreferencesDisCommentAfterLikeEmail, PreferencesDisMentionsCommentEmail FROM NetworkMember Where memberid = '005290000013uDGAAY'];
           for (NetworkMember nw :nwlist)
            {
		      nw.PreferencesDisableAllFeedsEmail =true;
                update nw;
				
            }

    
    }
    
}