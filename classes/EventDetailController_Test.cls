@isTest
private class EventDetailController_Test {
	
	User objUser;
    PageReference pageRef;
    EventDetailController cont; 
    CORECONNECT__CC_Community_Content__c cc;
    
    private void setUp(){
    	
        pageRef = Page.EventDetail;
        Test.setCurrentPage(pageRef);
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
    	
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
       
        objUser = objUtil.createUser();
        insert objUser;
        
    }
    
    @isTest static void test_ScheduledContentDetail(){
    	
    	BAB_TestUtil objUtil = new BAB_TestUtil();
    	EventDetailController_Test  tes = new EventDetailController_Test();
    	
    	Test.startTest();
    	tes.setUp();
    	
    	Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('ScheduledContent').getRecordTypeId();
    	
    	tes.cc = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test', false, false);
    	insert tes.cc; 
    	
    	Attachment objAttachment = objUtil.createAttachment(tes.cc.Id, tes.cc.Name);
       	insert objAttachment;
    	
    	System.runAs(tes.objuser){
    		
    		Id strId = ApexPages.CurrentPage().getparameters().put('Id', tes.cc.Id);
    		
    		tes.cont = new  EventDetailController(new ApexPages.standardController(tes.cc));
    		
    		// format will change for now this must return values
            System.assert(!String.isEmpty(tes.cont.ScheduledContentstartMonth));
            System.assert(!String.isEmpty(tes.cont.ScheduledContentstartDate));
            System.assert(!String.isEmpty(tes.cont.ScheduledContentstartDayInMonth));
            System.assert(!String.isEmpty(tes.cont.ScheduledContentEndMonth));
            System.assert(!String.isEmpty(tes.cont.ScheduledContentEndDate));
            System.assert(!String.isEmpty(tes.cont.ScheduledContentStartDateDiffDay));
			System.assert(!String.isEmpty(tes.cont.ScheduledContentEndDateDiffDay));
			System.assert(!String.isEmpty(tes.cont.ScheduledContentStartTime));
			System.assert(!String.isEmpty(tes.cont.ScheduledContentEndTime));
			System.assert(tes.cont.ScheduledContentDaysBetweenStartEnd != null);
			System.assert(!String.isEmpty(tes.cont.ScheduledContentEndDayInMonth));
			System.assert(!String.isEmpty(tes.cont.ScheduledContentStartMonthAndYear));
			System.assert(!String.isEmpty(tes.cont.ScheduledContentEndMonthAndYear));
			
			System.assert(tes.cont.GuestProfileName == 'Test');
			
			tes.cont.SaveCurrentToCookie();
			System.assert(String.isEmpty(tes.cont.HeaderLabel));
    	}
    }
}