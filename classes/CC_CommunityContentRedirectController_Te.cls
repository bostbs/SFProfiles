@isTest
private class CC_CommunityContentRedirectController_Te {
	
    PageReference pageRef;
    CC_CommunityContentRedirectController controller; 
    CORECONNECT__CC_Community_Content__c cc;

    private void setUp(){
        pageRef = Page.CC_CommunityContentRedirect;
        Test.setCurrentPage(pageRef);
        
        // pass the record to constructor
        ApexPages.CurrentPage().getparameters().put('id', cc.id);
        controller = new CC_CommunityContentRedirectController(new ApexPages.standardController(cc));
        
    }	
		
	@isTest(SeeAllData=true) static void test_NewsDetail() {
        CC_CommunityContentRedirectController_Te  tes = new CC_CommunityContentRedirectController_Te();
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();

        Id recordTypeIdNews = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('FreeText').getRecordTypeId();
        tes.cc = objUtil.createCommunityContent(recordTypeIdNews, 'Test', true, false);
        insert tes.cc;
        System.runAs(existingPortalUser){
            tes.setUp();
            System.assertEquals(Page.NewsDetail.getUrl() + '?id=' + tes.cc.Id, tes.controller.redirectUser().getURL());
        }
    }

    @isTest(SeeAllData=true) static void test_EventDetail() {
        CC_CommunityContentRedirectController_Te  tes = new CC_CommunityContentRedirectController_Te();
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();

        Id recordTypeIdEvent = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('ScheduledContent').getRecordTypeId();
        tes.cc = objUtil.createCommunityContent(recordTypeIdEvent, 'Test', true, false);
        insert tes.cc;
        System.runAs(existingPortalUser){
            tes.setUp();
            System.assertEquals(Page.EventDetail.getUrl() + '?id=' + tes.cc.Id, tes.controller.redirectUser().getURL());
        }
    }

    @isTest(SeeAllData=true) static void test_VentureDetail() {
        CC_CommunityContentRedirectController_Te  tes = new CC_CommunityContentRedirectController_Te();
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();

        Id recordTypeIdVenture = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Venture').getRecordTypeId();
        tes.cc = objUtil.createCommunityContent(recordTypeIdVenture, 'Test', true, false);
        insert tes.cc;
        System.runAs(existingPortalUser){
            tes.setUp();
            System.assertEquals(Page.VentureDetail.getUrl() + '?id=' + tes.cc.Id, tes.controller.redirectUser().getURL());
        }
    }

    @isTest(SeeAllData=true) static void test_JobDetail() {
        CC_CommunityContentRedirectController_Te  tes = new CC_CommunityContentRedirectController_Te();
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();

        Id recordTypeIdJob = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Job').getRecordTypeId();
        tes.cc = objUtil.createCommunityContent(recordTypeIdJob, 'Test', true, false);
        insert tes.cc;
        System.runAs(existingPortalUser){
            tes.setUp();
            System.assertEquals(Page.JobDetail.getUrl() + '?id=' + tes.cc.Id, tes.controller.redirectUser().getURL());

        }
    }

    @isTest(SeeAllData=true) static void test_BusinessDetail() {
        CC_CommunityContentRedirectController_Te  tes = new CC_CommunityContentRedirectController_Te();
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();

        Id recordTypeIdBusiness = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        tes.cc = objUtil.createCommunityContent(recordTypeIdBusiness, 'Test', true, false);
        insert tes.cc;
        System.runAs(existingPortalUser){
            tes.setUp();
            System.assertEquals(Page.BusinessDetail.getUrl() + '?id=' + tes.cc.Id, tes.controller.redirectUser().getURL());

        }
    }

    //will need to be updated or removed should Volunteer Opportunity be added to the 
    //list of handled record types in CC_CommunityContentRedirectController
    @isTest(SeeAllData=true) static void test_UnhanledRecordType() {
        CC_CommunityContentRedirectController_Te  tes = new CC_CommunityContentRedirectController_Te();
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User existingPortalUser = objUtil.createCommunityUser();

        Id recordTypeIdVolunteer = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Volunteer Opportunity').getRecordTypeId();
        tes.cc = objUtil.createCommunityContent(recordTypeIdVolunteer, 'Test', true, false);
        insert tes.cc;
        System.runAs(existingPortalUser){
            tes.setUp();
            System.assert(tes.controller.redirectUser() == null);

        }
    }
}