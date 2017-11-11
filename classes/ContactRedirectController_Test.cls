@isTest
private class ContactRedirectController_Test {
	
	@isTest static void communityRedirect() {
		BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();
        Contact existingContact = [Select Id from Contact Where id =: existingPortalUser.contactId Limit 1];
        
        System.runAs(existingPortalUser){
        	ApexPages.StandardController sc = new ApexPages.standardController(existingContact);
        	ContactRedirectController controller = new ContactRedirectController(sc);
        	controller.redirectUser();
		}
	}
}