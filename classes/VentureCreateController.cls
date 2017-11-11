public with sharing class VentureCreateController {
    
    
    public String ventureId {get;set;}
    public CORECONNECT__CC_Community_Content__c CC {get;set;}
    public Id addId {get;set;}
    public String mode{get;set;}
    list<VTAC__c>  lstVTAC ;
    public VTAC__c oVTAC {get;set;}
    public string body{get;set;}
    public string title{get;set;}
          
    public Attachment att {
        get{
             if (att == null)
                     att = new Attachment();
            return att;
        }
        set;
    }
    
    private Boolean isValid;
    
    public VentureCreateController() {
        ventureId = (ApexPages.currentPage().getParameters().containsKey('Id') && ApexPages.currentPage().getParameters().get('Id') != '') ? ApexPages.currentPage().getParameters().get('Id') : '';
        mode = ApexPages.currentPage().getParameters().get('mode');
        System.debug('@@@MODE --->'+ventureId);
        CC = new CORECONNECT__CC_Community_Content__c();
        if(String.isNotBlank(ventureId)) {
            try {
                CC = [SELECT Id, Name, CORECONNECT__Short_Description__c, CORECONNECT__Description__c, CORECONNECT__FreeText_Desired_Publish_Date__c, 
                        CORECONNECT__FreeText_End_Date__c, Default_Content__c, Trump_Content__c, CORECONNECT__Classification1__c, CORECONNECT__Classification2__c,
                        Affinities__c, Interests__c, Affiliation_1__c, Affiliation_2__c, Industry__c, Region__c, Source__c, Topic__c, Author__c, Backers__c, Pledged_Dollars__c,
                        Deadline__c, Alumni_Name_Affiliation__c, Additional_Team_Members__c, Founders_fund__c,Funding_Link__c, CORECONNECT__Classification3__c, ownerId, CORECONNECT__Community_Content_Status__c
                        FROM CORECONNECT__CC_Community_Content__c
                        WHERE Id =: ventureId];
            }
            catch(Exception e) {
                CC = new CORECONNECT__CC_Community_Content__c();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No record found'));
            }
            System.debug('cc-='+CC.Alumni_Name_Affiliation__c);
        }
        else
            cc.Founders_fund__c = true;
            
        if(ApexPages.CurrentPage().getParameters().get('clone') != null)
            cc.Founders_fund__c = true;
            
        if(CC.Alumni_Name_Affiliation__c == null){
            CC.Alumni_Name_Affiliation__c = userInfo.getName();
        }
        CC.RecordTypeId = [select Id from RecordType where DeveloperName = 'Venture'][0].id;
        
        lstVTAC  = new list<VTAC__c>();
        oVTAC  = new VTAC__c ();
        lstVTAC  = [SELECT Body__c,Community_Content_Status__c,End_Date__c,Publish_Date__c,Title__c FROM VTAC__c WHERE
                    Community_Content_Status__c =:'Approved' order by createdDate desc LIMIT 1];
                    
        if(lstVTAC.size()>0 && lstVTAC !=null){
            oVTAC  = lstVTAC[0];
            body =oVTAC.body__c;  
        title =  oVTAC.Title__c ;   
        }
          
        System.debug(' oVTAC  ++'+oVTAC  );
    }
    
    public PageReference goToVenturePage(){
        System.debug('CC.ownerId========='+cc);
        if(String.isNotBlank(ventureId)) {
            isValid = (ventureId InstanceOf ID) ? true : false ;
            System.debug('isValid========='+isValid);
            if(!isValid){
                    return Page.Ventures;
            }
            System.debug('mode========='+mode);
            System.debug('Page.VentureCreate.getURL()======='+Page.VentureEdit.getURL());
            if('edit'.equalsIgnoreCase(mode))
                return  new PageReference(Page.VentureEdit.getURL()+'?id='+ ventureId);
            else if(isValid && (CC.ownerId != UserInfo.getUserId() && CC.CORECONNECT__Community_Content_Status__c != 'Approved')){
                return  new PageReference(Page.VentureDetail.getURL()+'?id='+ ventureId);
            }
        }
        else
            cc.Founders_fund__c = true;
        return null;
    }
    
    public PageReference createVenture(){
        if(!validateForVenture()){
            return null;
        }
        CC.RecordTypeId = [select Id  from RecordType where DeveloperName = 'Venture' ] [0].id;
        User userContact = [Select contact.Affiliation_1__c,contact.Affiliation_2__c from user Where Id = :UserInfo.getUserId()];
        System.debug('userContact ==>>'+userContact.contact.Affiliation_1__c );
        System.debug('userContact ==>>22'+userContact.contact.Affiliation_2__c);
        if(userContact.contact.Affiliation_1__c!=null){
            cc.Affiliation_1__c = userContact.contact.Affiliation_1__c;
        }
        if(userContact.contact.Affiliation_2__c!=null){
            cc.Affiliation_2__c= userContact.contact.Affiliation_2__c;
        }
        
        
        
        if(String.isBlank(ventureId)) {
            return submit(Page.Ventures.getURL()+'?thankyou=true'); // page URl need to be changed
        }else{
            return submit(Page.Ventures.getURL()+'?thankyou=true&update=true'); // page URl need to be changed
        }
    }
    
    private PageReference submit(String ScheduledContentOrFreeText){
        System.debug('@@@ventureId'+ventureId);
        if(String.isBlank(ventureId)) {
            CC.CORECONNECT__Community_Content_Status__c = 'Created';
        }
        else{
            CC.CORECONNECT__Community_Content_Status__c = 'updated';   
        }
         
         if(!CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName()).CORECONNECT__Use_Approval_Process__c) CC.CORECONNECT__Community_Content_Status__c = 'Approved';

        // insert a record
        try{ 
             if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()){
                 upsert CC; 
                 
                 if(String.isBlank(ventureId) && CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName()).CORECONNECT__Use_Approval_Process__c){
                    //'edit'.equalsIgnoreCase(mode))
                    // Create an approval request
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    
                    req1.setObjectId(CC.Id);
            
                    // Submit the approval request
                    Approval.ProcessResult result = Approval.process(req1);
                    System.debug('@@result '+result );
                 }
                 addId = CC.Id;
                 
                 
             }
        }catch(DMLException de){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Save Error'));
            return null;

        }
     
        att.OwnerId = UserInfo.getUserId();
        att.ParentId = CC.Id; 

        if(att.body != null && att.ParentId != null){
            
            try {
                
                if(!Test.isRunningTest() && Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()) {
                    insert att;
                }
            } 
            catch (DMLException de) {
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Upload Error'));
                if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isDeletable()){
                    delete CC; 
                }
                CC = new CORECONNECT__CC_Community_Content__c();
                
                return null;
            } 
            finally {
                att = new Attachment();
            }
        }
        
        CC = new CORECONNECT__CC_Community_Content__c();
        att = new Attachment();
         
        return  new PageReference(ScheduledContentOrFreeText);
    }

    public PageReference cancelVenture(){
        
        CC = new CORECONNECT__CC_Community_Content__c();
        att = new Attachment();
        
        return Page.Ventures; // need to be changed
    }
    
    private Boolean validateForVenture(){
        
        Boolean val = true;
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Name)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Title_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Short_Description__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Article_Summary_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Description__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Full_Article_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Classification1__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Seeking Backers is required.'));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Classification2__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Seeking BETA Testers is required.')); 
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Classification3__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Seeking other help is required.')); 
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Alumni_Name_Affiliation__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Alumni Name Affiliation is required.')); 
            val = false;
            
        }
        
      /*   if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Additional_Team_Members__c)){
         
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Additional Team Member is required.')); 
            val = false;
        }*/
        
        if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c == null){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_publication_Required));
            val=false;
        }
        
        if(CC.CORECONNECT__FreeText_End_Date__c == null){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_Archive_Required));
            val=false;
        }
        
       if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c != null && (Date.today().daysBetween(CC.CORECONNECT__FreeText_Desired_Publish_Date__c) < 0 && String.isBlank(CC.Id))){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_publication_Old));
            val=false;
        }
        if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c != null && CC.CORECONNECT__FreeText_End_Date__c!=null &&  CC.CORECONNECT__FreeText_Desired_Publish_Date__c.daysBetween(CC.CORECONNECT__FreeText_End_Date__c) <= 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_Archive_Early));
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
}