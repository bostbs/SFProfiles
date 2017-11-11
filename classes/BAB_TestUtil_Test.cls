@isTest
private class BAB_TestUtil_Test {
	
	private static testMethod void test_API_SystemUtils() {

		BAB_TestUtil objUtil = new BAB_TestUtil();

		Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('FreeText').getRecordTypeId();
		List<CORECONNECT__CC_Community_Content__c> lstComContentToInsert = new List<CORECONNECT__CC_Community_Content__c>();
		CORECONNECT__CC_Community_Content__c objCommunityContent1 = objUtil.createCommunityContent(RecordTypeIdFreeText, 'TestJob', true, false);
		lstComContentToInsert.add(objCommunityContent1);
		insert lstComContentToInsert;

		User objUser = objUtil.createUser();
        insert objUser; 

		

		objUtil.createCommunityContent(RecordTypeIdFreeText, 'TestJob', true, false);
		objUtil.createCommunityContent2(RecordTypeIdFreeText, 'TestJob', true, false);
		objUtil.createAlumniCommunity();
		objUtil.createAlumniL2Settings();
		objUtil.createCoreconnectSystemSettings();
		objUtil.createUser();
		objUtil.createAlumniComPersonalization();
		objUtil.createAttachment(objCommunityContent1.Id, objCommunityContent1.Name);
		objUtil.createEntitySubscription(objCommunityContent1.Id, objUser.Id);
		objUtil.createSSFCommunityUser();   //createCommunityUser();
		//objUtil.createAffiliation();
		//objUtil.createAddress();
		objUtil.createSSFCommunityUser();
		objUtil.createCommunityContent(5, RecordTypeIdFreeText, 'testing here');
		objUtil.createContentVersionFiles(20, CORECONNECT.CC_CommunityConstants.NETWORK_ID);
		objUtil.createGroups(20, CORECONNECT.CC_CommunityConstants.NETWORK_ID);
		objUtil.createCommunityUsersWithAffiliations(5);
		objUtil.createAddress([SELECT ID FROM Account LIMIT 1].Id, false,'Home', 'Home 1');

	}

	/* 
	@isTest static void test_method_one() {
		// Implement test code
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	} 
	*/
}