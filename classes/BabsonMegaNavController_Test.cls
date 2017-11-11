@isTest
public with sharing class BabsonMegaNavController_Test {
    private static void setUpData() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();

        /* L2 Settings to power most of the navigation */
        AlumniCommunityL2Pages__c objAlumniSettings = objUtil.createAlumniL2Settings(); 
        insert objAlumniSettings; 
        /* Header Footer settings for a few additional links */
        CORECONNECT__CC_Header_Footer_Settings__c objHeaderFooterSettings = new CORECONNECT__CC_Header_Footer_Settings__c(Name = 'Alumni',CORECONNECT__Header_Link_1_Label__c = 'Label',CORECONNECT__Header_Link_1_URL__c = 'URL');
        insert objHeaderFooterSettings; 
    }
    
    static testMethod void myUnitTest() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson); /* */
            
        Account a = new Account(Name='Test Account Name');
       
        insert a;
        
       
            
        Contact c = new Contact(FirstName = 'Contact first Name',LastName = 'Contact Last Name', AccountId = a.id, companyName__c = 'Contact Last Name', public_companyName__c = true,
                                                     
                                                      Graduate_Preferred_Year__c = '2008',
                                                      Graduate_Year__c = '2009',
                                                      Certificate_Preferred_Year__c = '2009',
                                                      MobilePhone = '9999999999',
                                                      Certificate_Degree_Year__c = '2008',
                                                      Undergraduate_Year__c = '2008',
                                                      September__c = 'Home 1',
                                                      October__c = 'Home 1',
                                                      November__c = 'Home 1',
                                                      December__c = 'Home 1',
                                                      Preferred_Email__c = 'test@test.com');
        insert c;
        
        BabsonMegaNavController controller = new BabsonMegaNavController();
        
        controller.format('add');
        
        
        System.assertEquals('Label', controller.headerFooterSetting.CORECONNECT__Header_Link_1_Label__c);
        System.assertEquals('URL', controller.headerFooterSetting.CORECONNECT__Header_Link_1_URL__c);
    }
    static testMethod void myUnitTest1() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson); /* */
            
        Account a = new Account(Name='Test Account Name');
       
        insert a;
        
       
            
        Contact c = new Contact(FirstName = 'Contact first Name',LastName = 'Contact Last Name', AccountId = a.id, companyName__c = 'Contact Last Name', public_companyName__c = true,
                                                     
                                                      Graduate_Preferred_Year__c = '2008',
                                                      Graduate_Year__c = '2009',
                                                      Undergraduate_Preferred_Year__c = '2009',
                                                      Certificate_Preferred_Year__c = '2009',
                                                      MobilePhone = '9999999999',
                                                      Certificate_Degree_Year__c = '2008',
                                                      Undergraduate_Year__c = '2008',
                                                      September__c = 'Home 1',
                                                      October__c = 'Home 1',
                                                      November__c = 'Home 1',
                                                      December__c = 'Home 1',
                                                      Preferred_Email__c = 'test@test.com');
        insert c;
        
        BabsonMegaNavController controller = new BabsonMegaNavController();
        
        controller.format('add');
        
        
        System.assertEquals('Label', controller.headerFooterSetting.CORECONNECT__Header_Link_1_Label__c);
        System.assertEquals('URL', controller.headerFooterSetting.CORECONNECT__Header_Link_1_URL__c);
    }
     static testMethod void myUnitTest2() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson); /* */
            
        Account a = new Account(Name='Test Account Name');
       
        insert a;
        
       
            
        Contact c = new Contact(FirstName = 'Contact first Name',LastName = 'Contact Last Name', AccountId = a.id, companyName__c = 'Contact Last Name', public_companyName__c = true,
                                                     
                                                      Graduate_Preferred_Year__c = '2008',
                                                      Graduate_Year__c = '2009',
                                                      Certificate_Preferred_Year__c = '2009',
                                                      MobilePhone = '9999999999',
                                                      Certificate_Degree_Year__c = '2008',
                                                      September__c = 'Home 1',
                                                      October__c = 'Home 1',
                                                      November__c = 'Home 1',
                                                      December__c = 'Home 1',
                                                      Preferred_Email__c = 'test@test.com');
        insert c;
        
        BabsonMegaNavController controller = new BabsonMegaNavController();
        
        controller.format('add');
        
        
        System.assertEquals('Label', controller.headerFooterSetting.CORECONNECT__Header_Link_1_Label__c);
        System.assertEquals('URL', controller.headerFooterSetting.CORECONNECT__Header_Link_1_URL__c);
    }
     static testMethod void myUnitTest3() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson); /* */
            
        Account a = new Account(Name='Test Account Name');
       
        insert a;
        
       
            
        Contact c = new Contact(FirstName = 'Contact first Name',LastName = 'Contact Last Name', AccountId = a.id, companyName__c = 'Contact Last Name', public_companyName__c = true,
                                                     
                                                      Graduate_Preferred_Year__c = '2008',
                                                      Graduate_Year__c = '2009',
                                                      MobilePhone = '9999999999',
                                                      Certificate_Degree_Year__c = '2008',
                                                      September__c = 'Home 1',
                                                      October__c = 'Home 1',
                                                      November__c = 'Home 1',
                                                      December__c = 'Home 1',
                                                      Preferred_Email__c = 'test@test.com');
        insert c;
        
        BabsonMegaNavController controller = new BabsonMegaNavController();
        
        controller.format('add');
        
        
        System.assertEquals('Label', controller.headerFooterSetting.CORECONNECT__Header_Link_1_Label__c);
        System.assertEquals('URL', controller.headerFooterSetting.CORECONNECT__Header_Link_1_URL__c);
    }
     static testMethod void myUnitTest4() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson); /* */
            
        Account a = new Account(Name='Test Account Name');
       
        insert a;
        
       
            
        Contact c = new Contact(FirstName = 'Contact first Name',LastName = 'Contact Last Name', AccountId = a.id, companyName__c = 'Contact Last Name', public_companyName__c = true,
                                                     
                                                      Graduate_Preferred_Year__c = '2008',
                                                      MobilePhone = '9999999999',
                                                      Certificate_Degree_Year__c = '2008',
                                                      September__c = 'Home 1',
                                                      October__c = 'Home 1',
                                                      November__c = 'Home 1',
                                                      December__c = 'Home 1',
                                                      Preferred_Email__c = 'test@test.com');
        insert c;
        
        BabsonMegaNavController controller = new BabsonMegaNavController();
        
        controller.format('add');
        
        
        System.assertEquals('Label', controller.headerFooterSetting.CORECONNECT__Header_Link_1_Label__c);
        System.assertEquals('URL', controller.headerFooterSetting.CORECONNECT__Header_Link_1_URL__c);
    }
    
    static testMethod void myUnitTest5() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson); /* */
            
        Account a = new Account(Name='Test Account Name');
       
        insert a;
        
       
            
        Contact c = new Contact(FirstName = 'Contact first Name',LastName = 'Contact Last Name', AccountId = a.id, companyName__c = 'Contact Last Name', public_companyName__c = true,
                                                     
                                                      MobilePhone = '9999999999',
                                                      Certificate_Degree_Year__c = '2008',
                                                      September__c = 'Home 1',
                                                      October__c = 'Home 1',
                                                      November__c = 'Home 1',
                                                      December__c = 'Home 1',
                                                      Preferred_Email__c = 'test@test.com');
        insert c;
        
        BabsonMegaNavController controller = new BabsonMegaNavController();
        
        controller.format('add');
        
        
        System.assertEquals('Label', controller.headerFooterSetting.CORECONNECT__Header_Link_1_Label__c);
        System.assertEquals('URL', controller.headerFooterSetting.CORECONNECT__Header_Link_1_URL__c);
    }
    static testMethod void myUnitTest6() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson); /* */
            
        Account a = new Account(Name='Test Account Name');
       
        insert a;
        
       
            
        Contact c = new Contact(FirstName = 'Contact first Name',LastName = 'Contact Last Name', AccountId = a.id, companyName__c = 'Contact Last Name', public_companyName__c = true,
                                                     
                                                      Certificate_Preferred_Year__c = '2008',
                                                      MobilePhone = '9999999999',
                                                      Certificate_Degree_Year__c = '2008',
                                                      September__c = 'Home 1',
                                                      October__c = 'Home 1',
                                                      November__c = 'Home 1',
                                                      December__c = 'Home 1',
                                                      Preferred_Email__c = 'test@test.com');
        insert c;
        
        hed__Address__c obj = new hed__Address__c();
        obj.hed__Parent_Contact__c = c.id;
        obj.Address_Line_No__c = 'Home 1';
        obj.Mailing_Country__c = 'United States';
        insert obj;
        
        BabsonMegaNavController controller = new BabsonMegaNavController();
        
        controller.format('add');
        
        
        System.assertEquals('Label', controller.headerFooterSetting.CORECONNECT__Header_Link_1_Label__c);
        System.assertEquals('URL', controller.headerFooterSetting.CORECONNECT__Header_Link_1_URL__c);
    }
}