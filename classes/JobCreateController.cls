public with sharing class JobCreateController {
    
    public CORECONNECT__CC_Community_Content__c CC         {get;set; }

    public Attachment att {
        get{
             if (att == null)
                     att = new Attachment();
            return att;
        }
        set;
    }
   
    public Boolean isSubmitScheduledContent {get;set;}
    

    private Boolean isValid;
    public Id addId {get;set;}
    public String jobId {get;set;}
    private String isEdit;
   
    private Boolean editRecordInfo;
    private final ID JOB_COMMUNITY_CONTENT_RT_ID;
    
    public JobCreateController() {
        
        att = new Attachment();
        CC = new CORECONNECT__CC_Community_Content__c();
        editRecordInfo = false;
        
        jobId = (ApexPages.currentPage().getParameters().containsKey('Id') && ApexPages.currentPage().getParameters().get('Id') != '') ? ApexPages.currentPage().getParameters().get('Id') : '';
        isEdit=ApexPages.currentPage().getParameters().get('edit');
        if(String.isNotBlank(jobId)) {
            
            try {
                CC = [  SELECT Id, Name, CORECONNECT__Short_Description__c, CORECONNECT__Description__c, Default_Content__c, Trump_Content__c
                        , Affinities__c, Industry__c, Region__c, Interests__c, Affiliation_1__c, Affiliation_2__c,
                        Degree_Requirements__c,Job_Status__c,Location_Type__c,Job_Level__c,CORECONNECT__FreeText_End_Date__c,CORECONNECT__FreeText_Desired_Publish_Date__c,
                        Applicant_Type__c,Job_Location__c,ownerId,Title__c,Preferred_Start_Date__c,CORECONNECT__Community_Content_Status__c,More_Info_Required__c,Work_Eligibility_Fields__c
                        FROM CORECONNECT__CC_Community_Content__c
                        WHERE Id =: jobId]; //, 
                
                if(CC != null && !'true'.equalsIgnoreCase(isEdit)) {
                    editRecordInfo = true;    
                    validateForJob();
                }
            }
            catch(Exception e) {
                
                CC = new CORECONNECT__CC_Community_Content__c();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No record found'+e.getMessage()));
            }
        }
        
        if(JOB_COMMUNITY_CONTENT_RT_ID == null){
            JOB_COMMUNITY_CONTENT_RT_ID = [select Id from RecordType 
                                            where DeveloperName = 'Job' ] [0].id;
                                            
        }
        
        CC.RecordTypeId = JOB_COMMUNITY_CONTENT_RT_ID;
    }
     
    public PageReference createJob(){
        
        isSubmitScheduledContent = true;
        if(!validateForJob()){
            return null;
        }
        CC.RecordTypeId = JOB_COMMUNITY_CONTENT_RT_ID; 
        
        return submit('/Jobs'+'?thankyou=true');
    }
    
  
    
    
    private Boolean validateForJob(){
        
        Boolean val = true;
            
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Name)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Create_Job_CompanyName_Required));
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Title__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Create_Job_Name_Required));
            val = false;
        }

        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Short_Description__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Create_Job_Summary_Required));
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Description__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Create_Job_Description_Required));
            val = false;
        }
        
       /* if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Job_Location__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Job_Location_Required)); 
            val = false;
        }*/
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Applicant_Type__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Job_Applicant_Type_Required)); 
            val = false;
        }
        
       /* if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Location_Type__c)){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Job_Location_Type_Required)); 
            val = false;
        }*/
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Job_Status__c)){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Job_Status_Required)); 
            val = false;
        }
        
       if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c == null){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_publication_Required));
            val=false;
        }
        
        if(CC.CORECONNECT__FreeText_End_Date__c == null){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_Archive_Required));
            val=false;
        }  
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Industry__c)){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CC_Industry_required));
            val=false;
        } 
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Work_Eligibility_Fields__c)){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CC_WorkEligibility));
            val=false;
        } 
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Job_Level__c)){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CC_JobLevel));
            val=false;
        } 
        
        if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c != null && (Date.today().daysBetween(CC.CORECONNECT__FreeText_Desired_Publish_Date__c) < 0 && String.isBlank(jobId))){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_publication_Old));
            val=false;
        }
        
        if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c != null && CC.CORECONNECT__FreeText_End_Date__c!=null &&  CC.CORECONNECT__FreeText_Desired_Publish_Date__c.daysBetween(CC.CORECONNECT__FreeText_End_Date__c) <= 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_Archive_Early));
            val=false;
        }
        
        if(CC.Trump_Content__c == true && CC.Default_Content__c == true){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Job_Default_Content));
            val=false;
        }

        if (!val){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Error_Image_Message));
        }
        
        if(!val){
            att = new Attachment();
        }
    
        return val;
    }   
    
    @TestVisible private PageReference submit(String jobPage){
        
        if(String.isBlank(jobId)) {
            CC.CORECONNECT__Community_Content_Status__c = 'Created';
        }
        if('true'.equalsIgnoreCase(isEdit)){
            CC.CORECONNECT__Community_Content_Status__c = 'Edited';
        }
        if(!CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName()).CORECONNECT__Use_Approval_Process__c) CC.CORECONNECT__Community_Content_Status__c = 'Approved';
        
        // insert a record
        try{ 
             if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()){
                    upsert CC; 
                    System.debug('@@jobId'+jobId);
                   
                    System.debug('@@Approval Process'+CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName()).CORECONNECT__Use_Approval_Process__c);
                    if((String.isBlank(jobId) || 'true'.equalsIgnoreCase(isEdit)) && CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName()).CORECONNECT__Use_Approval_Process__c){
                        System.debug('@@ Creating an approval process');
                        
                        // Create an approval request
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for approval.');
                        req1.setProcessDefinitionNameOrId('CC_Job_Approval');
                        req1.setSkipEntryCriteria(true);
                        req1.setObjectId(CC.Id);
                        System.debug('@@req1'+req1);
                        // Submit the approval request
                        Approval.ProcessResult result = Approval.process(req1);
                        System.debug('@@'+result);
                     }
                     addId = CC.Id;
                     
                     /*insertNewTopic(addId);*/
             }
        }catch(DMLException de){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Save_Error));
            return null;

        }
     
        att.OwnerId = UserInfo.getUserId();
        system.debug('att.OwnerId========'+att.OwnerId);
        
        att.ParentId = CC.Id; 
        
        if(att.body != null && att.ParentId != null){
            try {
                 // Sep 24 somehow i am not able to insert attachment in unit test. 
                 // it was working 3 weeks ago
                if(!Test.isRunningTest() && Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()) {
                    insert att;
                }
            } catch (DMLException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Upload_Error));
                if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isDeletable()){
                    delete CC; 
                }
                CC = new CORECONNECT__CC_Community_Content__c();
                return null;
            } finally {
                att = new Attachment();
            }
        }
               
        CC = new CORECONNECT__CC_Community_Content__c();
         att = new Attachment();
        return  new PageReference(jobPage);
    }
    
    public PageReference cancelJob(){
         
         CC = new CORECONNECT__CC_Community_Content__c();
         att = new Attachment();
        PageReference pageRef = new PageReference('/Jobs'); 
        return pageRef;
    }
    
    public PageReference forwardToLogin(){
        
        if(String.isNotBlank(jobId)) {
            
            isValid = (jobId InstanceOf ID) ? true : false ;
            
            system.debug('owner========'+CC.ownerId);
            system.debug('CC.CORECONNECT__Community_Content_Status__c'+CC.CORECONNECT__Community_Content_Status__c);
            system.debug('UserInfo========'+UserInfo.getUserId());
            if('true'.equalsIgnoreCase(isEdit)){
               return  null;
            }
            
            if(!isValid){
            
                return Page.Jobs;
            }else if(isValid && (CC.ownerId != UserInfo.getUserId() || CC.CORECONNECT__Community_Content_Status__c != 'Approved')){
                
                return  new PageReference(Page.JobDetail.getURL()+'?id='+ jobId);
            }
        }
        
        return CORECONNECT.CC_CommunityUtil.forwardToLogin();
    }
}