@isTest
private class BusinessCreateController_Test {
	
	User objUser;
    PageReference pageRef;
    BusinessCreateController objBusinessCreateController;
    
    private void setUp(){
    	
    	BAB_TestUtil objUtil = new BAB_TestUtil();
    	
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        pageRef = Page.JobCreate;
        Test.setCurrentPage(pageRef);
        
        objBusinessCreateController = new BusinessCreateController();
    }
    
    /**
	 *  Test required fields validate 
	 */
	     
     @isTest static void test_validateForBusiness() {
     	
     	BAB_TestUtil objUtil = new BAB_TestUtil();
     	
        BusinessCreateController_Test tes = new BusinessCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
        	
        	tes.setUp();
            // try create without enter any data to see through the error
            tes.objBusinessCreateController.createBusinessRecord();
            
            List<ApexPages.Message> erroMessages = ApexPages.getMessages();
            // we have 9 required fields
            System.assert(erroMessages.size()>0);
     	}
	}
	
	@isTest static void test_createBusiness() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		BusinessCreateController_Test tes = new BusinessCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objBusinessCreateController.CC.Name = 'UnitTest Test Data FreeText';
			tes.objBusinessCreateController.CC.Business_Summary__c = 'Test FreeText';
			tes.objBusinessCreateController.CC.Business_Description__c = 'Description';
			tes.objBusinessCreateController.CC.Industry__c = 'All';
			tes.objBusinessCreateController.CC.Default_Content__c = false;
			tes.objBusinessCreateController.CC.Trump_Content__c = false;
			tes.objBusinessCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
			tes.objBusinessCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
			tes.objBusinessCreateController.CC.CORECONNECT__Classification1__c = 'yes';
			tes.objBusinessCreateController.CC.Business_Location_Classification_Filter__c = 'All';
			tes.objBusinessCreateController.CC.Business_Industry__c = 'Advertising';
            tes.objBusinessCreateController.CC.CORECONNECT__Location__c = 'test';
            tes.objBusinessCreateController.CC.Phone__c = '132345';
            tes.objBusinessCreateController.CC.Website__c = 'www.test.com';
            tes.objBusinessCreateController.CC.Email__c = 'abc@yahoo.com';
			
			
			tes.objBusinessCreateController.att.Name = 'attachment';
            tes.objBusinessCreateController.att.description = 'desc';
            tes.objBusinessCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr = tes.objBusinessCreateController.createBusinessRecord();
            
            //System.assertNotEquals(0,tes.objBusinessCreateController.userBusinessCount);
            
            List<CORECONNECT__CC_Community_Content__c> lstComContent = [	select 	Id,Business_Summary__c 
            																from 	CORECONNECT__CC_Community_Content__c 
                                                          					where 	Name = 'UnitTest Test Data FreeText' 
                                                          					and 	CORECONNECT__Community_Content_Status__c = 'Created'];
            
            //System.assertEquals('Test FreeText',lstComContent[0].Business_Summary__c);
            
            //System.assertNotEquals(0,tes.objBusinessCreateController.userBusinessCount);
           	
           	tes.objBusinessCreateController.cancelBusinessRecord();
           	
           	//System.assert(tes.objBusinessCreateController.CC.Name == null);
		}
	}
	
	/*@isTest static void test_showErrorMsgForWrongDate1() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		BusinessCreateController_Test tes = new BusinessCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objBusinessCreateController.CC.Name = 'UnitTest Test Data FreeText';
			tes.objBusinessCreateController.CC.Business_Summary__c = 'Test FreeText';
			tes.objBusinessCreateController.CC.Business_Description__c = 'Description';
			tes.objBusinessCreateController.CC.Industry__c = 'All';
			tes.objBusinessCreateController.CC.Default_Content__c = false;
			tes.objBusinessCreateController.CC.Trump_Content__c = false;
			tes.objBusinessCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
			tes.objBusinessCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today();
			tes.objBusinessCreateController.CC.CORECONNECT__Classification1__c = 'yes';
			tes.objBusinessCreateController.CC.Business_Location_Classification_Filter__c = 'All';
			tes.objBusinessCreateController.CC.Business_Industry__c = 'Advertising';
            tes.objBusinessCreateController.CC.CORECONNECT__Location__c = 'test';
            tes.objBusinessCreateController.CC.Phone__c = '132345';
            tes.objBusinessCreateController.CC.Website__c = 'www.test.com';
            tes.objBusinessCreateController.CC.Email__c = 'abc@yahoo.com';
			
			tes.objBusinessCreateController.att.Name = 'attachment';
            tes.objBusinessCreateController.att.description = 'desc';
            tes.objBusinessCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objBusinessCreateController.createBusinessRecord();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            system.debug('erroMessages1============'+erroMessages1);
            
            System.assertEquals(1,erroMessages1.size());
		}
	}
	
	@isTest static void test_showErrorMsgForWrongDate2() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		BusinessCreateController_Test tes = new BusinessCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objBusinessCreateController.CC.Name = 'UnitTest Test Data FreeText';
			tes.objBusinessCreateController.CC.Business_Summary__c = 'Test FreeText';
			tes.objBusinessCreateController.CC.Business_Description__c = 'Description';
			tes.objBusinessCreateController.CC.Industry__c = 'All';
			tes.objBusinessCreateController.CC.Default_Content__c = false;
			tes.objBusinessCreateController.CC.Trump_Content__c = false;
			tes.objBusinessCreateController.CC.CORECONNECT__Classification1__c = 'yes';
			tes.objBusinessCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today()-1;
			tes.objBusinessCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
			tes.objBusinessCreateController.CC.Business_Location_Classification_Filter__c = 'All';
			tes.objBusinessCreateController.CC.Business_Industry__c = 'Advertising';
            tes.objBusinessCreateController.CC.CORECONNECT__Location__c = 'test';
            tes.objBusinessCreateController.CC.Phone__c = '132345';
            tes.objBusinessCreateController.CC.Website__c = 'www.test.com';
            tes.objBusinessCreateController.CC.Email__c = 'abc@yahoo.com';
            
            PageReference pr1 = tes.objBusinessCreateController.createBusinessRecord();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            System.assertEquals(1,erroMessages1.size());
		}
	}*/
	
	@isTest static void test_catch() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		BusinessCreateController_Test tes = new BusinessCreateController_Test();
		
		tes.objUser = objUtil.createUser();
		
		System.runAs(tes.objUser){
			
			tes.setUp();
			
			tes.objBusinessCreateController.CC.Name = 'UnitTest Test Data FreeText';
			tes.objBusinessCreateController.CC.Business_Summary__c = 'Test FreeText';
			tes.objBusinessCreateController.CC.Business_Description__c = 'Description';
			tes.objBusinessCreateController.CC.Industry__c = 'All';
			tes.objBusinessCreateController.CC.Default_Content__c = true;
			tes.objBusinessCreateController.CC.Trump_Content__c = true;
			tes.objBusinessCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today()-1;
			tes.objBusinessCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
			tes.objBusinessCreateController.CC.Business_Location_Classification_Filter__c = 'All';
			tes.objBusinessCreateController.CC.Business_Industry__c = 'Advertising';
            tes.objBusinessCreateController.CC.CORECONNECT__Location__c = 'test';
            tes.objBusinessCreateController.CC.Phone__c = '132345';
            tes.objBusinessCreateController.CC.Website__c = 'www.test.com';
            tes.objBusinessCreateController.CC.Email__c = 'abc@yahoo.com';
			tes.objBusinessCreateController.att.Name = 'attachment';
            tes.objBusinessCreateController.att.description = 'desc';
            tes.objBusinessCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objBusinessCreateController.createBusinessRecord();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            System.assert(erroMessages1.size()>0);
            
            tes.objBusinessCreateController.submit('/apex/BusinessDirectory');
		}
	}
	
	@isTest static void test_EditBusiness() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		Id RecordTypeIdBUsiness = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
		
		CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdBUsiness, 'UnitTest Test Data', true, false);
		insert objCommunityContent;
		
		List<CORECONNECT__CC_Community_Content__c> lstComContent = [	select 	Id,Business_Summary__c 
            															from 	CORECONNECT__CC_Community_Content__c 
                                                          				where 	Id =: objCommunityContent.Id];
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
                                                          					
		User objUser = objUtil.createUser();
		
		PageReference pageRef = new PageReference('/apex/BusinessCreate?Id='+lstComContent[0].Id);
        Test.setCurrentPage(pageRef);
        
        BusinessCreateController objBusinessCreateControllerForEdit = new BusinessCreateController();
        
		System.runAs(objUser){
			
			objBusinessCreateControllerForEdit.CC.Business_Summary__c = 'Test FreeText2';
            
            PageReference pr1 = objBusinessCreateControllerForEdit.createBusinessRecord();
		}
		
		objCommunityContent.CORECONNECT__Community_Content_Status__c = 'Created';
		update objCommunityContent;
		objBusinessCreateControllerForEdit.goToBusinessDirectoryPage();
	}
	
	@isTest static void test_InvalidJobId() {
		
		BAB_TestUtil objUtil = new BAB_TestUtil();
		
		Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
		
		CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'UnitTest Test Data', true, false);
		insert objCommunityContent;
                                                          					
		User objUser = objUtil.createUser();
		
		PageReference pageRef = new PageReference('/apex/BusinessCreate?Id=586WW');
		
        Test.setCurrentPage(pageRef);
        
        BusinessCreateController objBusinessCreateControllerForEdit = new BusinessCreateController();
        
		System.runAs(objUser){
			
 			PageReference pr1 = objBusinessCreateControllerForEdit.goToBusinessDirectoryPage();
			
			PageReference pageRef2 = new PageReference('/apex/businessdirectory');
			
 			System.assertEquals(String.valueOf(pr1),String.valueOf(pageRef2));
		}
	}
}