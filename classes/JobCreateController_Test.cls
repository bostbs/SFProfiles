@isTest
private class JobCreateController_Test {
    
    User objUser;
    PageReference pageRef;
    JobCreateController objJobCreateController;
    
    private void setUp(){
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        pageRef = Page.JobCreate;
        Test.setCurrentPage(pageRef);
        
        objJobCreateController = new JobCreateController();
    }
    
    /**
     *  Test required fields validate 
     */
         
     @isTest static void test_validateForFreeText() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        JobCreateController_Test tes = new JobCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            // try create without enter any data to see through the error
            tes.objJobCreateController.createJob();
            
            List<ApexPages.Message> erroMessages = ApexPages.getMessages();
            // we have 9 required fields
            System.assert(erroMessages.size()>0);
        }
    }
    
    @isTest static void test_createJob() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        JobCreateController_Test tes = new JobCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            
            tes.objJobCreateController.CC.Name = 'UnitTest Test Data FreeText';
            tes.objJobCreateController.CC.Title__c = 'UnitTest Test Data FreeText';
            tes.objJobCreateController.CC.CORECONNECT__Short_Description__c = 'Test FreeText';
            tes.objJobCreateController.CC.CORECONNECT__Description__c = 'Description';
            tes.objJobCreateController.CC.Industry__c = 'All';
            tes.objJobCreateController.CC.Job_Location__c  = 'Arts';
            tes.objJobCreateController.CC.Applicant_Type__c  = 'Blogs';
            tes.objJobCreateController.CC.Location_Type__c  = 'Online/remote';
            tes.objJobCreateController.CC.Job_Status__c = 'Full time';
            tes.objJobCreateController.CC.Default_Content__c = false;
            tes.objJobCreateController.CC.Trump_Content__c = false;
            tes.objJobCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
            tes.objJobCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
            tes.objJobCreateController.att.Name = 'attachment';
            tes.objJobCreateController.att.description = 'desc';
            tes.objJobCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr = tes.objJobCreateController.createJob();
            
            List<CORECONNECT__CC_Community_Content__c> lstComContent = [    select  Id,CORECONNECT__Short_Description__c 
                                                                            from    CORECONNECT__CC_Community_Content__c];
            
            system.debug('lstComContent============'+lstComContent);
            if(null!=lstComContent && lstComContent.size()>0)
                System.assertEquals('Test FreeText',lstComContent[0].CORECONNECT__Short_Description__c);
            
            tes.objJobCreateController.cancelJob();
            
            System.assert(tes.objJobCreateController.CC.Name == null);
        }
    }
    
    @isTest static void test_showErrorMsgForWrongDate1() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        JobCreateController_Test tes = new JobCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            
            tes.objJobCreateController.CC.Name = 'UnitTest Test Data FreeText';
            tes.objJobCreateController.CC.Title__c = 'UnitTest Test Data FreeText';
            tes.objJobCreateController.CC.CORECONNECT__Short_Description__c = 'Test FreeText';
            tes.objJobCreateController.CC.CORECONNECT__Description__c = 'Description';
            tes.objJobCreateController.CC.Industry__c = 'All';
            tes.objJobCreateController.CC.Job_Location__c  = 'Arts';
            tes.objJobCreateController.CC.Applicant_Type__c  = 'Blogs';
            tes.objJobCreateController.CC.Location_Type__c  = 'Online/remote';
            tes.objJobCreateController.CC.Job_Status__c = 'Full time';
            tes.objJobCreateController.CC.Default_Content__c = false;
            tes.objJobCreateController.CC.Trump_Content__c = false;
            tes.objJobCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
            tes.objJobCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today();
            tes.objJobCreateController.att.Name = 'attachment';
            tes.objJobCreateController.att.description = 'desc';
            tes.objJobCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objJobCreateController.createJob();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            system.debug('erroMessages1=========='+erroMessages1);
            System.assertEquals(4,erroMessages1.size());
        }
    }
    
    @isTest static void test_showErrorMsgForWrongDate2() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        JobCreateController_Test tes = new JobCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            
            tes.objJobCreateController.CC.Name = 'UnitTest Test Data FreeText';
            tes.objJobCreateController.CC.Title__c = 'UnitTest Test Data FreeText';
            tes.objJobCreateController.CC.CORECONNECT__Short_Description__c = 'Test FreeText';
            tes.objJobCreateController.CC.CORECONNECT__Description__c = 'Description';
            tes.objJobCreateController.CC.Industry__c = 'All';
            tes.objJobCreateController.CC.Job_Location__c  = 'Arts';
            tes.objJobCreateController.CC.Applicant_Type__c  = 'Blogs';
            tes.objJobCreateController.CC.Location_Type__c  = 'Online/remote';
            tes.objJobCreateController.CC.Job_Status__c = 'Full time';
            tes.objJobCreateController.CC.Default_Content__c = false;
            tes.objJobCreateController.CC.Trump_Content__c = false;
            tes.objJobCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today()-1;
            tes.objJobCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
            tes.objJobCreateController.att.Name = 'attachment';
            tes.objJobCreateController.att.description = 'desc';
            tes.objJobCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objJobCreateController.createJob();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            System.assertEquals(4,erroMessages1.size());
        }
    }
    
    @isTest static void test_catch() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        JobCreateController_Test tes = new JobCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            
            tes.objJobCreateController.CC.Name = 'UnitTest Test Data FreeText';
            tes.objJobCreateController.CC.CORECONNECT__Short_Description__c = 'Test FreeText';
            tes.objJobCreateController.CC.CORECONNECT__Description__c = 'Description';
            tes.objJobCreateController.CC.Industry__c = 'All';
            tes.objJobCreateController.CC.Job_Location__c  = 'Arts';
            tes.objJobCreateController.CC.Applicant_Type__c  = 'Blogs';
            tes.objJobCreateController.CC.Location_Type__c  = 'Online/remote';
            tes.objJobCreateController.CC.Job_Status__c = 'Full time';
            tes.objJobCreateController.CC.Default_Content__c = true;
            tes.objJobCreateController.CC.Trump_Content__c = true;
            tes.objJobCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today()-1;
            tes.objJobCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
            tes.objJobCreateController.att.Name = 'attachment';
            tes.objJobCreateController.att.description = 'desc';
            tes.objJobCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objJobCreateController.createJob();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            System.assert(erroMessages1.size()>0);
            
            tes.objJobCreateController.submit('/apex/jobs');
        }
    }
    
    @isTest static void test_EditFreeText() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Job').getRecordTypeId();
        
        CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'UnitTest Test Data', true, false);
        insert objCommunityContent;
        
        List<CORECONNECT__CC_Community_Content__c> lstComContent = [    select  Id,CORECONNECT__Short_Description__c 
                                                                        from    CORECONNECT__CC_Community_Content__c 
                                                                        where   Id =: objCommunityContent.Id];
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
                                                                            
        User objUser = objUtil.createUser();
        
        PageReference pageRef = new PageReference('/apex/NewsCreate?Id='+lstComContent[0].Id);
        Test.setCurrentPage(pageRef);
        
        JobCreateController objJobCreateControllerForEdit = new JobCreateController();
        
        System.runAs(objUser){
            
            objJobCreateControllerForEdit.CC.CORECONNECT__Short_Description__c = 'Test FreeText2';
            
            PageReference pr1 = objJobCreateControllerForEdit.createJob();
        }
    }
    
    @isTest static void test_InvalidJobId() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Job').getRecordTypeId();
        
        CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'UnitTest Test Data', true, false);
        insert objCommunityContent;
                                                                            
        User objUser = objUtil.createUser();
        
        PageReference pageRef = new PageReference('/apex/JobCreate?Id=586WW');
        
        Test.setCurrentPage(pageRef);
        
        JobCreateController objJobCreateControllerForEdit = new JobCreateController();
        
        System.runAs(objUser){
            
            PageReference pr1 = objJobCreateControllerForEdit.forwardToLogin();
            
            PageReference pageRef2 = new PageReference('/apex/jobs');
            
            System.assertEquals(String.valueOf(pageRef2),String.valueOf(pr1));
        }
    }
}