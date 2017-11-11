@isTest
private class JobsController_Test {

    static testMethod void myUnitTest() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContentToInsert  = new List<CORECONNECT__CC_Community_Content__c>();
        List<Attachment> lstAttachmentToInsert = new List<Attachment>();
        
        Id RecordTypeIdJob = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Job').getRecordTypeId();
        
        for(Integer i=0; i<5; i++){
        	
        	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdJob, 'Test'+i, true, false);
        	
        	lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
        	
        	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdJob, 'Test'+i, false, true);
        	
        	lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
        	
        	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdJob, 'Test'+i, false, false);
        	
        	lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
        	
        	CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent2(RecordTypeIdJob, 'Test'+i, false, false);
        	
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
        objSystemSettings.Automated_Job_Filtering__c = true;
        insert objSystemSettings;
        
        User objUser = objUtil.createCommunityUser();
        //insert objUser;
        
        AlumniCommunityPersonalization__c objAlumniComPersonalization = objUtil.createAlumniComPersonalization();
        insert objAlumniComPersonalization;
        
        System.runAs(objUser){
        	
        	PageReference pageRef = new PageReference('/apex/news');
        	Test.setCurrentPage(pageRef);
        	
        	JobsController objJobsController = new JobsController();
        	
        	objJobsController.SpecifiedPageNumber = 2;
        	objJobsController.GoToPage();
        	objJobsController.forwardToLogin();
        	objJobsController.SaveCurrentToCookie();
            
            system.assertEquals('', objJobsController.DefaultAttachmentDocId);
            
            objAlumni.Default_News_Attachment_DocId__c = 'test';
            update objAlumni;
            system.assertNotEquals(null, objJobsController.DefaultAttachmentDocId);
            
            system.assertNotEquals(null, objJobsController.AdminEmail);
            
        	List<CC_CommunityContentWrapper> lst = objJobsController.ListOfMoreFreeText;
        	
        	objSystemSettings.Automated_Job_Filtering__c = false;
        	update objSystemSettings;
        	
        	objJobsController.Filter();
        	system.assert(objJobsController.hasNextSet);
        	system.assert(!objJobsController.hasPrevSet);
        	system.assert(objJobsController.PageNumber==1);
        	system.assert(objJobsController.TotalPages>=1);
        	objJobsController.nextSet();
        	system.assert(objJobsController.PageNumber==2);
        	objJobsController.prevSet();
        	String TodayString = objJobsController.TodayString;
        	
        	objJobsController.Classification1 = 'job';
        	objJobsController.ClassificationType2 = 'job1';
        	objJobsController.ClassificationType3 = 'job1';
        	objJobsController.Filter();
        	
        	system.assert(objJobsController.getClassification1Values().size() > 0);
            system.assert(objJobsController.getClassificationValues2().size() > 0);
            system.assert(objJobsController.getClassificationValues3().size() > 0);
        	
        }
    }
}