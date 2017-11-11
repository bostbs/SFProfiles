@isTest
private class NewsCreateController_Test {
	
	User objUser;
    PageReference pageRef;
    NewsCreateController objNewsCreateController;
    
    private void setUp(){
    	
    	BAB_TestUtil objUtil = new BAB_TestUtil();
    	
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        pageRef = Page.NewsCreate;
        Test.setCurrentPage(pageRef);
        
        objNewsCreateController = new NewsCreateController();
    }
    
    /**
	 *  Test required fields validate 
	 */
	     
     @isTest static void test_validateForFreeText() {
     	
     	BAB_TestUtil objUtil = new BAB_TestUtil();
     	
        NewsCreateController_Test tes = new NewsCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
        	
        	tes.setUp();
            // try create without enter any data to see through the error
            tes.objNewsCreateController.createFreeText();
            
            List<ApexPages.Message> erroMessages = ApexPages.getMessages();
            // we have 9 required fields
            System.assert(erroMessages.size()==9);
     	}
	}
	
	@isTest static void test_createFreeText() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		NewsCreateController_Test tes = new NewsCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objNewsCreateController.CC.Name = 'UnitTest Test Data FreeText';
			tes.objNewsCreateController.CC.CORECONNECT__Short_Description__c = 'Test FreeText';
			tes.objNewsCreateController.CC.CORECONNECT__Description__c = 'Description';
			tes.objNewsCreateController.CC.CORECONNECT__Classification1__c = 'All';
			tes.objNewsCreateController.CC.CORECONNECT__Classification2__c  = 'Arts';
			tes.objNewsCreateController.CC.Source__c  = 'Blogs';
			tes.objNewsCreateController.CC.Topic__c  = 'Arts';
			tes.objNewsCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
			tes.objNewsCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
			tes.objNewsCreateController.att.Name = 'attachment';
            tes.objNewsCreateController.att.description = 'desc';
            tes.objNewsCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr = tes.objNewsCreateController.createFreeText();
            
            List<CORECONNECT__CC_Community_Content__c> lstComContent = [	select 	Id,CORECONNECT__Short_Description__c 
            																from 	CORECONNECT__CC_Community_Content__c 
                                                          					where 	Name = 'UnitTest Test Data FreeText' 
                                                          					and 	CORECONNECT__Community_Content_Status__c = 'Created'];
            
            System.assertEquals('Test FreeText',lstComContent[0].CORECONNECT__Short_Description__c);
           	
           	tes.objNewsCreateController.cancelFreeText();
           	
           	System.assert(tes.objNewsCreateController.CC.Name == null);
		}
	}
	
	@isTest static void test_showErrorMsgForWrongDate1() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		NewsCreateController_Test tes = new NewsCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objNewsCreateController.CC.Name = 'UnitTest Test Data FreeText';
			tes.objNewsCreateController.CC.CORECONNECT__Short_Description__c = 'Test FreeText';
			tes.objNewsCreateController.CC.CORECONNECT__Description__c = 'Description';
			tes.objNewsCreateController.CC.CORECONNECT__Classification1__c = 'All';
			tes.objNewsCreateController.CC.CORECONNECT__Classification2__c  = 'Arts';
			tes.objNewsCreateController.CC.Source__c  = 'Blogs';
			tes.objNewsCreateController.CC.Topic__c  = 'Arts';
			tes.objNewsCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
			tes.objNewsCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today();
			tes.objNewsCreateController.att.Name = 'attachment';
            tes.objNewsCreateController.att.description = 'desc';
            tes.objNewsCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objNewsCreateController.createFreeText();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            System.assert(erroMessages1.size()==1);
		}
	}
	
	@isTest static void test_showErrorMsgForWrongDate2() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		NewsCreateController_Test tes = new NewsCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objNewsCreateController.CC.Name = 'UnitTest Test Data FreeText';
			tes.objNewsCreateController.CC.CORECONNECT__Short_Description__c = 'Test FreeText';
			tes.objNewsCreateController.CC.CORECONNECT__Description__c = 'Description';
			tes.objNewsCreateController.CC.CORECONNECT__Classification1__c = 'All';
			tes.objNewsCreateController.CC.CORECONNECT__Classification2__c  = 'Arts';
			tes.objNewsCreateController.CC.Source__c  = 'Blogs';
			tes.objNewsCreateController.CC.Topic__c  = 'Arts';
			tes.objNewsCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today()-1;
			tes.objNewsCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
			tes.objNewsCreateController.att.Name = 'attachment';
            tes.objNewsCreateController.att.description = 'desc';
            tes.objNewsCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objNewsCreateController.createFreeText();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            System.assert(erroMessages1.size()==1);
		}
	}
	
	@isTest static void test_EditFreeText() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('FreeText').getRecordTypeId();
		
		CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'UnitTest Test Data', true, false);
		insert objCommunityContent;
		
		List<CORECONNECT__CC_Community_Content__c> lstComContent = [	select 	Id,CORECONNECT__Short_Description__c 
            															from 	CORECONNECT__CC_Community_Content__c 
                                                          				where 	Id =: objCommunityContent.Id];
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
                                                          					
		User objUser = objUtil.createUser();
		
		PageReference pageRef = new PageReference('/apex/NewsCreate?Id='+lstComContent[0].Id);
        Test.setCurrentPage(pageRef);
        
        NewsCreateController objNewsCreateControllerForEdit = new NewsCreateController();
        
		System.runAs(objUser){
			
			objNewsCreateControllerForEdit.CC.CORECONNECT__Short_Description__c = 'Test FreeText2';
            
            PageReference pr1 = objNewsCreateControllerForEdit.createFreeText();
		}
		
	    objCommunityContent.CORECONNECT__Community_Content_Status__c = 'Created';
		update objCommunityContent;
		objNewsCreateControllerForEdit.goToNewsPage();
	}
	
	@isTest static void test_InvalidFreeTextId() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('FreeText').getRecordTypeId();
		
		CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'UnitTest Test Data', true, false);
		insert objCommunityContent;
                                                          					
		User objUser = objUtil.createUser();
		
		PageReference pageRef = new PageReference('/apex/NewsCreate?Id=586WW');
		
        Test.setCurrentPage(pageRef);
        
        NewsCreateController objNewsCreateControllerForEdit = new NewsCreateController();
        
		System.runAs(objUser){
			
			PageReference pr1 = objNewsCreateControllerForEdit.goToNewsPage();
			
			PageReference pageRef2 = new PageReference('/apex/news');
			
			System.assertEquals(String.valueOf(pageRef2),String.valueOf(pr1));
		}
	}
}