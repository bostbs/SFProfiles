/*
    * ClassName    : EventsController
    * CreatedBy    : 7S
    * Description  : this is the Controller for Events page.
*/
public with sharing class EventsController {
    
    public List<CORECONNECT__CC_Community_Content__c>   lstCommunityContent   {get; set;}
    public Map<String, String> mapOfCCToAttachId                            {get; set;}
    public Map<String, Boolean> mapCCIdToisAttachment                           {get; set;}
    private Map<Integer, String> mapOfContentPersonalization;            // Will store integer to Community Content field API name
    private Map<Integer, String> mapOfUserPersInfo;                      // Will store integer to User value based on custom setting info
    private AlumniCommunityPersonalization__c aluminiPersonal;           // to store aluminiPersonal custom setting instance
    private Map<Integer, String> mapOfUserPersonalization;               // Will store integer to User API name
    private Set<String> setOfRecommendedAttachmentCCId;                  // Set to store CC id to fetch attachment record
    private Set<String> setOfRecommendedCCId; 
    
    private final String communityUserId = [SELECT contactId 
                                            FROM User 
                                            WHERE id =: UserInfo.getUserId()].contactId;
    
    public String  AdminEmail {get{   return CORECONNECT__CC_System_Settings__c.getInstance(Site.getName()).CORECONNECT__Site_Admin_Email__c ;}}  

  public Timezone tz {get;private set;}
  public Boolean includePastScheduledContent {get;set;}
  public String orderScheduledContent {get;set;}
  
  public Boolean  isAutomatedfiltering {get{   return CORECONNECT__CC_System_Settings__c.getInstance(Site.getName()).CORECONNECT__Automated_Events_Filtering__c ;}set;} 
  
    public List<CORECONNECT.CC_CommunityContentWrapper> ListOfMoreScheduledContent {
        get{
               
                List<CORECONNECT__CC_Community_Content__c> lisCon = (List<CORECONNECT__CC_Community_Content__c>) setController.getRecords();
                ListOfMoreScheduledContent = new List<CORECONNECT.CC_CommunityContentWrapper>();
                for(CORECONNECT__CC_Community_Content__c cc: lisCon){
                    CORECONNECT.CC_CommunityContentWrapper ccw = new CORECONNECT.CC_CommunityContentWrapper();
                    ccw.CC = cc;
                    ListOfMoreScheduledContent.add(ccw);
                }
            
            return ListOfMoreScheduledContent;
        }
        set;
    }
    
    public String  DefaultAttachmentDocId {
      
      get{   
          if(AlumniCommunity__c.getInstance(Site.getName()).Default_News_Attachment_DocId__c != null){
              return AlumniCommunity__c.getInstance(Site.getName()).Default_News_Attachment_DocId__c;
          }
          else {
              return '';
          }
          
      }}


    /**
 
        add standard set controller
    */
    private final Integer PAGE_SIZE = 12;
    private final String BASE_QUERY = ' select id, Name, CORECONNECT__Location__c, CORECONNECT__Location_Street_1__c, CORECONNECT__Location_Street_2__c, CORECONNECT__Location_Street_3__c, ' +
                                      ' CORECONNECT__Location_City__c, CORECONNECT__Location_State_Province__c, CORECONNECT__Location_Country__c, CORECONNECT__Classification1__c, ' +
                                      ' CORECONNECT__Classification2__c, CORECONNECT__Start_Date__c, CORECONNECT__End_Date__c, CORECONNECT__Is_All_Day_ScheduledContent__c, ' +
                                      ' CORECONNECT__RSVP_Link__c from CORECONNECT__CC_Community_Content__c where RecordType.Name = \'ScheduledContent\' and ' +
                                      ' CORECONNECT__Community_Content_Status__c = \'Approved\'';
                                      
    private final String BASE_QUERY_NEAR_FUTURE = ' and CORECONNECT__Start_Date__c > Yesterday';
    private final String BASE_QUERY_ORDER_BY = ' order by CORECONNECT__Start_Date__c'; 
    private String QUERY; 
    
    public ApexPages.StandardSetController setController {
        get {
            if(setController == null) {
                //QueryLocator will throw LimitException more than 10,000
                //requeiment: Up to ten thousand auctions with various states of status 
                //in case more than 10,000 records exist LIMIT 10,000
                 
                setController = new ApexPages.StandardSetController(Database.getQueryLocator(QUERY));
               
            }
            setController.setPageSize(PAGE_SIZE);

            return setController;
        }
        set;
    }
    
    public EventsController() {
      
      aluminiPersonal = AlumniCommunityPersonalization__c.getInstance(Site.GetName());
       
      mapOfUserPersInfo = new Map<Integer, String>();
        mapOfCCToAttachId = new Map<String, String>();
        mapCCIdToisAttachment = new Map<String, Boolean>();
        setOfRecommendedAttachmentCCId = new Set<String>();
        setOfRecommendedCCId = new Set<String>();
        
        this.orderScheduledContent = 'ASC';
        
        tz = UserInfo.getTimeZone();
        this.includePastScheduledContent = false;
        lstCommunityContent = new List<CORECONNECT__CC_Community_Content__c> ();
        filter();
        entityPersonalAlumini();
        lstCommunityContent = fetchCommunityContent();
    }
  
  /* fetch Alumini Personalization information */
    private void entityPersonalAlumini() {
        
        mapOfContentPersonalization = new Map<Integer, String>{1 => aluminiPersonal.Content_Personalization_Field_1__c,
                                                               2 => aluminiPersonal.Content_Personalization_Field_2__c,
                                                               3 => aluminiPersonal.Content_Personalization_Field_3__c,
                                                               4 => aluminiPersonal.Content_Personalization_Field_4__c,
                                                               5 => aluminiPersonal.Content_Personalization_Field_5__c,
                                                               6 => aluminiPersonal.Content_Personalization_Field_6__c
                                                              };
       
        mapOfUserPersonalization = new Map<Integer, String>{1 => aluminiPersonal.User_Personalization_Field_1__c,
                                                            2 => aluminiPersonal.User_Personalization_Field_2__c,
                                                            3 => aluminiPersonal.User_Personalization_Field_3__c,
                                                            4 => aluminiPersonal.User_Personalization_Field_4__c,
                                                            5 => aluminiPersonal.User_Personalization_Field_5__c,
                                                            6 => aluminiPersonal.User_Personalization_Field_6__c
                                                           };
        
        
        for(Integer i = 1; i <= 6; i++) {
            
            if(mapOfUserPersonalization.get(i) == null) {
                mapOfUserPersInfo.put(i, null);
            }
            else {
                
                for(Contact contactInfo : Database.query(' SELECT Id, ' + mapOfUserPersonalization.get(i) + ' FROM Contact WHERE Id =: communityUserId ')){
                    mapOfUserPersInfo.put(i, (String)contactInfo.get(mapOfUserPersonalization.get(i)));
                }
            }
        }
        
        system.debug('mapOfUserPersInfo=========='+mapOfUserPersInfo);
    }
    
    /**
       Method for filters
    */
    
    public String ClassificationType2{
        get;set;
    }
    
    public String ClassificationType1{
        get;set;
    }
    
    public List<SelectOption> getClassificationValues2(){
         IF(Test.isRunningTest()){
                
            return new List<SelectOption>{new SelectOption('News','News'),new SelectOption('Events','Events')};
        }
    
        Schema.DescribeFieldResult fieldResult = CORECONNECT__CC_Community_Content__c.CORECONNECT__Classification2__c.getDescribe();
        return BAB_Util.htmlEscapeSelectOptions(CORECONNECT.CC_CommunityUtil.constPicklistValues(fieldResult, CORECONNECT.CC_CommunityConstants.ScheduledContent_COMMUNITY_CONTENT_RT_ID));
    }
    
    public List<SelectOption> getClassificationValues1(){
        
         IF(Test.isRunningTest()){
                
            return new List<SelectOption>{new SelectOption('News','News'),new SelectOption('Events','Events')};
        }
        
        Schema.DescribeFieldResult fieldResult = CORECONNECT__CC_Community_Content__c.CORECONNECT__Classification1__c.getDescribe();
        return BAB_Util.htmlEscapeSelectOptions(CORECONNECT.CC_CommunityUtil.constPicklistValues(fieldResult, CORECONNECT.CC_CommunityConstants.ScheduledContent_COMMUNITY_CONTENT_RT_ID));
    }
    
    public void Filter(){
        
        QUERY = BASE_QUERY;
        
        // When the Automated ScheduledContent Filtering is enable
        if(!isAutomatedfiltering) {
            
            if(!this.includePastScheduledContent)
              QUERY += BASE_QUERY_NEAR_FUTURE;
            
            if (ClassificationType2 != null && ClassificationType2 != ''){
              
                ClassificationType2 = String.escapeSingleQuotes(ClassificationType2);
                QUERY += ' and CORECONNECT__Classification2__c = \'' + ClassificationType2 + '\'';
            } 
            if (ClassificationType1 != null && ClassificationType1 != ''){
              
                ClassificationType1 = String.escapeSingleQuotes(ClassificationType1);
                QUERY += ' and CORECONNECT__Classification1__c = \'' + ClassificationType1 + '\'';
            } 
        }
        else {
            
            // Getting the user's classification fields when the Automated ScheduledContent Filterin is enable.
            List<User> lstUser = new List<User>([   SELECT   Id, Name, CORECONNECT__Classification1__c, 
                                    CORECONNECT__Classification2__c
                                                    FROM   USER 
                                                    WHERE   Id =: UserInfo.getUserId() LIMIT 1
                                                ]);
            
           if(!lstUser.isEmpty()){
               
               if(lstUser[0].CORECONNECT__Classification1__c != null && lstUser[0].CORECONNECT__Classification1__c != '') {
                   
                   QUERY += ' and CORECONNECT__Classification1__c = \'' + String.escapeSingleQuotes(lstUser[0].CORECONNECT__Classification1__c) + '\'';
               }
               if(lstUser[0].CORECONNECT__Classification2__c != null && lstUser[0].CORECONNECT__Classification2__c != '') {
                   
                   QUERY += ' and CORECONNECT__Classification2__c = \'' + String.escapeSingleQuotes(lstUser[0].CORECONNECT__Classification2__c) + '\'';
               }
           }
        }
        
        QUERY += BASE_QUERY_ORDER_BY + ' ' + this.orderScheduledContent;
       
        system.debug('QUERY============='+QUERY);
        setController = new ApexPages.StandardSetController(Database.getQueryLocator(QUERY));
        
    }

    /**

        Methods for pagenation
    */
 
    public Boolean hasNextSet {
        get {
            return setController.getHasNext();
        }
        set;
    }
 
    public Boolean hasPrevSet {
        get {
            return setController.getHasPrevious();
        }
        set;
    }
 
    public Integer PageNumber {
        get {
            return setController.getPageNumber();
        }
        set;
    }

    public Integer TotalPages{
            get{
                if(Math.mod(setController.getResultSize(),setController.getPageSize()) == 0){
                    return setController.getResultSize()/setController.getPageSize();
                }else{
                    return setController.getResultSize()/setController.getPageSize()+1; 
                } 

            }
    }
    
    public  Integer SpecifiedPageNumber{
        get;
        set;
    } 

    public void prevSet() {
            setController.previous();
    }
 
 
    public void nextSet() {
            setController.next();     
    }
 
    public void GoToPage () {
        
        if(SpecifiedPageNumber!=null){
            setController.setpageNumber(SpecifiedPageNumber);
        }
   }

   //for datetime format

   public String TodayString {
       get{
           return DateTime.now().format('EEEE, MMMM d');
       }
   }
   public void SaveCurrentToCookie(){
       CORECONNECT.CC_CommunityUtil.SaveCurrentToCookie();
   }
   
   /* 
        Generic Method: To fetch Tiles n information based on different filters fetched from CustomSetting.
    */
    private List<CORECONNECT__CC_Community_Content__c> fetchCommunityContent() {
        
        List<String> lstOfCCFieldAPIName = new List<String>();
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContent = new List<CORECONNECT__CC_Community_Content__c>();
        
        Map<String, List<CORECONNECT__CC_Community_Content__c>> mapFieldNameTolstCommunityContent = new Map<String, List<CORECONNECT__CC_Community_Content__c>>
                                            {  'Trump' => new List<CORECONNECT__CC_Community_Content__c>(),
                                                                        'personalization2' => new List<CORECONNECT__CC_Community_Content__c>(),
                                                                        'personalization3' => new List<CORECONNECT__CC_Community_Content__c>(),
                                                                        'personalization4' => new List<CORECONNECT__CC_Community_Content__c>(),
                                                                        'personalization5' => new List<CORECONNECT__CC_Community_Content__c>(),
                                                                        'personalization6'=> new List<CORECONNECT__CC_Community_Content__c>(),
                                                                        'personalization7'=> new List<CORECONNECT__CC_Community_Content__c>(),
                                                                        'default' => new List<CORECONNECT__CC_Community_Content__c>()
                                                                       };
        
        Set<String> setOfAPIName = new Set<String>();                                                         
        for(String str : mapOfContentPersonalization.values()) {
            
            if(str != null) {
                setOfAPIName.add(str);    
            }
        }
        lstOfCCFieldAPIName.addAll(setOfAPIName);
        
        String queryPart = '';
        
        String strFieldsForQuery = '';
        if(!lstOfCCFieldAPIName.isEmpty()) {
            strFieldsForQuery = ' , ' + String.join(lstOfCCFieldAPIName, ' , ');
        }
         
        //get list of the user personalisations
        Set<String> setPersonalisation1 =  String.isNotBlank(mapOfUserPersInfo.get(1)) ? new Set<String>(mapOfUserPersInfo.get(1).split(';')) : new Set<String>();
        Set<String> setPersonalisation2 =  String.isNotBlank(mapOfUserPersInfo.get(2)) ? new Set<String>(mapOfUserPersInfo.get(2).split(';')) : new Set<String>();
        Set<String> setPersonalisation3 =  String.isNotBlank(mapOfUserPersInfo.get(3)) ? new Set<String>(mapOfUserPersInfo.get(3).split(';')) : new Set<String>();
        Set<String> setPersonalisation4 =  String.isNotBlank(mapOfUserPersInfo.get(4)) ? new Set<String>(mapOfUserPersInfo.get(4).split(';')) : new Set<String>();
        Set<String> setPersonalisation5 =  String.isNotBlank(mapOfUserPersInfo.get(5)) ? new Set<String>(mapOfUserPersInfo.get(5).split(';')) : new Set<String>();
        Set<String> setPersonalisation6 =  String.isNotBlank(mapOfUserPersInfo.get(6)) ? new Set<String>(mapOfUserPersInfo.get(6).split(';')) : new Set<String>();
         
        String personalisation1 = String.isNotBlank(mapOfUserPersInfo.get(1)) ? String.escapeSingleQuotes(mapOfUserPersInfo.get(1)).replaceAll(';', '\',\'') : null;
        String personalisation2 = String.isNotBlank(mapOfUserPersInfo.get(2)) ? String.escapeSingleQuotes(mapOfUserPersInfo.get(2)).replaceAll(';', '\',\'') : null;
        String personalisation3 = String.isNotBlank(mapOfUserPersInfo.get(3)) ? String.escapeSingleQuotes(mapOfUserPersInfo.get(3)).replaceAll(';', '\',\'') : null;
        String personalisation4 = String.isNotBlank(mapOfUserPersInfo.get(4)) ? String.escapeSingleQuotes(mapOfUserPersInfo.get(4)).replaceAll(';', '\',\'') : null; 
        String personalisation5 = String.isNotBlank(mapOfUserPersInfo.get(5)) ? String.escapeSingleQuotes(mapOfUserPersInfo.get(5)).replaceAll(';', '\',\'') : null;
        String personalisation6 = String.isNotBlank(mapOfUserPersInfo.get(6)) ? String.escapeSingleQuotes(mapOfUserPersInfo.get(6)).replaceAll(';', '\',\'') : null;  
          
        String query = ' SELECT Id, Name, RecordType.Name, CORECONNECT__Short_Description__c, Default_Content__c, CORECONNECT__Community_Content_Status__c, CreatedDate, ' +
                       ' CORECONNECT__Start_Date__c, Trump_Content__c, CORECONNECT__End_Date__c, CORECONNECT__Location_City__c, CORECONNECT__Location_State_Province__c ' +
                       + strFieldsForQuery + ' FROM CORECONNECT__CC_Community_Content__c WHERE RecordType.Name = \'ScheduledContent\' AND ( ' + 
                       ((mapOfContentPersonalization.get(1) == null) ? ' ' : mapOfContentPersonalization.get(1) + ' includes (\''+ personalisation1 +'\') OR ') +
                       ((mapOfContentPersonalization.get(2) == null) ? ' ' : mapOfContentPersonalization.get(2) + ' includes (\''+ personalisation2 +'\') OR ') +
                       ((mapOfContentPersonalization.get(3) == null) ? ' ' : mapOfContentPersonalization.get(3) + ' includes (\''+ personalisation3 +'\') OR ') +
                       ((mapOfContentPersonalization.get(4) == null) ? ' ' : mapOfContentPersonalization.get(4) + ' includes (\''+ personalisation4 +'\') OR ') +
                       ((mapOfContentPersonalization.get(5) == null) ? ' ' : mapOfContentPersonalization.get(5) + ' includes (\''+ personalisation5 +'\') OR ') +
                       ((mapOfContentPersonalization.get(6) == null) ? ' ' : mapOfContentPersonalization.get(6) + ' includes (\''+ personalisation6 +'\') OR ') +
                       ' Default_Content__c = TRUE OR Trump_Content__c = TRUE ) AND CORECONNECT__Community_Content_Status__c = \'Approved\' AND' +
                       ' (CORECONNECT__Start_Date__c >= TODAY) ORDER BY Trump_Content__c DESC, CORECONNECT__Start_Date__c ASC LIMIT 200';        
        
        system.debug('query============'+query);
        
        Integer index = 0;
        for(CORECONNECT__CC_Community_Content__c commContent : Database.query(query)) {
            
            Set<String> setCCPersonalisation1 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(1)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(1))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation2 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(2)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(2))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation3 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(3)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(3))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation4 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(4)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(4))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation5 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(5)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(5))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation6 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(6)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(6))).split(';')) : new Set<String>();
            
            if(commContent.Trump_Content__c){
                
                mapFieldNameTolstCommunityContent.get('Trump').add(commContent);
                index++;
            }
              
            else if(mapOfContentPersonalization.get(1) != null && BAB_Util.doesContainsItemFromSet(setPersonalisation1,setCCPersonalisation1)
                && !commContent.Default_Content__c) {
                
                mapFieldNameTolstCommunityContent.get('personalization2').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(2) != null && BAB_Util.doesContainsItemFromSet(setPersonalisation2,setCCPersonalisation2)
                && !commContent.Default_Content__c) {
                
                mapFieldNameTolstCommunityContent.get('personalization3').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(3) != null && BAB_Util.doesContainsItemFromSet(setPersonalisation3,setCCPersonalisation3)
                && !commContent.Default_Content__c) {
                
                mapFieldNameTolstCommunityContent.get('personalization4').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(4) != null && BAB_Util.doesContainsItemFromSet(setPersonalisation4,setCCPersonalisation4)
                && !commContent.Default_Content__c) {
            
                mapFieldNameTolstCommunityContent.get('personalization5').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(5) != null && BAB_Util.doesContainsItemFromSet(setPersonalisation5,setCCPersonalisation5)
                && !commContent.Default_Content__c) {
            
                mapFieldNameTolstCommunityContent.get('personalization6').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(6) != null && BAB_Util.doesContainsItemFromSet(setPersonalisation6,setCCPersonalisation6)
                && !commContent.Default_Content__c) {
            
                mapFieldNameTolstCommunityContent.get('personalization7').add(commContent);
                index++;
            }
            
            else if(commContent.Default_Content__c) {
              
                mapFieldNameTolstCommunityContent.get('default').add(commContent);
                index++;
            }
            
            system.debug('index========'+index);
            if(index >= 8){
                
                break;
            }
        } 
        
        system.debug('mapFieldNameTolstCommunityContent================'+mapFieldNameTolstCommunityContent);
        
        for(String str : mapFieldNameTolstCommunityContent.keyset()){
          
          for(CORECONNECT__CC_Community_Content__c objCommunityContent : mapFieldNameTolstCommunityContent.get(str)){
            
            lstCommunityContent.add(objCommunityContent);
            setOfRecommendedAttachmentCCId.add(objCommunityContent.Id);
            
            if(lstCommunityContent.size() >= 8)
                break;
          }
          if(lstCommunityContent.size() >= 8)
              break;
        }
        
        if(!setOfRecommendedAttachmentCCId.isEmpty())
          fetchAttachment(setOfRecommendedAttachmentCCId);
          
        return lstCommunityContent;   
          
    }
    
    /* This is used to fetch all the attachments related to the list of community content fetched based on custom settings */
    private void fetchAttachment(Set<String> setOfRecommendedAttachmentCCId) {
        
        Set<String> setOfCCId = new Set<String>();
        setOfCCId.addAll(setOfRecommendedAttachmentCCId);
        
        for(Attachment attach : [SELECT id, ParentId FROM Attachment WHERE ParentId IN: setOfRecommendedAttachmentCCId ORDER BY CreatedDate DESC]) {
            
            if(!mapOfCCToAttachId.containsKey(attach.ParentId)) {
                
                mapOfCCToAttachId.put(attach.ParentId, attach.id); 
                setOfCCId.remove(attach.ParentId);
                mapCCIdToisAttachment.put(attach.ParentId, true);
            }
        }
        
        for(Id ccId : setOfCCId) {
            
            mapOfCCToAttachId.put(ccId, DefaultAttachmentDocId);     
            mapCCIdToisAttachment.put(ccId, false);
        }
    }
}