@isTest
public with sharing class BabsonProfileStrengthController_Test {
	public BabsonProfileStrengthController_Test() {
		
	}

	static testMethod void testPercentage() {
	    
	    BAB_TestUtil objUtil = new BAB_TestUtil();
        User objUser = objUtil.createCommunityUser();
        objUser = [SELECT COntact.AccountId,contactId FROM USER WHERE id =: objUser.Id];
        Contact objContact = new Contact();
        objContact = [SELECT ID FROM Contact Where Id IN (Select contactId FROM USER WHERE id =: objUser.Id)];
        
        hed__Address__c objTestAddress = objUtil.createAddress(objUser.COntact.AccountId, false, 'Home', 'Home 1');
		objTestAddress.hed__MailingPostalCode__c = '12345';
        objTestAddress.hed__Parent_Contact__c = objContact.Id;
		update objTestAddress;
		
		Id RecordTypeIdBusiness = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
    	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdBusiness, 'Test', true, false);
    	objCommunityContent.Publish_Business__c = True;
    	objCommunityContent.Contact__c = objUser.contactId;
    	objCommunityContent.Company__c = 'Test';
    	objCommunityContent.Title__c = 'Test';
    	objCommunityContent.Business_Industry__c = 'Accounting';
        
        System.runAs(objUser){
            
            BabsonProfileStrengthController profileStrength = new BabsonProfileStrengthController();
    		insert objCommunityContent;
    		profileStrength.percentComplete = profileStrength.profileCompletionField();
    		system.assert(profileStrength.percentComplete > 0);
        }
	}
}