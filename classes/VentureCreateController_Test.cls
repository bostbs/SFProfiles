@isTest
private class VentureCreateController_Test {

    User objUser;
    PageReference pageRef;
    VentureCreateController objVentureCreateController;
    
    private void setUp(){
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        pageRef = Page.VentureCreate;
        Test.setCurrentPage(pageRef);
        
        objVentureCreateController = new VentureCreateController();
    }
    
    /**
     *  Test required fields validate 
     */
         
     @isTest static void test_validateForVenture() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        VentureCreateController_Test tes = new VentureCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            // try create without enter any data to see through the error
            tes.objVentureCreateController.createVenture();
            
            List<ApexPages.Message> erroMessages = ApexPages.getMessages();
            // we have 9 required fields
            System.assert(erroMessages.size()==9);
        }
    }
    
    @isTest static void test_createFreeText() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        VentureCreateController_Test tes = new VentureCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            
            tes.objVentureCreateController.CC.Name = 'UnitTest Test Data Venture';
            tes.objVentureCreateController.CC.CORECONNECT__Short_Description__c = 'Test Venture';
            tes.objVentureCreateController.CC.CORECONNECT__Description__c = 'Description';
            tes.objVentureCreateController.CC.CORECONNECT__Classification1__c = 'Yes';
            tes.objVentureCreateController.CC.CORECONNECT__Classification2__c  = 'No';
            tes.objVentureCreateController.CC.CORECONNECT__Classification3__c  = 'No';
            tes.objVentureCreateController.CC.Alumni_Name_Affiliation__c  = 'Test';
            tes.objVentureCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
            tes.objVentureCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
            tes.objVentureCreateController.att.Name = 'attachment';
            tes.objVentureCreateController.att.description = 'desc';
            tes.objVentureCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr = tes.objVentureCreateController.createVenture();
            
            tes.objVentureCreateController.cancelVenture();   
            
            System.assert(tes.objVentureCreateController.CC.Name == null);
        }
    }
    
    @isTest static void test_showErrorMsgForWrongDate1() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        VentureCreateController_Test tes = new VentureCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            
            tes.objVentureCreateController.CC.Name = 'UnitTest Test Data Venture';
            tes.objVentureCreateController.CC.CORECONNECT__Short_Description__c = 'Test Venture';
            tes.objVentureCreateController.CC.CORECONNECT__Description__c = 'Description';
            tes.objVentureCreateController.CC.CORECONNECT__Classification1__c = 'All';
            tes.objVentureCreateController.CC.CORECONNECT__Classification2__c  = 'Arts';
            tes.objVentureCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today();
            tes.objVentureCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today();
            tes.objVentureCreateController.att.Name = 'attachment';
            tes.objVentureCreateController.att.description = 'desc';
            tes.objVentureCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objVentureCreateController.createVenture();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            
        }
    }
    
    @isTest static void test_showErrorMsgForWrongDate2() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        VentureCreateController_Test tes = new VentureCreateController_Test();
        
        tes.objUser = objUtil.createUser();
        
        System.runAs(tes.objUser){
            
            tes.setUp();
            
            tes.objVentureCreateController.CC.Name = 'UnitTest Test Data Venture';
            tes.objVentureCreateController.CC.CORECONNECT__Short_Description__c = 'Test Venture';
            tes.objVentureCreateController.CC.CORECONNECT__Description__c = 'Description';
            tes.objVentureCreateController.CC.CORECONNECT__Classification1__c = 'All';
            tes.objVentureCreateController.CC.CORECONNECT__Classification2__c  = 'Arts';
            tes.objVentureCreateController.CC.CORECONNECT__FreeText_Desired_Publish_Date__c  = date.today()-1;
            tes.objVentureCreateController.CC.CORECONNECT__FreeText_End_Date__c  = date.today()+1;
            tes.objVentureCreateController.att.Name = 'attachment';
            tes.objVentureCreateController.att.description = 'desc';
            tes.objVentureCreateController.att.Body = Blob.valueOf('test body');
            
            PageReference pr1 = tes.objVentureCreateController.createVenture();
            
            List<ApexPages.Message> erroMessages1 = ApexPages.getMessages();
            
        }
    }
    
    @isTest static void test_EditFreeText() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        Id recordTypeIdVenture = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Venture').getRecordTypeId();
        
        CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(recordTypeIdVenture, 'UnitTest Test Data', true, false);
        insert objCommunityContent;
        
        List<CORECONNECT__CC_Community_Content__c> lstComContent = [    select  Id,CORECONNECT__Short_Description__c 
                                                                        from    CORECONNECT__CC_Community_Content__c 
                                                                        where   Id =: objCommunityContent.Id];
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
                                                                            
        User objUser = objUtil.createUser();
        
        PageReference pageRef = new PageReference('/apex/VentureCreate?Id='+lstComContent[0].Id);
        Test.setCurrentPage(pageRef);
        
        VentureCreateController objVentureCreateControllerForEdit = new VentureCreateController();
        
        System.runAs(objUser){
            
            objVentureCreateControllerForEdit.CC.CORECONNECT__Short_Description__c = 'Test Ventures2';
            
            PageReference pr1 = objVentureCreateControllerForEdit.createVenture();
        }
        
        objCommunityContent.CORECONNECT__Community_Content_Status__c = 'Created';
        update objCommunityContent;
        objVentureCreateControllerForEdit.goToVenturePage();
    }
    
    @isTest static void test_InvalidFreeTextId() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        Id recordTypeIdVenture = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Venture').getRecordTypeId();
        
        CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(recordTypeIdVenture, 'UnitTest Test Data', true, false);
        insert objCommunityContent;
                                                                            
        User objUser = objUtil.createUser();
        
        PageReference pageRef = new PageReference('/apex/VentureCreate?Id=586WW');
        
        Test.setCurrentPage(pageRef);
        
        VentureCreateController objVentureCreateControllerForEdit = new VentureCreateController();
        
        System.runAs(objUser){
            
            PageReference pr1 = objVentureCreateControllerForEdit.goToVenturePage();
            
            PageReference pageRef2 = new PageReference('/apex/ventures');
            
            System.assertEquals(String.valueOf(pageRef2),String.valueOf(pr1));
        }
        
    }
}