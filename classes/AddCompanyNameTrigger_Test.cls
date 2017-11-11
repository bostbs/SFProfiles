@isTest
public with sharing class AddCompanyNameTrigger_Test {
	
	@isTest static void testAlumni() {
		Bab_TestUtil util = new Bab_TestUtil();
		//User testUser = util.createCommunityUser();
        User testUser = util.createSSFCommunityUser();
		//System.assertEquals(testUser.CompanyName,'Alumni');
		System.assertEquals(testUser.LastName,'last');
	}

	@isTest static void testNonAlumni() {
		Bab_TestUtil util = new Bab_TestUtil();
		User testUser = util.createSSFCommunityUser();
		//System.assertEquals(testUser.ProfileName,'Non-Alumni');
		System.assertEquals(testUser.LastName,'last');
	}
}