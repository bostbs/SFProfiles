public without sharing class BusinessDetailController {
  
    public Id AttachmentId {    
      get; set;
  }      
  
  /*public String FreeTextPublishDate{
        get{
            String FreeTextPublishDate='';
            if(this.currentCC.CORECONNECT__FreeText_Desired_Publish_Date__c != null){
                
                DateTime publishDate = DateTime.newInstance(currentCC.CORECONNECT__FreeText_Desired_Publish_Date__c.year(),currentCC.CORECONNECT__FreeText_Desired_Publish_Date__c.month(),currentCC.CORECONNECT__FreeText_Desired_Publish_Date__c.day());
                FreeTextPublishDate = publishDate.format('MMMM d, yyyy');
            }
            return FreeTextPublishDate ;
        }
    }*/
    
    public String GuestProfileName  {    
      get {    
              return CORECONNECT__CC_System_Settings__c.getInstance(Site.getName()).CORECONNECT__Guest_Profile_Name__c ;
          }
  }  
  
  /* Private Variables */
  private  CORECONNECT__CC_Community_Content__c currentCC;
  
  /* Constructor */
  public BusinessDetailController(ApexPages.StandardController stdController) {
    
    this.currentCC = (CORECONNECT__CC_Community_Content__c)stdController.getRecord();
    
        if(this.currentCC.Id !=null){
            
            this.currentCC = [  SELECT Name, Business_Summary__c, Business_Descriptions__c, CORECONNECT__FreeText_Desired_Publish_Date__c, CORECONNECT__FreeText_End_Date__c,
                                Default_Content__c, Trump_Content__c, CORECONNECT__Classification1__c, Business_Location_Classification_Filter__c, Business_Industry__c,
                                Affiliation_1__c, Affiliation_2__c, Affinities__c, Interests__c, Industry__c, Region__c, CORECONNECT__Location__c, Phone__c, Website__c,
                                Email__c ,My_Company_Discount__c,Part_Time__c,Function__c, ownerId,
                                Family_Business__c, Start_up__c, Matching_Gift_Company__c,  My_Company_Online__c, Publish_Business__c,
                                Discount_Coupon_Code__c, Address_1__c, Address_2__c, Address_3__c, City__c, State_Province__c, Postal_Code__c, Country__c
                                FROM CORECONNECT__CC_Community_Content__c 
                                WHERE ID =: this.currentCC.Id
                             ][0];
        }
     
        assignAttachmentId();
        mpStates = new Map<string,string>();       
        Schema.DescribeFieldResult fieldResult = hed__Address__c.Mailing_State__c.getDescribe();        
        for(Schema.PicklistEntry ple: fieldResult.getpicklistvalues()){     
            mpStates.put(ple.getvalue(),ple.getlabel());        
                
                    
        }    
  }
  public Map<String,string> mpStates{get;set;}
    
  public PageReference goToList(){
      
       if(this.currentCC.Publish_Business__c == false && this.currentCC.ownerId != UserInfo.getUserId()) {
           
            return new PageReference(Page.BusinessDirectory.getURL());
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