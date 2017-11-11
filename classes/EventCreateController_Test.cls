@isTest
private class EventCreateController_Test {

    User objUser;
    PageReference pageRef;
    EventCreateController objEventsController;
    
    private void setUp(){
    	
    	BAB_TestUtil objUtil = new BAB_TestUtil();
    	
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        pageRef = Page.EventCreate;
        Test.setCurrentPage(pageRef);
        
        objEventsController = new EventCreateController();
    }
    
    /**
	 *  Test required fields validate 
	 */
	     
     @isTest static void test_validateForScheduledContent() {
     	
     	BAB_TestUtil objUtil = new BAB_TestUtil();
     	
        EventCreateController_Test tes = new EventCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
        	
        	tes.setUp();
            // try create without enter any data to see through the error
            tes.objEventsController.createScheduledContent();
            
            List<ApexPages.Message> erroMessages = ApexPages.getMessages();
            // we have 9 required fields
            System.assertEquals(13, erroMessages.size());
     	}
	}
	
	@isTest static void test_createScheduledContent() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		EventCreateController_Test tes = new EventCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objEventsController.CC.Name = 'UnitTest Test Data ScheduledContent';
			tes.objEventsController.CC.CORECONNECT__Short_Description__c = 'Test ScheduledContent';
			tes.objEventsController.CC.CORECONNECT__Description__c = 'Description';
			tes.objEventsController.CC.CORECONNECT__Classification1__c = 'All';
			tes.objEventsController.CC.CORECONNECT__Classification2__c  = 'Arts';
			tes.objEventsController.CC.Source__c  = 'Blogs';
			tes.objEventsController.CC.Topic__c  = 'Arts';
			tes.objEventsController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
			tes.objEventsController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
			tes.objEventsController.CC.CORECONNECT__Start_Date__c  = date.today();
			tes.objEventsController.CC.CORECONNECT__End_Date__c  = date.today()+1;
			tes.objEventsController.CC.CORECONNECT__Location__c  = 'Loc';
			tes.objEventsController.CC.CORECONNECT__Location_Street_1__c  = 'Loc Street1';
			tes.objEventsController.CC.CORECONNECT__Location_City__c  = 'Loc City 1';
			tes.objEventsController.CC.CORECONNECT__Location_State_Province__c  = 'Loc State 1';
			tes.objEventsController.CC.CORECONNECT__Location_Postal_Code__c  = 'Loc Postal 1';
			tes.objEventsController.CC.CORECONNECT__Location_Country__c  = 'Loc Country 1';
			tes.objEventsController.att.Name = 'attachment';
            tes.objEventsController.att.description = 'desc';
            tes.objEventsController.att.Body = Blob.valueOf('test body');
            
            PageReference pr = tes.objEventsController.createScheduledContent();
            
            List<CORECONNECT__CC_Community_Content__c> lstComContent = [	select 	Id,CORECONNECT__Short_Description__c 
            																from 	CORECONNECT__CC_Community_Content__c 
                                                          					where 	Name = 'UnitTest Test Data ScheduledContent' 
                                                          					and 	CORECONNECT__Community_Content_Status__c = 'Approved'];
            
            System.assertEquals('Test ScheduledContent',lstComContent[0].CORECONNECT__Short_Description__c);
           	
           	tes.objEventsController.cancelScheduledContent();
           	
           	System.assert(tes.objEventsController.CC.Name == null);
		}
	}
	
	@isTest static void test_showErrorMsgForWrongDate1() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		EventCreateController_Test tes = new EventCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objEventsController.CC.Name = 'UnitTest Test Data ScheduledContent';
			tes.objEventsController.CC.CORECONNECT__Short_Description__c = 'Test ScheduledContent';
			tes.objEventsController.CC.CORECONNECT__Description__c = 'Description';
			tes.objEventsController.CC.CORECONNECT__Classification1__c = 'All';
			tes.objEventsController.CC.CORECONNECT__Classification2__c  = 'Arts';
			tes.objEventsController.CC.Source__c  = 'Blogs';
			tes.objEventsController.CC.Topic__c  = 'Arts';
			tes.objEventsController.CC.CORECONNECT__Start_Date__c  = date.today()+1;
			tes.objEventsController.CC.CORECONNECT__End_Date__c  = date.today();
			tes.objEventsController.CC.CORECONNECT__Location__c  = 'Loc';
			tes.objEventsController.CC.CORECONNECT__Location_Street_1__c  = 'Loc Street1';
			tes.objEventsController.CC.CORECONNECT__Location_City__c  = 'Loc City 1';
			tes.objEventsController.CC.CORECONNECT__Location_State_Province__c  = 'Loc State 1';
			tes.objEventsController.CC.CORECONNECT__Location_Postal_Code__c  = 'Loc Postal 1';
			tes.objEventsController.CC.CORECONNECT__Location_Country__c  = 'Loc Country 1';
			tes.objEventsController.att.Name = 'attachment';
            tes.objEventsController.att.description = 'desc';
            tes.objEventsController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objEventsController.createScheduledContent();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            System.assert(erroMessages1.size()==2);
		}
	}
	
	@isTest static void test_EditScheduledContent() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		Id RecordTypeIdScheduledContent = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('ScheduledContent').getRecordTypeId();
		
		CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdScheduledContent, 'UnitTest Test Data', true, false);
		insert objCommunityContent;
		
		List<CORECONNECT__CC_Community_Content__c> lstComContent = [	select 	Id,CORECONNECT__Short_Description__c 
            															from 	CORECONNECT__CC_Community_Content__c 
                                                          				where 	Id =: objCommunityContent.Id];
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
                                                          					
		User objUser = objUtil.createUser();
		
		PageReference pageRef = new PageReference('/apex/EventCreate?Id='+lstComContent[0].Id);
        Test.setCurrentPage(pageRef);
        
        EventCreateController objEventCreateControllerForEdit = new EventCreateController();
        
		System.runAs(objUser){
			
			objEventCreateControllerForEdit.CC.CORECONNECT__Short_Description__c = 'Test ScheduledContent2';
            
            PageReference pr1 = objEventCreateControllerForEdit.createScheduledContent();
		}
	}
	
	@isTest static void test_InvalidScheduledContentId() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		Id RecordTypeIdScheduledContent = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('ScheduledContent').getRecordTypeId();
		
		CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdScheduledContent, 'UnitTest Test Data', true, false);
		insert objCommunityContent;
                                                          					
		User objUser = objUtil.createUser();
		
		PageReference pageRef = new PageReference('/apex/EventCreate?Id=586WW');
		
        Test.setCurrentPage(pageRef);
        
        EventCreateController objEventCreateControllerForEdit = new EventCreateController();
        
		System.runAs(objUser){
			
			PageReference pr1 = objEventCreateControllerForEdit.forwardToLogin();
			
			PageReference pageRef2 = new PageReference('/apex/events');
			
			System.assertEquals(String.valueOf(pageRef2),String.valueOf(pr1));
		}
	}
	
	@isTest static void test_InvalidDate() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		EventCreateController_Test tes = new EventCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objEventsController.CC.Name = 'UnitTest Test Data ScheduledContent';
			tes.objEventsController.CC.CORECONNECT__Short_Description__c = 'Test ScheduledContent';
			tes.objEventsController.CC.CORECONNECT__Description__c = 'Description';
			tes.objEventsController.CC.CORECONNECT__Classification1__c = 'All';
			tes.objEventsController.CC.CORECONNECT__Classification2__c  = 'Arts';
			tes.objEventsController.CC.Source__c  = 'Blogs';
			tes.objEventsController.CC.Topic__c  = 'Arts';
			tes.objEventsController.CC.CORECONNECT__Start_Date__c  = date.today();
			tes.objEventsController.CC.CORECONNECT__End_Date__c  = date.today()+1;
			tes.objEventsController.StartDateTimeString = '8566 gdfg';
			tes.objEventsController.EndDateTimeString = '8596 gdfg';
			tes.objEventsController.CC.CORECONNECT__Location__c  = 'Loc';
			tes.objEventsController.CC.CORECONNECT__Location_Street_1__c  = 'Loc Street1';
			tes.objEventsController.CC.CORECONNECT__Location_City__c  = 'Loc City 1';
			tes.objEventsController.CC.CORECONNECT__Location_State_Province__c  = 'Loc State 1';
			tes.objEventsController.CC.CORECONNECT__Location_Postal_Code__c  = 'Loc Postal 1';
			tes.objEventsController.CC.CORECONNECT__Location_Country__c  = 'Loc Country 1';
			tes.objEventsController.att.Name = 'attachment';
            tes.objEventsController.att.description = 'desc';
            tes.objEventsController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objEventsController.createScheduledContent();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            System.assertEquals(3,erroMessages1.size());
		}
	}
}