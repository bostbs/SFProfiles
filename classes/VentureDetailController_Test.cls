@isTest
private class VentureDetailController_Test {

    User objuser;
    PageReference pageRef;
    VentureDetailController cont; 
    CORECONNECT__CC_Community_Content__c cc;
    
    private void setUp(){
        
        pageRef = Page.VentureDetail;
        Test.setCurrentPage(pageRef);
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        objUser = objUtil.createCommunityUser();
        //insert objUser;
    }
    
    @isTest static void test_FreeTextDetail(){
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        VentureDetailController_Test  tes = new VentureDetailController_Test();
        
        Test.startTest();
        tes.setUp();
        
        Id RecordTypeIdVenture = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Venture').getRecordTypeId();
        
        tes.cc = objUtil.createCommunityContent(RecordTypeIdVenture, 'Test', false, false);
        insert tes.cc; 
        
        Attachment objAttachment = objUtil.createAttachment(tes.cc.Id, tes.cc.Name);
        insert objAttachment;
        
        VTAC__c obj = new VTAC__c();
        obj.title__c = 'test';
        obj.Community_Content_Status__c = 'Approved';
        obj.Publish_Date__c = System.today();
        obj.Body__c='Test';
        insert obj;
        
        
        System.runAs(tes.objuser){
            
            Id strId = ApexPages.CurrentPage().getparameters().put('Id', tes.cc.Id);
            
            tes.cont = new  VentureDetailController(new ApexPages.standardController(tes.cc));
            
            System.assert(!String.isEmpty(tes.cont.FreeTextPublishDate));
            System.assert(tes.cont.GuestProfileName == 'Test');
            tes.cont.updateContactTermTimeStamp();
            
        }
        
        tes.cc.CORECONNECT__Community_Content_Status__c = 'Created';
        update tes.cc;
        tes.cont.GoToList();
    }

}