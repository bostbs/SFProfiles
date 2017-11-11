@isTest
private class NewsController_Test {

    static testMethod void myUnitTest() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContentToInsert  = new List<CORECONNECT__CC_Community_Content__c>();
        List<Attachment> lstAttachmentToInsert = new List<Attachment>();
        
        Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('FreeText').getRecordTypeId();
        
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
        //insert objUser;
        
        AlumniCommunityPersonalization__c objAlumniComPersonalization = objUtil.createAlumniComPersonalization();
        insert objAlumniComPersonalization;
        
        System.runAs(objUser){
        	
        	PageReference pageRef = new PageReference('/apex/news');
        	Test.setCurrentPage(pageRef);
        	
        	NewsController objNewsController = new NewsController();
        	
        	objNewsController.SpecifiedPageNumber = 2;
        	objNewsController.GoToPage();
        	objNewsController.forwardToLogin();
        	objNewsController.SaveCurrentToCookie();
            //List<SelectOption> newlst = objNewsController.getClassification1Values();
            //List<SelectOption> newlst1 = objNewsController.getClassificationValues2();
            
            system.assertEquals('', objNewsController.DefaultAttachmentDocId);
            
            objAlumni.Default_News_Attachment_DocId__c = 'test';
            update objAlumni;
            system.assertNotEquals(null, objNewsController.DefaultAttachmentDocId);
            
            system.assertNotEquals(null, objNewsController.AdminEmail);
            
        	List<CC_CommunityContentWrapper> lst = objNewsController.ListOfMoreFreeText;
        	
        	objSystemSettings.CORECONNECT__Automated_News_Filtering__c = false;
        	update objSystemSettings;
        	
        	objNewsController.Filter();
        	system.assert(objNewsController.hasNextSet);
        	system.assert(!objNewsController.hasPrevSet);
        	system.assert(objNewsController.PageNumber==1);
        	system.assertEquals(4,objNewsController.TotalPages);
        	objNewsController.nextSet();
        	system.assert(objNewsController.PageNumber==2);
        	objNewsController.prevSet();
        	String TodayString = objNewsController.TodayString;
        	
        	objNewsController.Classification1 = lstCommunityContentToInsert[lstCommunityContentToInsert.size()-1].CORECONNECT__Classification1__c;
        	objNewsController.ClassificationType2 = lstCommunityContentToInsert[lstCommunityContentToInsert.size()-1].CORECONNECT__Classification2__c;
        	objNewsController.Filter();
        	
        	system.assertEquals(12,objNewsController.ListOfMoreFreeText.size());
        	
        	system.assert(objNewsController.getClassification1Values().size() > 0);
            system.assert(objNewsController.getClassificationValues2().size() > 0);
        	
        }
    }
}