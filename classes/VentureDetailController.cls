public with sharing class VentureDetailController {

  public string title{get; set;}
  public string body{get; set;}
  public boolean isDateExist{get; set;}
  public string contactId{get; set;}

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
  public VentureDetailController(ApexPages.StandardController stdController) {
    
    this.currentCC = (CORECONNECT__CC_Community_Content__c)stdController.getRecord();
    
        if(this.currentCC.Id !=null){
            
            this.currentCC = [  SELECT CORECONNECT__Start_Date__c, CORECONNECT__End_Date__c, CORECONNECT__FreeText_Desired_Publish_Date__c,CORECONNECT__FreeText_End_Date__c,
                                Default_Content__c, Trump_Content__c, CORECONNECT__Classification1__c, CORECONNECT__Classification2__c
                                , Affiliation_1__c, Backers__c, Pledged_Dollars__c, Affinities__c, Interests__c,
                            Deadline__c, Alumni_Name_Affiliation__c, CORECONNECT__Classification3__c,CORECONNECT__Community_Content_Status__c
                                FROM CORECONNECT__CC_Community_Content__c
                                WHERE ID =: this.currentCC.Id
                             ][0]; 
        }
        
        assignAttachmentId();
        
        list<VTAC__c> lstVTAC  = new list<VTAC__c>();
        VTAC__c oVTAC  = new VTAC__c ();
        lstVTAC  = [SELECT Body__c,Community_Content_Status__c,End_Date__c,Publish_Date__c,Title__c FROM VTAC__c WHERE
                    Community_Content_Status__c =:'Approved' order by Publish_Date__c desc LIMIT 1];
                    
        if(lstVTAC.size()>0 && lstVTAC !=null){
            oVTAC  = lstVTAC[0];
            body =oVTAC.body__c;  
            title =  oVTAC.Title__c ;   
        }
        User userContact = [Select contact.isVentureTermsAccepted__c,contact.id from user Where Id = :UserInfo.getUserId()];
            if(userContact.contact.isVentureTermsAccepted__c == true){
                isDateExist =true;
                
            }else{
                isDateExist =false;
                contactId = userContact.contact.Id;
            }
  }
  
   public void updateContactTermTimeStamp(){
        if(contactid!=null){
            contact con = new contact(id=contactid );
            System.debug('contactid ==='+con);
            con.isVentureTermsAccepted__c = true;
            con.Venture_Terms_Acceptance_Date__c = system.now();
            update con;
            
            isDateExist = true;
        }
    
    }
    public PageReference GoToList(){
        Set<String> setStatus = new Set<String>();
        List<String> lstStatus = new List<String>();
        String statusName = CORECONNECT__CC_System_Settings__c.getInstance('Alumni').Venture_Landing_Contenet_Status__c;
        if(!String.isBlank(statusName)){
           lstStatus = statusName.split(',');
           
           for(String str :  lstStatus){
               setStatus.add(str);
           }
        }
        if(this.currentCC.CORECONNECT__FreeText_End_Date__c<System.Today()){
            return Page.MyProfilePage;
        }
        if(!setStatus.contains(this.currentCC.CORECONNECT__Community_Content_Status__c)  ){
           
            return new PageReference(Page.Ventures.getURL());
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