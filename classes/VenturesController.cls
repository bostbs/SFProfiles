public with sharing class VenturesController {
    
    public List<CORECONNECT__CC_Community_Content__c>   lstCommunityContent   {get; set;}
    public Map<String, String> mapOfCCToAttachId                            {get; set;}
    public Map<String, Boolean> mapCCIdToisAttachment                           {get; set;}
    public boolean  isVentureUpdated {get;set;}
    public boolean isDateExist {get;set;}
    list<VTAC__c>  lstVTAC ;
    public VTAC__c oVTAC {get;set;}
    public string body{get;set;}
    public string title{get;set;}
    id contactid;
  
  public String  DefaultAttachmentDocId {
      
      get{   
          if(AlumniCommunity__c.getInstance(Site.getName()).Default_News_Attachment_DocId__c != null){
              return AlumniCommunity__c.getInstance(Site.getName()).Default_News_Attachment_DocId__c;
          }
          else {
              return '';
          }
          
      }} 
  
    public String  AdminEmail {get{   return CORECONNECT__CC_System_Settings__c.getInstance(Site.getName()).CORECONNECT__Site_Admin_Email__c ;}}  
    
    public Boolean  isAutomatedfiltering {get{   return CORECONNECT__CC_System_Settings__c.getInstance(Site.getName()).CORECONNECT__Automated_News_Filtering__c ;}set;} 
    private Boolean is_SSF_User = BAB_Util.is_SSFUser();

    public List<CC_CommunityContentWrapper> ListOfMoreVenture {
        get{
                
            Map<Id, CC_CommunityContentWrapper> mapOfCommunityContentId = new Map<Id, CC_CommunityContentWrapper>();
            List<CORECONNECT__CC_Community_Content__c> lisCon = (List<CORECONNECT__CC_Community_Content__c>) setController.getRecords();
            ListOfMoreVenture = new List<CC_CommunityContentWrapper>();
            
            for(CORECONNECT__CC_Community_Content__c cc: lisCon){
                CC_CommunityContentWrapper ccw = new CC_CommunityContentWrapper();
                ccw.CC = cc;
                ListOfMoreVenture.add(ccw);
                mapOfCommunityContentId.put(cc.Id, ccw);
            }
            
            List<Attachment> lisAtt = [ select Id, ParentId
                                        from Attachment
                                        where ParentId in :mapOfCommunityContentId.keySet()];
            for(Attachment a: lisAtt){
                mapOfCommunityContentId.get(a.ParentId).AttachmentId = a.Id;
            }
                
            return ListOfMoreVenture;
            
        }
        set;
    }
    
    private Map<Integer, String> mapOfContentPersonalization;            // Will store integer to Community Content field API name
    private Map<Integer, String> mapOfUserPersInfo;                      // Will store integer to User value based on custom setting info
    private AlumniCommunityPersonalization__c aluminiPersonal;           // to store aluminiPersonal custom setting instance
    private Map<Integer, String> mapOfUserPersonalization;               // Will store integer to User API name
    private Set<String> setOfRecommendedAttachmentCCId;                  // Set to store CC id to fetch attachment record
    private Set<String> setOfRecommendedCCId;                            // Set to store CC id 
    private String ventureRTId;
    
    
    private final String communityUserId = [SELECT contactId 
                                            FROM User
                                            WHERE Id =: UserInfo.getUserId()].contactId;         // Store community User Id
    
    /**
        add standard set controller
    */
    private final Integer PAGE_SIZE = 12;
      // Testing time based work flow to set to Expired. If works switch to this
    //private final String BASE_QUERY = 'select id, Name, Short_Description__c, CreatedDate from CC_Community_Content__c where RecordType.Name = \'FreeText\' and Community_Content_Status__c = \'Approved\' and FreeText_Desired_Publish_Date__c < TOMORROW';
    
    private final String BASE_QUERY = 'select id, Name, CORECONNECT__FreeText_Desired_Publish_Date__c, CORECONNECT__Short_Description__c, CreatedDate from CORECONNECT__CC_Community_Content__c where RecordType.Name = \'Venture\' and (CORECONNECT__Community_Content_Status__c = \'Approved\' or CORECONNECT__Community_Content_Status__c = \'updated\') and CCC_Id__c =null and CORECONNECT__FreeText_Desired_Publish_Date__c < TOMORROW and CORECONNECT__FreeText_End_Date__c > YESTERDAY ';
    
    private final String BASE_QUERY_ORDER_BY = ' order by CORECONNECT__FreeText_Desired_Publish_Date__c DESC';
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
    
    public VenturesController() {
        
        aluminiPersonal = AlumniCommunityPersonalization__c.getInstance(Site.GetName()); 
        mapOfUserPersInfo = new Map<Integer, String>();
        mapOfCCToAttachId = new Map<String, String>();
        mapCCIdToisAttachment = new Map<String, Boolean>();
        setOfRecommendedAttachmentCCId = new Set<String>();
        setOfRecommendedCCId = new Set<String>();
        ventureRTId = '';
        lstCommunityContent = new List<CORECONNECT__CC_Community_Content__c> ();  
        
        if(QUERY == null){
             QUERY = BASE_QUERY + BASE_QUERY_ORDER_BY;
        }
        ventureRTId = [select Id from RecordType where DeveloperName = 'Venture'][0].id;
        
        Filter();
        entityPersonalAlumini();
        lstCommunityContent = fetchCommunityContent();
        
        if( Apexpages.currentPage().getUrl().contains('update')){
            isVentureUpdated = true;
        }else{
            isVentureUpdated = false;
        }
          lstVTAC  = new list<VTAC__c>();
        oVTAC  = new VTAC__c ();
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
                contactid = userContact.contact.id;
            }
       
            
    }
    
    public void updateContactTermTimeStamp(){
        if(contactid!=null){
            contact con = new contact(id=contactid );
            System.debug('contactid ==='+con);
            con.isVentureTermsAccepted__c = true;
            con.Venture_Terms_Acceptance_Date__c = system.now();
            update con;
        }
    
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
    }
    
    /* 
        Generic Method: To fetch Tiles n information based on different filters fetched from CustomSetting.
    */
    private List<CORECONNECT__CC_Community_Content__c> fetchCommunityContent() {
        
        List<String> lstOfCCFieldAPIName = new List<String>();
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContent = new List<CORECONNECT__CC_Community_Content__c>();
        
        Map<String, List<CORECONNECT__CC_Community_Content__c>> mapFeildNameTolstCommunityContent = new Map<String, List<CORECONNECT__CC_Community_Content__c>>
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
         
        String query = ' SELECT Id, Name, RecordType.Name, CORECONNECT__Short_Description__c, Default_Content__c, CORECONNECT__Community_Content_Status__c, CreatedDate, ' +
                       ' CORECONNECT__Start_Date__c, Trump_Content__c, CORECONNECT__End_Date__c, CORECONNECT__Location_City__c, CORECONNECT__Location_State_Province__c ' +
                       + strFieldsForQuery + ' FROM CORECONNECT__CC_Community_Content__c WHERE RecordType.Name = \'Venture\' AND ( ' ;
        
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
        
        IF(!is_SSF_User){
            
            query = query + 
                   ((mapOfContentPersonalization.get(1) == null) ? ' ' : mapOfContentPersonalization.get(1) + ' includes (\''+ personalisation1 +'\') OR ') +
                   ((mapOfContentPersonalization.get(2) == null) ? ' ' : mapOfContentPersonalization.get(2) + ' includes (\''+ personalisation2 +'\') OR ') +
                   ((mapOfContentPersonalization.get(3) == null) ? ' ' : mapOfContentPersonalization.get(3) + ' includes (\''+ personalisation3 +'\') OR ') +
                   ((mapOfContentPersonalization.get(4) == null) ? ' ' : mapOfContentPersonalization.get(4) + ' includes (\''+ personalisation4 +'\') OR ') +
                   ((mapOfContentPersonalization.get(5) == null) ? ' ' : mapOfContentPersonalization.get(5) + ' includes (\''+ personalisation5 +'\') OR ') +
                   ((mapOfContentPersonalization.get(6) == null) ? ' ' : mapOfContentPersonalization.get(6) + ' includes (\''+ personalisation6 +'\') OR ');
                    
            
        }
        
         query = query + ' Default_Content__c = TRUE OR Trump_Content__c = TRUE ) AND (CORECONNECT__Community_Content_Status__c = \'Approved\' OR CORECONNECT__Community_Content_Status__c = \'updated\') AND CCC_Id__c =null AND  (CORECONNECT__FreeText_Desired_Publish_Date__c < TOMORROW AND CORECONNECT__FreeText_End_Date__c > YESTERDAY) ORDER BY Trump_Content__c DESC, LastModifiedDate DESC LIMIT 200';  
                       
       system.debug('=====ventures query========'+query);
        
        Integer index = 0;
        for(CORECONNECT__CC_Community_Content__c commContent : Database.query(query)) {
            
            Set<String> setCCPersonalisation1 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(1)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(1))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation2 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(2)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(2))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation3 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(3)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(3))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation4 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(4)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(4))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation5 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(5)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(5))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation6 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(6)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(6))).split(';')) : new Set<String>();
            
            if(commContent.Trump_Content__c){
                
                mapFeildNameTolstCommunityContent.get('Trump').add(commContent);
                index++;
            }
              
            else if(mapOfContentPersonalization.get(1) != null && !commContent.Default_Content__c && !is_SSF_User && BAB_Util.doesContainsItemFromSet(setPersonalisation1,setCCPersonalisation1)) {
                
                mapFeildNameTolstCommunityContent.get('personalization2').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(2) != null && !commContent.Default_Content__c && !is_SSF_User && BAB_Util.doesContainsItemFromSet(setPersonalisation2,setCCPersonalisation2)) {
                
                mapFeildNameTolstCommunityContent.get('personalization3').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(3) != null && !commContent.Default_Content__c && !is_SSF_User && BAB_Util.doesContainsItemFromSet(setPersonalisation3,setCCPersonalisation3)) {
                
                mapFeildNameTolstCommunityContent.get('personalization4').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(4) != null && !commContent.Default_Content__c && !is_SSF_User && BAB_Util.doesContainsItemFromSet(setPersonalisation4,setCCPersonalisation4)) {
            
                mapFeildNameTolstCommunityContent.get('personalization5').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(5) != null && !commContent.Default_Content__c && !is_SSF_User && BAB_Util.doesContainsItemFromSet(setPersonalisation5,setCCPersonalisation5)) {
            
                mapFeildNameTolstCommunityContent.get('personalization6').add(commContent);
                index++;
            }
            
            else if(mapOfContentPersonalization.get(6) != null && !commContent.Default_Content__c && !is_SSF_User && BAB_Util.doesContainsItemFromSet(setPersonalisation6,setCCPersonalisation6)) {
            
                mapFeildNameTolstCommunityContent.get('personalization7').add(commContent);
                index++;
            }
            
            else if(commContent.Default_Content__c) {
              
                mapFeildNameTolstCommunityContent.get('default').add(commContent);
                index++;
            }
            
            system.debug('index========'+index);
            if(index >= 8){
                
                break;
            }
        } 
        
        System.debug('mapFeildNameTolstCommunityContent================'+mapFeildNameTolstCommunityContent);
        
        for(String str : mapFeildNameTolstCommunityContent.keyset()){
          
          for(CORECONNECT__CC_Community_Content__c objCommunityContent : mapFeildNameTolstCommunityContent.get(str)){
            
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
    
    /** 
     
     methods for filter
    */
    
    
    public List<SelectOption> getClassification1Values(){
        
        IF(Test.isRunningTest()){
            
            return new List<SelectOption>{new SelectOption('News','News'),new SelectOption('Events','Events')};
        }
    
        Schema.DescribeFieldResult fieldResult = CORECONNECT__CC_Community_Content__c.CORECONNECT__Classification1__c.getDescribe();
        return BAB_Util.htmlEscapeSelectOptions(CORECONNECT.CC_CommunityUtil.constPicklistValues(fieldResult, ventureRTId));
    }
    
    public List<SelectOption> getClassificationValues2(){
        
        IF(Test.isRunningTest()){
            
            return new List<SelectOption>{new SelectOption('News','News'),new SelectOption('Events','Events')};
        }    
        
        Schema.DescribeFieldResult fieldResult = CORECONNECT__CC_Community_Content__c.CORECONNECT__Classification2__c.getDescribe();
        return BAB_Util.htmlEscapeSelectOptions(CORECONNECT.CC_CommunityUtil.constPicklistValues(fieldResult, ventureRTId));
    }
    
    public List<SelectOption> getClassificationValues3(){
        
        IF(Test.isRunningTest()){
            
            return new List<SelectOption>{new SelectOption('News','News'),new SelectOption('Events','Events')};
        }
        Schema.DescribeFieldResult fieldResult = CORECONNECT__CC_Community_Content__c.CORECONNECT__Classification3__c.getDescribe();
        return BAB_Util.htmlEscapeSelectOptions(CORECONNECT.CC_CommunityUtil.constPicklistValues(fieldResult, ventureRTId));
    }
    
    public String Classification1{
        get;set;
    }
    
    public String ClassificationType2{
        get;set;
    }
    
    public String ClassificationType3{
        get;set;
    }
    
    public void Filter(){
        
        QUERY = BASE_QUERY;
        
        // When Automated Filtering is enable
        if(!isAutomatedfiltering) {
            
            if (Classification1 != null && Classification1 != ''){
                Classification1 = String.escapeSingleQuotes(Classification1);
                QUERY += ' and CORECONNECT__Classification1__c = \'' + Classification1 + '\'';
            } 
            
            if (ClassificationType2 != null && ClassificationType2 != ''){
                ClassificationType2 = String.escapeSingleQuotes(ClassificationType2);
                QUERY += ' and CORECONNECT__Classification2__c = \'' + ClassificationType2 + '\'';
            } 
            
            if (ClassificationType3 != null && ClassificationType3 != ''){
                ClassificationType3 = String.escapeSingleQuotes(ClassificationType3);
                QUERY += ' and CORECONNECT__Classification3__c = \'' + ClassificationType3 + '\'';
            } 
        }
        else {
            
            List<User> lstUser = new List<User>([   SELECT Id, Name, CORECONNECT__Classification1__c, CORECONNECT__Classification2__c, CORECONNECT__Classification3__c 
                                                    FROM USER 
                                                    WHERE Id =: UserInfo.getUserId() 
                                                    LIMIT 1
                                                ]);
            
           if(!lstUser.isEmpty()){
               
               if(lstUser[0].CORECONNECT__Classification1__c != null && lstUser[0].CORECONNECT__Classification1__c != '') {
                   
                   QUERY += ' and CORECONNECT__Classification1__c = \'' + String.escapeSingleQuotes(lstUser[0].CORECONNECT__Classification1__c) + '\'';
               }
               if(lstUser[0].CORECONNECT__Classification2__c != null && lstUser[0].CORECONNECT__Classification2__c != '') {
                   
                   QUERY += ' and CORECONNECT__Classification2__c = \'' + String.escapeSingleQuotes(lstUser[0].CORECONNECT__Classification2__c) + '\'';
               }
               if(lstUser[0].CORECONNECT__Classification3__c != null && lstUser[0].CORECONNECT__Classification3__c != '') {
                   
                   QUERY += ' and CORECONNECT__Classification3__c = \'' + String.escapeSingleQuotes(lstUser[0].CORECONNECT__Classification3__c) + '\'';
               }
           }
        }
        
        
        QUERY += BASE_QUERY_ORDER_BY;
        
       
        // refresh setController
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
   
   //Date format for today
   public String TodayString {
       get{
           return DateTime.now().format('EEEE, MMMM d');
       }
   }
   
   /**
        login logic
    */ 
    public PageReference forwardToLogin(){
    
        return CORECONNECT.CC_CommunityUtil.forwardToLogin();
    
    }
    
   public void SaveCurrentToCookie(){
       CORECONNECT.CC_CommunityUtil.SaveCurrentToCookie();
   }
}