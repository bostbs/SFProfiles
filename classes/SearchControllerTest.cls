@isTest
private class SearchControllerTest {
    
    List<User> testCompanyCommunityUsers;
    List<CORECONNECT__CC_Community_Content__c> listOfScheduledContent;
    List<CORECONNECT__CC_Community_Content__c> listOfFreeText;
    PageReference pageRef;
    SearchController  cont;
    String searchString = 'Testcom';
     
    List<CORECONNECT__CC_Community_Content__c> listOfVentures;
    List<CORECONNECT__CC_Community_Content__c> listOfJobs;
    List<CORECONNECT__CC_Community_Content__c> listOfBusinesses;
    BAB_TestUtil objBABUtil = new BAB_TestUtil();
    
    private void setUp(){
        pageRef = Page.Search;
        Test.setCurrentPage(pageRef);
        
        /*
        Create 
        -20 users
        -20 events
        -20 free text
        -20 group
        -20 Jobs
        -20 Ventures
        */
        testCompanyCommunityUsers = CORECONNECT.CC_CommunityTestUtil.createUsers(20, CORECONNECT.CC_CommunityConstants.COMPANY_COMMUNITY_PROFILE_NAME);
        listOfScheduledContent = CORECONNECT.CC_CommunityTestUtil.createCommuntyContent(20,CORECONNECT.CC_CommunityConstants.ScheduledContent_COMMUNITY_CONTENT_RT_NAME);
        listOfFreeText = CORECONNECT.CC_CommunityTestUtil.createCommuntyContent(20,CORECONNECT.CC_CommunityConstants.FREETEXT_COMMUNITY_CONTENT_RT_NAME);
        listOfVentures = objBABUtil.createCommunityContent(20,[select Id from RecordType where DeveloperName = 'Venture'][0].id,'Venture');
        listOfJobs = objBABUtil.createCommunityContent(20,[select Id from RecordType where DeveloperName = 'Job'][0].id,'Job');
        listOfBusinesses = objBABUtil.createCommunityContent(20,[select Id from RecordType where DeveloperName = 'Business'][0].id,'Business');
        listOfBusinesses[0].Publish_business__c =true;
        listOfBusinesses[1].Publish_business__c =true;
        listOfBusinesses[3].Publish_business__c =true;
        listOfBusinesses[13].Publish_business__c =true;
        upsert listOfBusinesses;
    }
    

    
    @isTest static void  testAll() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();

        System.runAs(test.testCompanyCommunityUsers[0]){
            test.pageRef.getParameters().put('SearchString',test.searchString);  
            test.cont = new SearchController();
            System.AssertEquals(60 , test.cont.lisOfCCForALL.size()); // TODO - why won't groups appear
        }
    }

    @isTest static void  testEmpty() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();

        System.runAs(test.testCompanyCommunityUsers[0]){
            test.cont = new SearchController();
            System.assert(test.cont.lisOfCCForALL.isEmpty()); // not searching, should not have any results
        }
    } 

    @isTest static void  testFreeText() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();

        System.runAs(test.testCompanyCommunityUsers[0]){
            test.pageRef.getParameters().put('SearchString',test.searchString );
            test.pageRef.getParameters().put('SearchType','FreeText' );  
            test.cont = new SearchController();
            System.AssertEquals(20 , test.cont.lisOfCCForALL.size());
        }
    }       
    
    @isTest static void  testScheduledContent() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();

        System.runAs(test.testCompanyCommunityUsers[0]){
            test.pageRef.getParameters().put('SearchString',test.searchString );
            test.pageRef.getParameters().put('SearchType','ScheduledContent' );  
            test.cont = new SearchController();
            System.AssertEquals(20 , test.cont.lisOfCCForALL.size());
        }
    }
    
    @isTest static void  testPeople() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();

        System.runAs(test.testCompanyCommunityUsers[0]){
            test.pageRef.getParameters().put('SearchString',test.searchString );
            test.pageRef.getParameters().put('SearchType','People' );  
            test.cont = new SearchController();
            System.AssertEquals(20 , test.cont.lisOfCCForALL.size());
        }
    }
    
    @isTest static void  testGroup() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();
        BAB_TestUtil objBABTestUtil = new BAB_TestUtil();
        
        System.runAs(test.testCompanyCommunityUsers[0]){
            
            List<CollaborationGroup> listOfGroups = objBABTestUtil.createGroups(20, CORECONNECT.CC_CommunityConstants.NETWORK_ID);
            test.pageRef.getParameters().put('SearchString', 'test');
            test.pageRef.getParameters().put('SearchType','Group' );  
            test.cont = new SearchController();
            System.AssertEquals(20 , test.cont.lisOfCCForALL.size()); // TODO - why does this return 0
        } 
    }
    
    @isTest static void  testFiles() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();
        BAB_TestUtil objBABTestUtil = new BAB_TestUtil();
         
        System.runAs(test.testCompanyCommunityUsers[0]){
            List<ContentVersion> listOfFiles = objBABTestUtil.createContentVersionFiles(20, CORECONNECT.CC_CommunityConstants.NETWORK_ID);
            test.pageRef.getParameters().put('SearchString','test');
            test.pageRef.getParameters().put('SearchType','File' );  
            test.cont = new SearchController();
            System.AssertEquals(20 , test.cont.lisOfCCForALL.size()); // TODO - why does this return 0
        } 
    }
    
     @isTest static void  testVentures() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();

        System.runAs(test.testCompanyCommunityUsers[0]){
            test.pageRef.getParameters().put('SearchString','venture');
            test.pageRef.getParameters().put('SearchType','Venture' );  
            test.cont = new SearchController();
            System.AssertEquals(20 , test.cont.lisOfCCForALL.size());
        }
    }       
    
    @isTest static void  testJobs() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();

        System.runAs(test.testCompanyCommunityUsers[0]){
            test.pageRef.getParameters().put('SearchString','job');
            test.pageRef.getParameters().put('SearchType','Job' );  
            test.cont = new SearchController();
            System.AssertEquals(20 , test.cont.lisOfCCForALL.size());
        }
    }

    @isTest static void  testBusinesses() {
        SearchControllerTest test = new SearchControllerTest();
        test.setUp();

        System.runAs(test.testCompanyCommunityUsers[0]){
            test.pageRef.getParameters().put('SearchString','Business');
            test.pageRef.getParameters().put('SearchType','Businesses' );  
            test.cont = new SearchController();
            //System.AssertEquals(4 , test.cont.lisOfCCForALL.size());
        }
    }
}