@isTest
public with sharing class BabsonMegaNavController_Test {
    private static void setUpData() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();

		/* L2 Settings to power most of the navigation */
        AlumniCommunityL2Pages__c objAlumniSettings = objUtil.createAlumniL2Settings(); 
		insert objAlumniSettings; 
		/* Header Footer settings for a few additional links */
		CORECONNECT__CC_Header_Footer_Settings__c objHeaderFooterSettings = new CORECONNECT__CC_Header_Footer_Settings__c(Name = 'Alumni',CORECONNECT__Header_Link_1_Label__c = 'Label',CORECONNECT__Header_Link_1_URL__c = 'URL');
		insert objHeaderFooterSettings; 
    }
	
	static testMethod void myUnitTest() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson); /* */
        
        BabsonMegaNavController controller = new BabsonMegaNavController();
        System.assertEquals('Label', controller.headerFooterSetting.CORECONNECT__Header_Link_1_Label__c);
        System.assertEquals('URL', controller.headerFooterSetting.CORECONNECT__Header_Link_1_URL__c);
	}
}