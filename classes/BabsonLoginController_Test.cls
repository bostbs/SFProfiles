@isTest
private class BabsonLoginController_Test {

	private static void setUpData() {

		CORECONNECT__CC_System_Settings__c objSystemSettings = new CORECONNECT__CC_System_Settings__c(  
			Name = 'Test Name');

        insert objSystemSettings;
        
        AlumniCommunity__c alumniCustomSetting = new AlumniCommunity__c(Name = 'Test Alumni CS');
        insert alumniCustomSetting;
        
	}
	
	static testMethod void testLogin() {

		setUpData();
		BabsonLoginController babsonCont = new BabsonLoginController();
		babsonCont.username = 'babson-Test+1@test.com';
		babsonCont.login();
		   
	}
}