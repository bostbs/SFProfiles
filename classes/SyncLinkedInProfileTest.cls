@istest
public class SyncLinkedInProfileTest{

    @IsTest(SeeAllData=true) static void unitTest() {
        SyncLinkedInProfile oSyncLinkedInProfile = new SyncLinkedInProfile();
      
        oSyncLinkedInProfile.syncLinkedIn();
        oSyncLinkedInProfile.authorizeLinkedIn();
        CORECONNECT__CC_Community_Content__c oC = new CORECONNECT__CC_Community_Content__c();
        oSyncLinkedInProfile.blankCCObject(oc);
        oSyncLinkedInProfile.updateUser();
    
    }






}