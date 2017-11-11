@isTest
public class BabsonTMControllerTest{
     @isTest static void test_validate() {
         
         
         BCTAC__c oBCTAC =  new BCTAC__c();
         oBCTAC.Community_Content_Status__c = 'Approved';
         oBCTAC.Title__c = 'tret';
         oBCTAC.body__c = 'trre';
         oBCTAC.Publish_Date__c = system.now();
         insert oBCTAC;
         
         BabsonTMController oBabsonTMController = new  BabsonTMController();
     
     }


}