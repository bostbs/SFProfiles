@isTest
private class EventsController_Test {

    static testMethod void myUnitTest() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContentToInsert  = new List<CORECONNECT__CC_Community_Content__c>();
        List<Attachment> lstAttachmentToInsert = new List<Attachment>();
        
        Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('ScheduledContent').getRecordTypeId();
        
        for(Integer i=0; i<5; i++){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test'+i, true, false);
            objCommunityContent.CORECONNECT__Start_Date__c = Date.today() + 1;
            lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test'+i, false, true);
            objCommunityContent.CORECONNECT__Start_Date__c = Date.today() + 1;
            lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdFreeText, 'Test'+i, false, false);
            objCommunityContent.CORECONNECT__Start_Date__c = Date.today() + 1;
            lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<5; i++){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent2(RecordTypeIdFreeText, 'Test'+i, false, false);
            objCommunityContent.CORECONNECT__Start_Date__c = Date.today() + 1;
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
            
            PageReference pageRef = new PageReference('/apex/Events');
            Test.setCurrentPage(pageRef);
            
            EventsController objEventsController = new EventsController();
            
            objEventsController.SpecifiedPageNumber = 2;
            objEventsController.GoToPage();
            objEventsController.SaveCurrentToCookie();
            system.assertEquals('',objEventsController.DefaultAttachmentDocId);
            system.assertEquals('test@test.com',objEventsController.AdminEmail);
            List<CORECONNECT.CC_CommunityContentWrapper> lst = objEventsController.ListOfMoreScheduledContent;
            
            objSystemSettings.CORECONNECT__Automated_Events_Filtering__c = false;
            update objSystemSettings;
            
            objAlumni.Default_News_Attachment_DocId__c = 'test';
            update objAlumni;
            system.assertNotEquals('',objEventsController.DefaultAttachmentDocId);
            
            objEventsController.Filter();
            objEventsController.includePastScheduledContent = true;
            
            String TodayString = objEventsController.TodayString;
            
            objEventsController.ClassificationType1 = lstCommunityContentToInsert[1].CORECONNECT__Classification1__c;
            objEventsController.ClassificationType2 = lstCommunityContentToInsert[1].CORECONNECT__Classification2__c;
            objEventsController.Filter();
            
            system.assert(objEventsController.hasNextSet);
            system.assert(!objEventsController.hasPrevSet);
            system.assert(objEventsController.PageNumber==1);
            system.assert(objEventsController.TotalPages==2);
            objEventsController.nextSet();
            system.assert(objEventsController.PageNumber==2);
            objEventsController.prevSet();
            
            system.assert(objEventsController.getClassificationValues1().size() > 0);
            system.assert(objEventsController.getClassificationValues2().size() > 0);
        }
    }
}