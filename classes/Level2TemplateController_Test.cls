@isTest
private class Level2TemplateController_Test {
    
    private static void setUpData() {
        
        BAB_TestUtil objUtil = new BAB_TestUtil();

        AlumniCommunityL2Pages__c objAlumniSettings = objUtil.createAlumniL2Settings(); 
        insert objAlumniSettings; 
        CORECONNECT__CC_Header_Footer_Settings__c cf=objUtil.createHeaderFooterSettings();
        insert cf;
    }
    
    static testMethod void myUnitTest() {
        
        setUpData();
        
        PageReference pageRefBabson = new PageReference('/apex/connectwithbabson');
        Test.setCurrentPage(pageRefBabson);
        
        Level2TemplateController levelCont1 = new Level2TemplateController();
       
        PageReference pageRefAlumni = new PageReference('/apex/connectwithalumni');
        Test.setCurrentPage(pageRefAlumni);
        
        Level2TemplateController levelCont2 = new Level2TemplateController();
        
        PageReference pageRefGTB = new PageReference('/apex/givetobabson');
        Test.setCurrentPage(pageRefGTB);
        
        Level2TemplateController levelCont3 = new Level2TemplateController();
        
        PageReference pageRefGI = new PageReference('/apex/getinvolved');
        Test.setCurrentPage(pageRefGI);
        
        Level2TemplateController levelCont4 = new Level2TemplateController();
        
    }

}