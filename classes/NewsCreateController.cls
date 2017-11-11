public with sharing class NewsCreateController {
	
	public CORECONNECT__CC_Community_Content__c CC {
        get;set;
    }

    public Attachment att {
        get{
             if (att == null)
                     att = new Attachment();
            return att;
        }
        set;
    }
    
    public Id addId {get;set;}
    public String freeTextId {get;set;}
    
    private Boolean isValid;
    
	public NewsCreateController() {
		
		CC = new CORECONNECT__CC_Community_Content__c();
		freeTextId = (ApexPages.currentPage().getParameters().containsKey('Id') && ApexPages.currentPage().getParameters().get('Id') != '') ? ApexPages.currentPage().getParameters().get('Id') : '';
		
		if(String.isNotBlank(freeTextId)) {
			
		    try {
    		    CC = [  SELECT Id, Name, CORECONNECT__Short_Description__c, CORECONNECT__Description__c, CORECONNECT__FreeText_Desired_Publish_Date__c, 
    		            CORECONNECT__FreeText_End_Date__c, Default_Content__c, Trump_Content__c, CORECONNECT__Classification1__c, CORECONNECT__Classification2__c
    		            , Affinities__c, Industry__c, Region__c, Interests__c, Affiliation_1__c, Affiliation_2__c, Source__c, Topic__c, Author__c,CORECONNECT__Community_Content_Status__c,ownerId
    		            FROM CORECONNECT__CC_Community_Content__c
    		            WHERE Id =: freeTextId]; 
		    }
		    catch(Exception e) {
		    	
		        CC = new CORECONNECT__CC_Community_Content__c();
		        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No record found'));
		    }
		}
		
        CC.RecordTypeId = [select Id from RecordType where DeveloperName = 'FreeText' ] [0].id;
        
	}
	
	public PageReference goToNewsPage(){
		
		if(String.isNotBlank(freeTextId)) {
			
			isValid = (freeTextId InstanceOf ID) ? true : false ;
			
			if(!isValid){
			    
				return Page.News;
		    }else if(isValid && (CC.ownerId != UserInfo.getUserId() || CC.CORECONNECT__Community_Content_Status__c != 'Approved')){
			
				return  new PageReference(Page.NewsDetail.getURL()+'?id='+ freeTextId);
			    
		    }
		}
		return null;
	}
	
	public PageReference createFreeText(){
     	
     	if(!validateForFreeText()){
            return null;
        }
        
        CC.RecordTypeId = [select Id from RecordType where DeveloperName = 'FreeText' ] [0].id;
        
        return submit(Page.News.getURL()+'?thankyou=true');
      
    }
   
    private PageReference submit(String ScheduledContentOrFreeText){
        
         if(String.isBlank(freeTextId)) {
            CC.CORECONNECT__Community_Content_Status__c = 'Created';
         }
         if(!CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName()).CORECONNECT__Use_Approval_Process__c) CC.CORECONNECT__Community_Content_Status__c = 'Approved';

        // insert a record
        try{ 
             if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()){
                 upsert CC; 
                 
                 if(String.isBlank(freeTextId) && CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName()).CORECONNECT__Use_Approval_Process__c){
                 	
                 	// Create an approval request
			        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			        req1.setComments('Submitting request for approval.');
			        
			        req1.setObjectId(CC.Id);
			
			        // Submit the approval request
			        Approval.ProcessResult result = Approval.process(req1);
                 }
                 addId = CC.Id;
                 
                 /*insertNewTopic(addId);*/
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
            } catch (DMLException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Upload Error'));
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
         
        return  new PageReference(ScheduledContentOrFreeText);
    }

    public PageReference cancelFreeText(){
         CC = new CORECONNECT__CC_Community_Content__c();
         att = new Attachment();
        return Page.News;
    }
    
    private Boolean validateForFreeText(){
        
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
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Classification1_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Classification2__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_News_Create_Classification_2_Required)); 
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Source__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_News_Create_Source_Required)); 
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Topic__c)){
        	
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_News_Create_Topic_Required)); 
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
        
        if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c != null && Date.today().daysBetween(CC.CORECONNECT__FreeText_Desired_Publish_Date__c) < 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_publication_Old));
            val=false;
        }
        if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c != null && CC.CORECONNECT__FreeText_End_Date__c!=null &&  CC.CORECONNECT__FreeText_Desired_Publish_Date__c.daysBetween(CC.CORECONNECT__FreeText_End_Date__c) <= 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Date_Archive_Early));
            val=false;
        }
        
        if(!val){
            
            att = new Attachment();
        }
        return val;
    }
}