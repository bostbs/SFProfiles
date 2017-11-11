/**
 * An apex class that keeps updates of a portal user in sync with its corresponding contact.
   Guest users are never able to access this page.
 */
@IsTest public with sharing class MyProfilePageControllerTest {
   
    
    @IsTest(SeeAllData=true) static void testSave() {
        // Modify the test to query for a portal user that exists in your org
        List<User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='CustomerSuccess'];

        if (existingPortalUsers.isEmpty()) {
            User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];
            Contact c = new Contact(lastname='test');
            
            MyProfilePageController controller = new MyProfilePageController();
            controller.setup();
            controller.fetch_Contribution_User();
            controller.redirectToHomePage();
            System.assertEquals(currentUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            System.assert(controller.getIsEdit() == false, 'isEdit should default to false');
            controller.edit();
            System.assert(controller.getIsEdit() == true);
            controller.cancel();
            System.assert(controller.getIsEdit() == false);
            //controller.save();
            System.assert(Page.ChangePassword.getUrl().equals(controller.changePassword().getUrl()));
        } 
        
        //community user
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();
        String randFax = Math.rint(Math.random() * 1000) + '5551234';
        
        existingPortalUser = [SELECT contact.AccountId FROM User Where id=: existingPortalUser.Id];
        objUtil.createAddress(existingPortalUser.contact.AccountId, false,'Home', 'Home 1');
        objUtil.createAddress(existingPortalUser.contact.AccountId, false,'Seasonal', 'Home 2');
        objUtil.createAddress(existingPortalUser.contact.AccountId, false,'Seasonal', 'Home 3');
        objUtil.createAddress(existingPortalUser.contact.AccountId, false,'Seasonal', 'Home 4');
            
        system.debug('here'+existingPortalUser);

        System.runAs(existingPortalUser) {
            
            MyProfilePageController controller = new MyProfilePageController();
            controller.setup();
            
            System.assert(controller.getIsEdit() == false, 'isEdit should default to false');
            controller.edit();
            System.assert(controller.getIsEdit() == true);
            
            //homeAddress1,2,3,4
            controller.homeAddress1.Mailing_Country__c = 'CANADA';
            controller.homeAddress1.hed__MailingCity__c = 'Ontario';
            controller.homeAddress1.hed__MailingStreet__c = '123 Fake St';
            controller.homeAddress2.Mailing_Country__c = 'CANADA';
            controller.homeAddress3.Mailing_Country__c = 'CANADA';
            controller.homeAddress4.Mailing_Country__c = 'CANADA';
            
            controller.save();
            
           // System.assert(controller.getIsEdit() == false);
            controller = new MyProfilePageController();
            controller.setup();
        }
    }
    
    @IsTest(SeeAllData=true) static void test_SSF_user() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User objSSFUser = objUtil.createSSFCommunityUser();
        
        System.runAs(objSSFUser){
            
            
            Test.setCurrentPageReference(new PageReference('Page.myProfilePage'));
            System.currentPageReference().getParameters().put('userId', objSSFUser.Id);

            MyProfilePageController controller = new MyProfilePageController();
           // system.assertEquals(controller.redirectToHomePage().getUrl(),'/apex/babsonhome');
        }
    }
    
     @IsTest(SeeAllData=true) static void test_invalid_user() {
        
            //for blank user id
            Test.setCurrentPageReference(new PageReference('Page.myProfilePage'));
            System.currentPageReference().getParameters().put('userId', '');
            MyProfilePageController controller1 = new MyProfilePageController();
            controller1.setup();
            
            //for invalid user id
            System.currentPageReference().getParameters().put('userId', 'test');
            controller1 = new MyProfilePageController();
            controller1.getUser();
    }

    
    @isTest(SeeAllData=true) static void test_save_method(){
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();
        
        System.runAs(existingPortalUser){
         
            MyProfilePageController controller = new MyProfilePageController();
            controller.setup();
            
            //homeAddress1,2,3,4
            controller.homeAddress1.Mailing_Country__c = 'UNITED STATES';
            controller.homeAddress1.hed__MailingPostalCode__c = '12345'; 
            controller.homeAddress2.Mailing_Country__c = 'UNITED STATES';
            controller.homeAddress2.hed__MailingPostalCode__c = '12345'; 
            controller.homeAddress3.Mailing_Country__c = 'UNITED STATES';
            controller.homeAddress3.hed__MailingPostalCode__c = '12345'; 
            controller.homeAddress4.Mailing_Country__c = 'UNITED STATES';
            controller.homeAddress4.hed__MailingPostalCode__c = '12345'; 
            
            controller.save();
        }
    }

     @isTest(SeeAllData=true) static void testInvalidZips(){
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();
        
        System.runAs(existingPortalUser){
         
            MyProfilePageController controller = new MyProfilePageController();
            controller.setup();
            
            //homeAddress1,2,3,4
            controller.homeAddress1.Mailing_Country__c = 'UNITED STATES';
            controller.homeAddress1.hed__MailingPostalCode__c = '123451'; 
            controller.homeAddress2.Mailing_Country__c = 'UNITED STATES';
            controller.homeAddress2.hed__MailingPostalCode__c = '123451';
            controller.homeAddress3.Mailing_Country__c = 'UNITED STATES';
            controller.homeAddress3.hed__MailingPostalCode__c = '123451';
            controller.homeAddress4.Mailing_Country__c = 'UNITED STATES';
            controller.homeAddress4.hed__MailingPostalCode__c = '123451';
            
            controller.save();
        }
    }

    @isTest(SeeAllData=true) static void testMissingData(){
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();
        
        System.runAs(existingPortalUser){
         
            MyProfilePageController controller = new MyProfilePageController();
            controller.setup();
            
            controller.homeAddress1.Mailing_Country__c = '';
            controller.homeAddress1.hed__MailingCity__c = ''; 
            controller.homeAddress1.hed__MailingCity__c = ''; 
            controller.homeAddress1.hed__MailingStreet__c = ''; 
            controller.user.contact.Preferred_Email__c = '';
            controller.save();
        }
    }

     @isTest(SeeAllData=true) static void testInvalidEmail(){
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();
        
        System.runAs(existingPortalUser){
         
            MyProfilePageController controller = new MyProfilePageController();
            controller.setup();
            
            controller.user.contact.Preferred_Email__c = 'bademail';
            controller.save();
        }
    }
}