@isTest
private class BabsonHeaderComponentController_Test {
    
    User testUser;

    private void setUp(){
        BAB_TestUtil objTestUtil = new BAB_TestUtil();
        User testUser = objTestUtil.createCommunityUser();
    }

    /*@IsTest(SeeAllData=true)
    static void testGetUserPhotos() {
        BAB_TestUtil objTestUtil = new BAB_TestUtil();
        User testUser = objTestUtil.createCommunityUser();
         CORECONNECT.CC_CommunityTestUtil.createCS_CC_System_SettingsAutomatedFiltering();
         System.runAs(testUser){
            BabsonHeaderComponentController hc = new BabsonHeaderComponentController();
            // default smallPhotoUrl should be there - but not according to ""
            System.assert(hc.UserPhotos.smallPhotoUrl ==null);

         }
    }*/


    @isTest static void testFields() {
        BAB_TestUtil objUtil = new BAB_TestUtil();
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;

        CORECONNECT__CC_Header_Footer_Settings__c footerSettings = new CORECONNECT__CC_Header_Footer_Settings__c(   Name = 'Alumni',
                                                          CORECONNECT__Header_Logo_Image_URL__c = 'Test',
                                                          CORECONNECT__Header_Link_1_Label__c = 'Test',
                                                          CORECONNECT__Header_Link_1_URL__c = 'Test',
                                                          CORECONNECT__Header_Link_1_Icon_Class__c = 'Test',
                                                          CORECONNECT__Header_Link_1_New_Page__c = false,
                                                          CORECONNECT__Header_Link_2_URL__c = 'Test',
                                                          CORECONNECT__Header_Link_2_Label__c = 'Test',
                                                          CORECONNECT__Header_Link_2_Icon_Class__c = 'Test',
                                                          CORECONNECT__Header_Link_2_New_Page__c = false
                                                          );
        insert footerSettings;
        BabsonHeaderComponentController cont = new BabsonHeaderComponentController();
        BabsonHeaderComponentController.saveUserLoginHistory('www.google.com');
        User existingPortalUser = objUtil.createCommunityUser();
        cont.contactid = [Select Id from Contact Where id =: existingPortalUser.contactId Limit 1].id;
        
        cont.updateContactTermTimeStamp();

        String defaultValue = 'Test';
        cont.saveLastUpdateOnUserLoginHistory();
        System.assertEquals(defaultValue, cont.LoginURL);
        System.assertEquals(defaultValue, cont.LogoutURL);
        System.assertEquals(defaultValue, cont.GuestProfileName);
        System.assertEquals(defaultValue, cont.HeaderLogoImageURL);
        System.assertEquals(false, cont.ShowGettingStartedLink);
        System.assertEquals(defaultValue, cont.Link1Label);
        System.assertEquals(defaultValue, cont.Link1URL);
        System.assertEquals(defaultValue, cont.Link1IconClass);
        System.assertEquals(false, cont.Link1NewPage);
        System.assertEquals(defaultValue, cont.Link2Label);
        System.assertEquals(defaultValue, cont.Link2URL);
        System.assertEquals(defaultValue, cont.Link2IconClass);
        System.assertEquals(false, cont.Link2NewPage);
    }

    @isTest static void testEmptyFields() {
        BabsonHeaderComponentController cont = new BabsonHeaderComponentController();
        String defaultValue = 'default';

        System.assertEquals(null, cont.SearchString);
        System.assertEquals(defaultValue, cont.LoginURL);
        System.assertEquals(defaultValue, cont.LogoutURL);
        System.assertEquals(defaultValue, cont.GuestProfileName);
        System.assertEquals(defaultValue, cont.HeaderLogoImageURL);
        System.assertEquals(false, cont.ShowGettingStartedLink);
        System.assertEquals('', cont.Link1Label);
        System.assertEquals('', cont.Link1URL);
        System.assertEquals('', cont.Link1IconClass);
        System.assertEquals(false, cont.Link1NewPage);
        System.assertEquals('', cont.Link2Label);
        System.assertEquals('', cont.Link2URL);
        System.assertEquals('', cont.Link2IconClass);
        System.assertEquals(false, cont.Link2NewPage);
        System.assertEquals('', cont.HeaderCSSBrandingResourceName);
        System.assertEquals('', cont.HeaderCSSBrandingPageName);
    }

    @isTest static void testContact(){
        BAB_TestUtil objTestUtil = new BAB_TestUtil();
        User testUser = objTestUtil.createCommunityUser();
        System.runAs(testUser){
            BabsonHeaderComponentController hc = new BabsonHeaderComponentController();
            System.assertEquals('TestFirstName',hc.contact.FirstName); // 'TestFirstName' - why is this coming back as null?
        }
    }
    
}