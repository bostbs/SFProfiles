/*
    * ClassName    : JobDetailController
    * CreatedBy    : 7S
    * Description  : this is the Controller for JobDetail page.
*/
public with sharing class JobDetailController {
  
  public String GuestProfileName                     { get{  return CORECONNECT__CC_System_Settings__c.getInstance(Site.getName()).CORECONNECT__Guest_Profile_Name__c ;}}  
    //Updated to remove reference from custom setting header labels
    public String  HeaderLabel                       { get{  return ''; }}  
    public Id AttachmentId                         { get; set;}
    public Boolean isOwner                         { get; set;}
    
    private  CORECONNECT__CC_Community_Content__c currentCC;
    
    private void assignAttachmentId(){
      
         if(this.currentCC != null){
           
            List<Attachment> lisAtt = [select id from Attachment where ParentId = :currentCC.Id ORDER BY LastModifiedDate DESC];
            
            if(lisAtt.size() > 0)
                AttachmentId = lisAtt[0].Id;

        }
    }
    
    public JobDetailController(ApexPages.StandardController stdController) {
        
        CORECONNECT__CC_Community_Content__c objComCont = (CORECONNECT__CC_Community_Content__c)stdController.getRecord();
        
        if(objComCont.Id != null){
            
          this.currentCC = [  SELECT   Id, OwnerID, CORECONNECT__FreeText_End_Date__c, CORECONNECT__FreeText_Desired_Publish_Date__c, CORECONNECT__Community_Content_Status__c,Preferred_Start_Date__c,Work_Eligibility_Fields__c
                    FROM   CORECONNECT__CC_Community_Content__c 
                    WHERE   Id =: objComCont.Id];
        }
        
        assignAttachmentId();
        isOwner = determineOwner();
     }
    
    public PageReference SaveCurrentToCookie(){
       
       CORECONNECT.CC_CommunityUtil.SaveCurrentToCookie();
       if(this.currentCC.CORECONNECT__Community_Content_Status__c != 'Approved'){
           
            return new PageReference(Page.Jobs.getURL());
       }
       
       return null;
     }
     
     public boolean determineOwner(){
         Boolean isOwner = false;
        if (currentCC.OwnerID == UserInfo.getUserId()){
            isOwner = true;
        }
        return isOwner;
     }
}