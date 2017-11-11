@isTest
private class BusinessDirectoryController_Test {

 static testMethod void myUnitTest() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContentToInsert  = new List<CORECONNECT__CC_Community_Content__c>();
        List<Attachment> lstAttachmentToInsert = new List<Attachment>();
        
        Id RecordTypeIdBusiness = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        
        for(Integer i=0; i<2; i++){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdBusiness, 'Test'+i, true, false);
            
            lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<3; i++){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdBusiness, 'Test'+i, false, true);
            
            lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        for(Integer i=0; i<4; i++){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent(RecordTypeIdBusiness, 'Test'+i, false, false);
            
            lstCommunityContentToInsert.add(objCommunityContent);
        }
        
        //for(Integer i=0; i<5; i++){
            
        //  CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent2(RecordTypeIdBusiness, 'Test new', false, false);
            
        //  lstCommunityContentToInsert.add(objCommunityContent);
        //}
        
        
        
        system.assertEquals(9,lstCommunityContentToInsert.size());
        
        
        
        AlumniCommunity__c objAlumni = objUtil.createAlumniCommunity(); 
        insert objAlumni;
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        User objUser = objUtil.createCommunityUser();
        //insert objUser;
        
        AlumniCommunityPersonalization__c objAlumniComPersonalization = objUtil.createAlumniComPersonalization();
        insert objAlumniComPersonalization;
        
        System.runAs(objUser){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent = objUtil.createCommunityContent2(RecordTypeIdBusiness, 'Test new', false, false);
            lstCommunityContentToInsert.add(objCommunityContent);
            insert lstCommunityContentToInsert;
            
            for(Integer i=0; i< lstCommunityContentToInsert.size()-10; i++){
            
                Attachment objAttachment = objUtil.createAttachment(lstCommunityContentToInsert[i].Id, lstCommunityContentToInsert[i].Name);
                lstAttachmentToInsert.add(objAttachment);
            }
            
            insert lstAttachmentToInsert;
            
            PageReference pageRef = new PageReference('/apex/businessDirectory');
            Test.setCurrentPage(pageRef);
            
            BusinessDirectoryController objBusinessDirectoryController = new BusinessDirectoryController();
            
            objBusinessDirectoryController.SpecifiedPageNumber = 2;
            objBusinessDirectoryController.GoToPage();
            objBusinessDirectoryController.forwardToLogin();
            objBusinessDirectoryController.SaveCurrentToCookie();
            system.assertEquals('', objBusinessDirectoryController.DefaultAttachmentDocId);
            
            objAlumni.Default_News_Attachment_DocId__c = 'test';
            update objAlumni;
            system.assertNotEquals(null, objBusinessDirectoryController.DefaultAttachmentDocId);
            
            system.assertNotEquals(null, objBusinessDirectoryController.AdminEmail);
            
            List<CC_CommunityContentWrapper> lst = objBusinessDirectoryController.ListOfMoreBusinessRecords;
            
            objSystemSettings.CORECONNECT__Automated_News_Filtering__c = false;
            update objSystemSettings;
            
            objBusinessDirectoryController.Filter();
            //system.assert(objBusinessDirectoryController.hasNextSet);
            system.assert(!objBusinessDirectoryController.hasPrevSet);
            system.assert(objBusinessDirectoryController.PageNumber==1);
            //system.assertEquals(2,objBusinessDirectoryController.TotalPages);
            objBusinessDirectoryController.nextSet();
            //system.assert(objBusinessDirectoryController.PageNumber==2);
            objBusinessDirectoryController.prevSet();
            String TodayString = objBusinessDirectoryController.TodayString;
            
            objBusinessDirectoryController.Classification1 = lstCommunityContentToInsert[lstCommunityContentToInsert.size()-1].CORECONNECT__Classification1__c;
            objBusinessDirectoryController.ClassificationType2 = lstCommunityContentToInsert[lstCommunityContentToInsert.size()-1].Business_Location_Classification_Filter__c;
            objBusinessDirectoryController.ClassificationType3 = lstCommunityContentToInsert[lstCommunityContentToInsert.size()-1].Business_Industry__c;
            objBusinessDirectoryController.Filter();
            
            //system.assertEquals(4,objBusinessDirectoryController.ListOfMoreBusinessRecords.size());
            
           //system.assert(objBusinessDirectoryController.getClassification1Values().size() > 0);
            //system.assert(objBusinessDirectoryController.getClassificationValues2().size() > 0);
            //system.assert(objBusinessDirectoryController.getClassificationValues3().size() > 0);
        }
    }
}