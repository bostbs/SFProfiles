public with sharing class NewsDetailController {
	
	public Id AttachmentId {    
	    get; set;
	}      
	
	public String FreeTextPublishDate{
        get{
            String FreeTextPublishDate='';
            if(this.currentCC.CORECONNECT__FreeText_Desired_Publish_Date__c != null){
                
                DateTime publishDate = DateTime.newInstance(currentCC.CORECONNECT__FreeText_Desired_Publish_Date__c.year(),currentCC.CORECONNECT__FreeText_Desired_Publish_Date__c.month(),currentCC.CORECONNECT__FreeText_Desired_Publish_Date__c.day());
                FreeTextPublishDate = publishDate.format('MMMM d, yyyy');
            }
            return FreeTextPublishDate ;
        }
    }
    
    public String GuestProfileName  {    
	    get {    
	            return CORECONNECT__CC_System_Settings__c.getInstance(Site.getName()).CORECONNECT__Guest_Profile_Name__c ;
	        }
	}  
	
	/* Private Variables */
	private  CORECONNECT__CC_Community_Content__c currentCC;
	
	/* Constructor */
	public NewsDetailController(ApexPages.StandardController stdController) {
		
		this.currentCC = (CORECONNECT__CC_Community_Content__c)stdController.getRecord();
		
        if(this.currentCC.Id !=null){
            
            this.currentCC = [  SELECT CORECONNECT__Start_Date__c, CORECONNECT__End_Date__c, CORECONNECT__FreeText_Desired_Publish_Date__c,
                                Default_Content__c, Trump_Content__c, CORECONNECT__Classification1__c, CORECONNECT__Classification2__c
                                , Affinities__c, Interests__c, Affiliation_1__c, Author__c, Industry__c, Region__c, Source__c, Topic__c,CORECONNECT__Community_Content_Status__c
                                FROM CORECONNECT__CC_Community_Content__c 
                                WHERE ID =: this.currentCC.Id
                             ][0];  //
        }
        
        assignAttachmentId();
  }
  
  public PageReference goToList(){
       
       if(this.currentCC.CORECONNECT__Community_Content_Status__c != 'Approved'){
           
            return new PageReference(Page.News.getURL());
       }
       
       return null;
     }
  
  /* method to fetch attachment record based on current news record Id */
  private void assignAttachmentId(){
      
         if(this.currentCC != null){
             
            List<Attachment> lisAtt = [ SELECT id 
                                        FROM Attachment 
                                        WHERE ParentId = :currentCC.Id 
                                        ORDER BY LastModifiedDate DESC
                                      ];
                                      
            if(lisAtt.size() > 0){
                AttachmentId = lisAtt[0].Id;
            }
        }
    }
}