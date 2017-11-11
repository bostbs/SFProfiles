@isTest
public class JobDetailController_Test {
     
    @isTest static void test_method_1(){
        
        PageReference pageRef = Page.JobDetail;
        Test.setCurrentPage(pageRef);
        JobDetailController cont;
        
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
    	
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
       
        User objUser = objUtil.createUser();
        insert objUser;
    	
    	Test.startTest();
    	
    	Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Job').getRecordTypeId();
    	
    	CORECONNECT__CC_Community_Content__c cc = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test', false, false);
    	insert cc; 
    	
    	Attachment objAttachment = objUtil.createAttachment(cc.Id, cc.Name);
       	insert objAttachment;
    	
    	System.runAs(objuser){
    		
    		Id strId = ApexPages.CurrentPage().getparameters().put('Id', cc.Id);
    		
    		cont = new  JobDetailController(new ApexPages.standardController(cc));
			System.assert(cont.GuestProfileName == 'Test');
			
			cont.SaveCurrentToCookie();
			System.assert(String.isEmpty(cont.HeaderLabel));
    	}
        
    }
}