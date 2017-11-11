/*
    * ClassName    : EventDetailController
    * CreatedBy    : 7S
    * Description  : this is the Controller for EventDetail page.
*/
public with sharing class EventDetailController {
  
  public String GuestProfileName                     { get{  return CORECONNECT__CC_System_Settings__c.getInstance(Site.getName()).CORECONNECT__Guest_Profile_Name__c ;}}  
    //Updated to remove reference from custom setting header labels
    public String  HeaderLabel                       { get{  return ''; }}  
    public Id AttachmentId                         { get; set;}
    public Timezone  tz{get;set;}
    
    private  CORECONNECT__CC_Community_Content__c currentCC;
    
    public String ScheduledContentStartMonth{
                            get{
                              String startMonthFormated = '';
                        
                                if(this.currentCC.CORECONNECT__Start_Date__c != null)
                                    startMonthFormated =  currentCC.CORECONNECT__Start_Date__c.format('MMM');
                                    
                                return startMonthFormated;
                            }
                        }
    public String ScheduledContentEndMonth{
                          get{
                              String startMonthFormated = '';
                      
                              if(this.currentCC.CORECONNECT__End_Date__c != null)
                                  startMonthFormated =  currentCC.CORECONNECT__End_Date__c.format('MMM');
                                  
                              return startMonthFormated;
                          }
                      }
    public String ScheduledContentStartDate{
                          get{
                              String startDateFormated = '';
                             
                              if(this.currentCC.CORECONNECT__Start_Date__c != null)
                                  startDateFormated =  currentCC.CORECONNECT__Start_Date__c.format('d');
                            
                              return startDateFormated ;
                          }
                      }
    public String ScheduledContentEndDate{
                          get{
                              String startDateFormated = '';
                             
                              if(this.currentCC.CORECONNECT__End_Date__c != null)
                                  startDateFormated =  this.currentCC.CORECONNECT__End_Date__c.format('d');
                            
                              return startDateFormated ;
                          }
                      }
    public String ScheduledContentStartDateDiffDay{
                                get{
                                    if(this.currentCC.CORECONNECT__Start_Date__c !=null){
                                        
                                        return  this.currentCC.CORECONNECT__Start_Date__c.format('EEE MMM dd').toUpperCase();
                                    }return '';}
                              }
    public String ScheduledContentEndDateDiffDay{
                                get{
                                    if(this.currentCC.CORECONNECT__End_Date__c !=null){
                                        
                                        return  this.currentCC.CORECONNECT__End_Date__c.format('EEE MMM dd').toUpperCase() ;
                                    }return '';}
                            } 
    public String ScheduledContentStartTime{
                            get{
                                if(this.currentCC.CORECONNECT__Start_Date__c !=null){
                                    
                                    return  this.currentCC.CORECONNECT__Start_Date__c.format('h:mm a');
                                }return '';}
                           }
    public String ScheduledContentEndTime{
                          get{
                              if(this.currentCC.CORECONNECT__End_Date__c !=null){
                                  
                                  return  this.currentCC.CORECONNECT__End_Date__c.format('h:mm a');
                              }return '';}
                       }      
    public String ScheduledContentStartDayInMonth{
                              get{
                                  String startDayInMonth = '';
                          
                                  if(this.currentCC.CORECONNECT__Start_Date__c != null){
                                      startDayInMonth =  this.currentCC.CORECONNECT__Start_Date__c.format('E');
                                  }
                                  
                                  return startDayInMonth;
                              }
                          }
    public Integer ScheduledContentDaysBetweenStartEnd   {
                                  get {
                                    if(this.currentCC.CORECONNECT__Start_Date__c != null && this.currentCC.CORECONNECT__End_Date__c != null){
                                      return Integer.valueOf((this.currentCC.CORECONNECT__End_Date__c.getTime() - this.currentCC.CORECONNECT__Start_Date__c.getTime())/(1000*60*60*24)) + 1;
                                    }return 0;}
                                }
    public String ScheduledContentEndDayInMonth  {
                              get{
                                  String startDayInMonth = '';
                          
                                  if(this.currentCC.CORECONNECT__End_Date__c != null){
                                      startDayInMonth =  currentCC.CORECONNECT__End_Date__c.format('E');
                                  }
                                  
                                  return startDayInMonth;
                              }
                          }
    public String ScheduledContentStartMonthAndYear {
                                  get{
                                      if(this.currentCC.CORECONNECT__Start_Date__c !=null){
                                          
                                          return  this.currentCC.CORECONNECT__Start_Date__c.format('MMMM, yyyy')  ;
                                      }return '';}
                             }
    public String ScheduledContentEndMonthAndYear   {
                                  get{
                                      if(this.currentCC.CORECONNECT__End_Date__c !=null){
                                          
                                          return  this.currentCC.CORECONNECT__End_Date__c.format('MMMM, yyyy')  ;
                                      }return '';}
                             }

    
    private void assignAttachmentId(){
      
         if(this.currentCC != null){
           
            List<Attachment> lisAtt = [select id from Attachment where ParentId = :currentCC.Id ORDER BY LastModifiedDate DESC];
            
            if(lisAtt.size() > 0)
                AttachmentId = lisAtt[0].Id;

        }
    }
    
    public EventDetailController(ApexPages.StandardController stdController) {
        
        
        CORECONNECT__CC_Community_Content__c objComCont = (CORECONNECT__CC_Community_Content__c)stdController.getRecord();
        tz=UserInfo.getTimeZone();
        if(objComCont.Id != null){
            
          this.currentCC = [  SELECT   Id, CORECONNECT__End_Date__c, CORECONNECT__Start_Date__c, CORECONNECT__Community_Content_Status__c
                    FROM   CORECONNECT__CC_Community_Content__c 
                    WHERE   Id =: objComCont.Id];
        }
        
        assignAttachmentId();
     }
    
    public PageReference SaveCurrentToCookie(){
       
       CORECONNECT.CC_CommunityUtil.SaveCurrentToCookie();
       
       if(this.currentCC.CORECONNECT__Community_Content_Status__c != 'Approved'){
           
            return new PageReference(Page.Events.getURL());
       }
       
       return null;
     }
}