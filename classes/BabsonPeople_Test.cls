@isTest
private class BabsonPeople_Test {
    
    private static List<User> testCompanyCommunityUsers;
    
    
   

    @isTest static void  test_AllPeople1() {
        Test.startTest();
         CORECONNECT__CC_Community_Content__c occc = new CORECONNECT__CC_Community_Content__c();
         occc.title__c = 'Babson';
         occc.name = 'Babson';
         occc.City__c = 'Babson';
         occc.Function__c = 'Babson';
         //occc.State_Province__c = 'Alberta';
         occc.recordTypeid = '012360000019CFy';
         insert occc;
    
        BAB_TestUtil objTestUtil = new BAB_TestUtil();
        testCompanyCommunityUsers = objTestUtil.createCommunityUsersWithAffiliations(1);
        testCompanyCommunityUsers.add(objTestUtil.createSSFCommunityUser());
        
        BabsonPeopleController peopleCtrl = new BabsonPeopleController(); 
        List<BabsonPeopleController.WrapUser> tesUsers1 = peopleCtrl.ListOfUsers;
        
        System.runAs(testCompanyCommunityUsers[0]){
            
            List<BabsonPeopleController.WrapUser> tesUsers = peopleCtrl.ListOfUsers;
            
            
            peopleCtrl.SpecifiedPageNumber = 2;
            peopleCtrl.GoToPage();
            Integer tp = peopleCtrl.TotalPages;
            Integer sp = peopleCtrl.SpecifiedPageNumber;
            Boolean bNS = peopleCtrl.hasNextSet;
            Boolean bPS = peopleCtrl.hasPrevSet;
            Integer iPN = peopleCtrl.PageNumber;
            
            peopleCtrl.getGraduateYear();
            peopleCtrl.getBusinessState();
            peopleCtrl.getIndustry();
            peopleCtrl.getJobFunction();
            peopleCtrl.getBusinessCountry();
            peopleCtrl.getDegrees();
            peopleCtrl.getPrograme();
            peopleCtrl.getHomeCountry();
            peopleCtrl.getHomeState();
            peopleCtrl.getAdvJobFunction();
            peopleCtrl.getConstituency();
            peopleCtrl.queryPeopleString();
            peopleCtrl.search();
            
            peopleCtrl.strBusinessCountry='UNITES STATES';
            peopleCtrl.filterBusinessStates();
            
            peopleCtrl.strHomeCountry='UNITES STATES';
            peopleCtrl.filterStates();
            
            Test.stopTest();
        }
    }

     


    @isTest static void  test_AllPeople11() {
        Test.startTest();
        BAB_TestUtil objTestUtil = new BAB_TestUtil();
        testCompanyCommunityUsers = objTestUtil.createCommunityUsersWithAffiliations(1);
        testCompanyCommunityUsers.add(objTestUtil.createSSFCommunityUser());
        
        BabsonPeopleController peopleCtrl = new BabsonPeopleController();
        List<BabsonPeopleController.WrapUser> tesUsers1 = peopleCtrl.ListOfUsers;
        
        System.runAs(testCompanyCommunityUsers[0]){
            
            List<BabsonPeopleController.WrapUser> tesUsers = peopleCtrl.ListOfUsers;
            
            
            peopleCtrl.following = true;
            
            peopleCtrl.followingProfileIds(UserInfo.getUserId());
            tesUsers = peopleCtrl.ListOfUsers;
            peopleCtrl.strFname = 'c';
            peopleCtrl.strLname = 'c';
            peopleCtrl.strMname = 'c';
            peopleCtrl.strCompany = 'c';
            peopleCtrl.title = 'c';
            peopleCtrl.strCity = 'c';
            peopleCtrl.strBusinessState = 'c';
            peopleCtrl.strBusinessCountry = 'UNITED STATES';
            peopleCtrl.getBusinessState();
            peopleCtrl.strBusinessCountry = 'CANADA';
            peopleCtrl.getBusinessState();
            peopleCtrl.strJobFunction = 'c';
            peopleCtrl.strHomeCity = 'c';
            peopleCtrl.strHomeState = 'c';
            peopleCtrl.strHomeCountry = 'c';
            peopleCtrl.strArrayPrograme =  new String[]{'MBA'};
            peopleCtrl.strArrayGraduateYear = new String[]{'2008'};
            peopleCtrl.strArrayUnderGraduateYear = new String[]{'2008'};
            peopleCtrl.strArrayCertificationYear =new String[]{'2008'};
            peopleCtrl.bVentureBacker = true;
            peopleCtrl.strArrayConstituency = new String[]{'Alumni'};
            peopleCtrl.strArraydegree = new String[]{'MBA'};
            peopleCtrl.strArrayIndustry = new String[]{'retail'};
            peopleCtrl.searchString  = 'QA';
            peopleCtrl.adVancedSerach();
            peopleCtrl.prevSet();
            peopleCtrl.nextSet();
            Test.stopTest();
        }
    }
    
    
     @isTest static void  test_AllPeople12() {
        Test.startTest();
        BAB_TestUtil objTestUtil = new BAB_TestUtil();
        testCompanyCommunityUsers = objTestUtil.createCommunityUsersWithAffiliations(1);
        testCompanyCommunityUsers.add(objTestUtil.createSSFCommunityUser());
        
        BabsonPeopleController peopleCtrl = new BabsonPeopleController();
        List<BabsonPeopleController.WrapUser> tesUsers1 = peopleCtrl.ListOfUsers;
        
        System.runAs(testCompanyCommunityUsers[0]){
            
            List<BabsonPeopleController.WrapUser> tesUsers = peopleCtrl.ListOfUsers;
            
            
            peopleCtrl.following = true;
            
            peopleCtrl.followingProfileIds(UserInfo.getUserId());
            tesUsers = peopleCtrl.ListOfUsers;
            peopleCtrl.strFname = 'first';
            peopleCtrl.strLname = 'c';
            peopleCtrl.strMname = 'c';
            peopleCtrl.strCompany = 'c';
            peopleCtrl.title = 'c';
            peopleCtrl.strCity = 'c';
            peopleCtrl.strBusinessState = 'c';
            peopleCtrl.strBusinessCountry = 'c';
            peopleCtrl.strJobFunction = 'c';
            peopleCtrl.strHomeCity = 'c';
            peopleCtrl.strHomeState = 'c';
            peopleCtrl.strHomeCountry = 'c';
            peopleCtrl.strArrayPrograme =  new String[]{'MBA'};
            peopleCtrl.strArrayGraduateYear = new String[]{'2008'};
            peopleCtrl.strArrayUnderGraduateYear = new String[]{'2008'};
            peopleCtrl.strArrayCertificationYear =new String[]{'2008'};
            peopleCtrl.bVentureBacker = true;
            peopleCtrl.strArrayConstituency = new String[]{'Alumni'};
            peopleCtrl.strArraydegree = new String[]{'MBA'};
            peopleCtrl.strArrayIndustry = new String[]{'retail'};
            peopleCtrl.adVancedSerach();
            Test.stopTest();
        }
    }
}