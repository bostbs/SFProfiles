@isTest
private class VenturesController_Test {

	static testMethod void myUnitTest() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContentToInsert  = new List<CORECONNECT__CC_Community_Content__c>();
        List<Attachment> lstAttachmentToInsert = new List<Attachment>();
        
        Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Venture').getRecordTypeId();
        
        for(Integer i=0; i<5; i++){
        	
        	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test'+i, true, false);
        	
        	lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
        	
        	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test'+i, false, true);
        	
        	lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
        	
        	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test'+i, false, false);
        	
        	lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
        	
        	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent2(RecordTypeIdFreeText, 'Test'+i, false, false);
        	
        	lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        insert lstCommunityContentToInsert;
        
        system.assertEquals(20,lstCommunityContentToInsert.size());
        
        for(Integer i=0; i< lstCommunityContentToInsert.size()-10; i++){
        	
        	Attachment objAttachment = objUtil.createAttachment(lstCommunityContentToInsert[i].Id, lstCommunityContentToInsert[i].Name);
        	lstAttachmentToInsert.add(objAttachment);
        }
        
        insert lstAttachmentToInsert;
        
        AlumniCommunity__c objAlumni = objUtil.createAlumniCommunity(); 
        insert objAlumni;
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        User objUser = objUtil.createCommunityUser();
        
        AlumniCommunityPersonalization__c objAlumniComPersonalization = objUtil.createAlumniComPersonalization();
        insert objAlumniComPersonalization;
        
        System.runAs(objUser){
        	
        	PageReference pageRef = new PageReference('/apex/ventures');
        	Test.setCurrentPage(pageRef);
        	
        	VenturesController objVentureController = new VenturesController();
        	
        	objVentureController.SpecifiedPageNumber = 2;
        	objVentureController.GoToPage();
        	objVentureController.forwardToLogin();
        	objVentureController.SaveCurrentToCookie();
        	
        	system.assert(objVentureController.getClassification1Values().size() > 0);
            system.assert(objVentureController.getClassificationValues2().size() > 0);
            system.assert(objVentureController.getClassificationValues3().size() > 0);
            
        	List<CC_CommunityContentWrapper> lst = objVentureController.ListOfMoreVenture;
        	
        	objSystemSettings.CORECONNECT__Automated_News_Filtering__c = false;
        	update objSystemSettings;
        	
        	objAlumni.Default_News_Attachment_DocId__c = 'test';
        	update objAlumni;
        	
        	system.assertNotEquals(objVentureController.DefaultAttachmentDocId,'');
        	system.assertNotEquals(objVentureController.AdminEmail,'');
        	
        	objVentureController.Filter();
        	system.assert(objVentureController.hasNextSet);
        	system.assert(!objVentureController.hasPrevSet);
        	system.assert(objVentureController.PageNumber==1);
        	system.assertEquals(4,objVentureController.TotalPages);
        	objVentureController.nextSet();
        	system.assertEquals(2,objVentureController.PageNumber);
        	objVentureController.prevSet();
        	String TodayString = objVentureController.TodayString;
        	
        	objVentureController.Classification1 = lstCommunityContentToInsert[lstCommunityContentToInsert.size()-1].CORECONNECT__Classification1__c;
        	objVentureController.ClassificationType2 = lstCommunityContentToInsert[lstCommunityContentToInsert.size()-1].CORECONNECT__Classification2__c;
        	objVentureController.Filter();
        	
        	system.assertEquals(12,objVentureController.ListOfMoreVenture.size());
        }
	}

}