@isTest
private class BabsonHomeControllerTest {
    
    private static void setUpData() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();
        
        CORECONNECT__CC_System_Settings__c objSystemSettings = objUtil.createCoreconnectSystemSettings();
        insert objSystemSettings;
        
        AlumniCommunity__c objAlumniSettings = objUtil.createAlumniCommunity(); 
        insert objAlumniSettings;
        
        AlumniCommunityPersonalization__c objAlumniPersonalSettings = objUtil.createAlumniComPersonalization();
        insert objAlumniPersonalSettings;
    }
    
    static testMethod void testHomeController() {
      
        setUpData();
        
        List<CORECONNECT__CC_Community_Content__c> lstComContentToInsert = new List<CORECONNECT__CC_Community_Content__c>();
        BAB_TestUtil objUtil = new BAB_TestUtil();
        User objUser = objUtil.createUser();
        insert objUser;       
        
        User objCommunityUser = objUtil.createCommunityUser();
        
        PageReference pageRef = new PageReference('/apex/BabsonHome');
        Test.setCurrentPage(pageRef);  
        
        Id RecordTypeIdVenture = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Venture').getRecordTypeId();
        Id RecordTypeIdFreeText = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('FreeText').getRecordTypeId();
        
        CORECONNECT__CC_Community_Content__c objCommunityContent2 = new CORECONNECT__CC_Community_Content__c();
        Id networkID = [SELECT Id FROM Network WHERE Name='Alumni'].Id;
        
        if(RecordTypeIdFreeText != null){
            
            CORECONNECT__CC_Community_Content__c objCommunityContent1 = objUtil.createCommunityContent(RecordTypeIdFreeText, 'TestJob', true, false);
            lstComContentToInsert.add(objCommunityContent1);
            
            objCommunityContent2 = objUtil.createCommunityContent(RecordTypeIdVenture, 'TestJobFree', false, true);
            lstComContentToInsert.add(objCommunityContent2);
            
            insert lstComContentToInsert;
            
            Attachment objAttachment = objUtil.createAttachment(objCommunityContent1.Id, objCommunityContent1.Name);
            insert objAttachment;
    
            EntitySubscription objEntitySubscription = objUtil.createEntitySubscription(objCommunityContent1.Id, objUser.Id);
            insert objEntitySubscription;
            
            
        }
        
        System.runAs(objUser){
    
            BabsonHomeController ctrl = new BabsonHomeController();
            ctrl.fetchRecommendedContent();
            //system.assert(ctrl.noRecordSection == true);
            
            CollaborationGroup newGroup = new CollaborationGroup(Name='Test_group', CollaborationType = 'Private');
            insert newGroup;
        }
        
        AlumniCommunity__c objAlumni = AlumniCommunity__c.getInstance('Alumni');
        objAlumni.UnAuth_Home_Logo__c = null;
        update objAlumni;
        
        System.runAs(objCommunityUser){
            
            /* EntitySubscription objEntitySubscription1 = objUtil.createEntitySubscription(objCommunityContent2.Id, objCommunityUser.Id);
            objEntitySubscription1.NetworkId = networkID;
            insert objEntitySubscription1;
            
            EntitySubscription objEntitySubscription2 = objUtil.createEntitySubscription(objUser.Id, objCommunityUser.Id);
            objEntitySubscription2.NetworkId = networkID;
            insert objEntitySubscription2;*/
                
            BabsonHomeController ctrl = new BabsonHomeController();
            ctrl.fetchRecommendedContent(); 
           // system.assert(ctrl.noRecordSection == true);
           
           ctrl.linkFilter = 'Groups';
           ctrl.fetchMyLinks();
           
           ctrl.linkFilter = 'People';
           ctrl.fetchMyLinks();
           
           ctrl.recommendedFilter = 'People';
           //ctrl.fetchRecommendedContent();
           
           //system.assert(ctrl.noRecordSection == false);
        }
    }
    
}