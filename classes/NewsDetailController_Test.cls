@isTest
private class NewsDetailController_Test {

    User objuser;
    PageReference pageRef;
    NewsDetailController cont; 
    CORECONNECT__CC_Community_Content__c cc;
    
    private void setUp(){
    	
        pageRef = Page.NewsDetail;
        Test.setCurrentPage(pageRef);
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
    	
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
       	
        objUser = objUtil.createUser();
        insert objUser;
    }
    
    @isTest static void test_FreeTextDetail(){
    	
    	BAB_TestUtil objUtil = new BAB_TestUtil();
    	NewsDetailController_Test  tes = new NewsDetailController_Test();
    	
    	Test.startTest();
    	tes.setUp();
    	
    	Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('FreeText').getRecordTypeId();
    	
    	tes.cc = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test', false, false);
    	insert tes.cc; 
    	
    	Attachment objAttachment = objUtil.createAttachment(tes.cc.Id, tes.cc.Name);
       	insert objAttachment;
    	
    	System.runAs(tes.objuser){
    		
    		Id strId = ApexPages.CurrentPage().getparameters().put('Id', tes.cc.Id);
    		
    		tes.cont = new  NewsDetailController(new ApexPages.standardController(tes.cc));
    		
    		System.assert(!String.isEmpty(tes.cont.FreeTextPublishDate));
    		System.assert(tes.cont.GuestProfileName == 'Test');
    	}
    	tes.cc.CORECONNECT__Community_Content_Status__c = 'Created';
    	update tes.cc;
    	tes.cont.goToList();
    }
}