@isTest
private class CC_CommunityContentWrapper_test {

	
    static testMethod void testCC_communityContent(){
        
        CC_CommunityContentWrapper objCommunityContent = new CC_CommunityContentWrapper();
        objCommunityContent.CC = new CORECONNECT__CC_Community_Content__c(CORECONNECT__End_Date__c = null,
                                                                          CORECONNECT__Start_Date__c = null
                                                                           );
                                                                           
        System.assert(String.isBlank(objCommunityContent.DayOfWeek));
        System.assert(String.isBlank(objCommunityContent.EndDayOfWeek));
        System.assert(String.isBlank(objCommunityContent.Month));
        System.assert(String.isBlank(objCommunityContent.EndMonth));
        System.assert(String.isBlank(objCommunityContent.DayInMonth));
        System.assert(String.isBlank(objCommunityContent.EndDayInMonth));
        System.assert(String.isBlank(objCommunityContent.StartAndEndTime));
        System.assert(String.isBlank(objCommunityContent.StartAndEndTimeDiffDay));
        System.assert(String.isBlank(objCommunityContent.StartTime));
        System.assert(String.isBlank(objCommunityContent.EndTime));
        System.assert(String.isBlank(objCommunityContent.StartDateDiffDay));
        System.assert(String.isBlank(objCommunityContent.EndDateDiffDay));
        System.assert(String.isBlank(objCommunityContent.MonthAndYear));
        System.assert(String.isBlank(objCommunityContent.EndMonthAndYear));
        System.assertEquals(null,objCommunityContent.MonthValue);
        System.assertEquals(0,objCommunityContent.DaysBetweenStartEnd);
        System.assertEquals(null,objCommunityContent.CollabGroup);
        System.assertEquals(null,objCommunityContent.cg);
        System.assertEquals(null,objCommunityContent.customGroupId);
        System.assertEquals(null,objCommunityContent.ChatterFile);
        
        objCommunityContent.strFeedElementBody = 'test';
        objCommunityContent.strFeedElementParentId = 'test';
        objCommunityContent.StrFeedCommentBody = 'test';
        objCommunityContent.CCType = 'Freetext';
        objCommunityContent.followed = true;
        objCommunityContent.MyGroupRole = 'test';
        objCommunityContent.FeaturedMemberType = 'test';
        objCommunityContent.Mem = [SELECT id FROM User WHERE id =: UserInfo.getUserId()];
        objCommunityContent.u = objCommunityContent.Mem;
        objCommunityContent.CC = new CORECONNECT__CC_Community_Content__c(CORECONNECT__End_Date__c = Date.today().addDays(3),
                                                                          CORECONNECT__Start_Date__c = Date.today(),
                                                                          CORECONNECT__FreeText_Desired_Publish_Date__c = Date.today() );
        
        System.assertNotEquals(null,objCommunityContent.DayOfWeek);
        System.assertNotEquals(null,objCommunityContent.EndDayOfWeek);
        System.assertNotEquals(null,objCommunityContent.Month);
        System.assertNotEquals(null,objCommunityContent.EndMonth);
        System.assertNotEquals(null,objCommunityContent.DayInMonth);
        System.assertNotEquals(null,objCommunityContent.EndDayInMonth);
        System.assertNotEquals(null,objCommunityContent.StartAndEndTime);
        System.assertNotEquals(null,objCommunityContent.StartAndEndTimeDiffDay);
        System.assertNotEquals(null,objCommunityContent.StartTime);
        System.assertNotEquals(null,objCommunityContent.EndTime);
        System.assertNotEquals(null,objCommunityContent.StartDateDiffDay);
        System.assertNotEquals(null,objCommunityContent.EndDateDiffDay);
        System.assertNotEquals(null,objCommunityContent.MonthAndYear);
        System.assertNotEquals(null,objCommunityContent.EndMonthAndYear);
        System.assertNotEquals(0,objCommunityContent.MonthValue);
        System.assertNotEquals(0,objCommunityContent.DaysBetweenStartEnd);
        System.assertNotEquals(null,objCommunityContent.FreeTextDate);
        System.assertNotEquals(null,objCommunityContent.MoreFreeTextMonthString);
        System.assertNotEquals(0,objCommunityContent.MoreFreeTextMonthValue);
        
        System.assertNotEquals(null,objCommunityContent.CCType);
        System.assertEquals(true,objCommunityContent.followed);
        System.assertNotEquals(null,objCommunityContent.MyGroupRole);
        System.assertNotEquals(null,objCommunityContent.FeaturedMemberType);
        System.assertNotEquals(null,objCommunityContent.Mem);
        System.assertNotEquals(null,objCommunityContent.strFeedElementBody);
        System.assertNotEquals(null,objCommunityContent.strFeedElementParentId);
        System.assertNotEquals(null,objCommunityContent.StrFeedCommentBody);
        
    }

}