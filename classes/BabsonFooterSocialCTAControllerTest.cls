@isTest
private class BabsonFooterSocialCTAControllerTest {
    public BabsonFooterSocialCTAControllerTest() {
        
    }

    static testMethod void testSetting() {
        BabsonFooterSocialCTAController socialCTA = new BabsonFooterSocialCTAController();

        system.assert(socialCTA.socialMediaSetting == AlumniCommunity__c.getInstance(Site.GetName()));
    }
}