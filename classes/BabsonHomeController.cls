public without sharing class BabsonHomeController {
    
    public String homePageLogoURL                                       {get;set;}               // to store Home Page Logo URL
    public String logoURL                                               {get;set;}               // to store logo URL 
    public AlumniCommunity__c aluminiCustomSetting                      {get;set;}               // to store custom setting instance
    public Boolean noRecordSection                                      {get;set;}               // variable to show/hide no record section
    public Map<Id, SObject> mapOfIdToSObject                            {get;set;}               // map of Entity Id user has followed to User/Community Content instance
    public String linkFilter                                            {get;set;}               // variable to store picklist value
    public String followFilter                                          {get;set;}               // variable to store picklist value
    public String userPrefix                                            {get;set;}               // constant variable to store user prefix
    public String groupPrefix                                           {get;set;}               // constant variable to store group prefix
    public List<CORECONNECT__CC_Community_Content__c> lstCC             {get;set;}               // List of community connect to be visible on Recommend By section
    public List<CORECONNECT__CC_Community_Content__c> lstFeatureCC      {get;set;}               // list to show collobrate alumini content 
    public List<User> lstFeatureUser                                    {get;set;}               // list to show collobrate alumini user 
    public String recommendedFilter                                     {get;set;}               // variable to store recommended filter
    public Map<String, String> mapOfCCToAttachId                        {get;set;}               // map to store attachmentId related to community content
       
    /* Private variables */
    private CORECONNECT__CC_System_Settings__c systemSetting;            // to store system custom setting instance
    private AlumniCommunityPersonalization__c aluminiPersonal;           // to store aluminiPersonal custom setting instance
    private List<Id> lstOfEntityId;                                      // List of Entity Id context user has followed
    private List<Id> lstOfGroupId;                                      // List of Group Id context user is a member of
    private final Set<String> setOfRecordTypeName;                       // Set to store record Type name 
    private final String communityUserId = UserInfo.getUserId();         // Store community User Id
    private final String USER_PREFIX = '005';                            // constant variable
    private final String GROUP_PREFIX = '0F9';                           // constant variable
    private Map<Integer, String> mapOfContentPersonalization;            // Will store integer to Community Content field API name
    private Map<Integer, String> mapOfContentTypeHomePersonalization;    // Will store integer to Community Content RecordTypeName
    private Map<Integer, String> mapOfUserPersonalization;               // Will store integer to User API name
    private Map<Integer, String> mapOfUserPersInfo;                      // Will store integer to User value based on custom setting info
    private Set<String> setOfRecommendedAttachmentCCId;                  // Set to store CC id to fetch attachment record
    private Set<String> setOfRecommendedCCId;                            // Set to store CC id 
    public String giveToBabsonURl{get;set;}
    public string contactid {get;set;}
    public boolean isDateExist {get;set;}
    public string body{get;set;}
    public string title{get;set;}
    list<BCTAC__c>  lstVTAC ;
    public BCTAC__c oVTAC {get;set;}
    /* Constructor*/
    public BabsonHomeController() {
        
        aluminiCustomSetting = AlumniCommunity__c.getInstance(Site.GetName());
        systemSetting = CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName());
        aluminiPersonal = AlumniCommunityPersonalization__c.getInstance(Site.GetName());
        logoURL = aluminiCustomSetting != null ? aluminiCustomSetting.UnAuth_Home_Logo__c : '';
        linkFilter = 'All';
        followFilter = 'Follow';
        recommendedFilter = 'All';
        noRecordSection = false;
        lstOfEntityId = new List<Id>();
        mapOfIdToSObject = new Map<Id, SObject>();
        userPrefix = USER_PREFIX;
        groupPrefix = GROUP_PREFIX;
        mapOfUserPersInfo = new Map<Integer, String>();
        lstCC = new List<CORECONNECT__CC_Community_Content__c>();
        lstFeatureCC = new List<CORECONNECT__CC_Community_Content__c>();
        mapOfCCToAttachId = new Map<String, String>();
        lstFeatureUser = new List<User>();
        setOfRecommendedCCId = new Set<String>();
        setOfRecommendedAttachmentCCId = new Set<String>();
        setOfRecordTypeName = new Set<String>{'Job', 'Venture', 'Business', 'FreeText', 'ScheduledContent'};
        //  lstOfCReatedId = new Set<id>();

        AlumniCommunityL2Pages__c alumniL2Setting = AlumniCommunityL2Pages__c.getInstance(Site.GetName());
        CORECONNECT__CC_Header_Footer_Settings__c headerFooterSetting = CORECONNECT__CC_Header_Footer_Settings__c.getInstance(Site.GetName());

         try{
      
        Contact currentContact = [Select Id,  FirstName,LastName ,Preferred_Email__c, Graduate_Preferred_Year__c,Graduate_Year__c,Undergraduate_Preferred_Year__c,Certificate_Preferred_Year__c,MobilePhone,Undergraduate_Year__c,Certificate_Degree_Year__c
                            From Contact
                            Where Id In (Select ContactId From User Where Id = :UserInfo.getUserId())];
        List<hed__Address__c> add=[Select id,hed__MailingStreet__c,hed__MailingStreet2__c,hed__MailingCity__c,hed__MailingPostalCode__c,Mailing_Country__c,Mailing_State__c,Phone__c,Address_Line_No__c from hed__Address__c where hed__Parent_Contact__c=:currentContact.id AND Address_Line_No__c='Home 1' limit 1] ;
        System.debug('@@Add'+add);
        String classYear;
        if(String.isNotEmpty(currentContact.Undergraduate_Preferred_Year__c)){
            classYear=currentContact.Undergraduate_Preferred_Year__c;
        }
        else if(String.isNotEmpty(currentContact.Undergraduate_Year__c)){
            classYear=currentContact.Undergraduate_Year__c;
        }
        else if(String.isNotEmpty(currentContact.Graduate_Preferred_Year__c)){
            classYear=currentContact.Graduate_Preferred_Year__c;
        }
        else if(String.isNotEmpty(currentContact.Graduate_Year__c)){
            classYear=currentContact.Graduate_Year__c;
        }
        else if(String.isNotEmpty(currentContact.Certificate_Preferred_Year__c)){
            classYear=currentContact.Certificate_Preferred_Year__c;
        }
        else if(String.isNotEmpty(currentContact.Certificate_Degree_Year__c)){
            classYear=currentContact.Certificate_Degree_Year__c;
        }
        User loggedInUser = [Select id,contact.isBabsonTermandConsitionAccepted__c,Preferred_Constituency__c from User where Id=:UserInfo.getUserId()];
        string prefConstituency = loggedInUser.Preferred_Constituency__c;
        lstVTAC  = new list< BCTAC__c >();
        oVTAC  = new BCTAC__c ();
        lstVTAC  = [SELECT Body__c,Community_Content_Status__c,End_Date__c,Publish_Date__c,Title__c FROM BCTAC__c WHERE
                    Community_Content_Status__c =:'Approved' order by Publish_Date__c desc LIMIT 1];
                    
        if(lstVTAC.size()>0 && lstVTAC !=null){
            oVTAC  = lstVTAC[0];
            body =oVTAC.body__c;  
            title =  oVTAC.Title__c ;   
        }
        
         if(loggedInUser.contact.isBabsonTermandConsitionAccepted__c == true){
                isDateExist =true;
                
         }else{
                isDateExist =false;
                contactid = loggedInUser.contact.id;
         }
            
        if(null!=headerFooterSetting )
            giveToBabsonURl=headerFooterSetting.CORECONNECT__Header_Link_1_URL__c;
        giveToBabsonURl=giveToBabsonURl+'&strFirstName='+format(currentContact.FirstName)+'&strLastName='+format(currentContact.LastName)+'&strEmail='+format(currentContact.Preferred_Email__c)+'&strAffiliation='+prefConstituency+'&strClassYear='+format(classYear)+'&strPhoneCell='+format(currentContact.MobilePhone)+'&strLine1=';
         if(null!=add && add.size()>0){
            if('United States'.equalsIgnoreCase(add[0].Mailing_Country__c))
                add[0].Mailing_Country__c='USA';
            giveToBabsonURl=giveToBabsonURl+format(add[0].hed__MailingStreet__c)+'&strLine2='+format(add[0].hed__MailingStreet2__c)+'&strCity='+format(add[0].hed__MailingCity__c)+'&strPostalCode='+format(add[0].hed__MailingPostalCode__c)+'&strState='+format(add[0].Mailing_State__c)+'&strCountry='+format(add[0].Mailing_Country__c)+'&strPhoneHome='+format(add[0].Phone__c)+'&source_code=BABCON';                 
        }

        }
        catch(Exception ex){
                if(null!=headerFooterSetting )
                    giveToBabsonURl=headerFooterSetting.CORECONNECT__Header_Link_1_URL__c;
                System.debug('@@@@'+ex);
            }
        
        
        lstFeatureCC = [SELECT id, Title__c, Name, RecordType.Name, CORECONNECT__Short_Description__c FROM CORECONNECT__CC_Community_Content__c WHERE Id =: aluminiCustomSetting.Auth_Home_Section_5_Block_1_RecordId__c];
        lstFeatureUser = [SELECT Id, Contact.id, Name, Contact.Name, Contact.FirstName, Contact.LastName, SmallPhotoURL, Contact.Graduate_Year__c, Contact.Undergraduate_Year__c ,Contact.Preferred_Salutation__c ,Contact.Affiliation_Display_Name__c, Contact.Alumni_Name_Affiliation_Display__c, Contact.Alumni_Directory_Name__c FROM User WHERE Id =: aluminiCustomSetting.Auth_Home_Section_5_Block_2_RecordId__c];
        
        /* If Logo Id is not provided in Custom setting then it will fetch Logo URL from package custom setting */  
        if(String.isNotEmpty(logoURL)) {
            homePageLogoURL = '/servlet/servlet.ImageServer?id=' + logoURL + '&oid=' + UserInfo.getOrganizationId(); 
        }
        else {
            homePageLogoURL = systemSetting.CORECONNECT__Default_Group_Logo_URL__c;
        }
        entityPersonalAlumini();
        fetchContent();
        entitySubscription();
        groupMembership();
        fetchMyLinks();
        
    }
    
    /* Function to format the Null values */
        public String format(String add){
            if(String.isEmpty(add))
                return '';
            else
                return add;
        }


    /* ****** END ****************  */



    /* Fetch all User/Community Content/Groups records which context user has followed */
    public void fetchMyLinks() {
        
        noRecordSection = false;
        mapOfIdToSObject = new Map<Id, SObject>();
        System.debug('linkFilter===='+linkFilter);
        System.debug('followFilter===='+followFilter);
        
        if(linkFilter == 'All' || linkFilter == 'Venture' || linkFilter == 'Job' || linkFilter == 'Business' || linkFilter=='FreeText' || linkFilter == 'ScheduledContent') {
            
            String query = ' SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name ' +
                           ' FROM CORECONNECT__CC_Community_Content__c WHERE ' +
                           ((followFilter == 'Follow') ? ' Id IN: lstOfEntityId ' : ' OwnerId =: communityUserId ') +
                           ' AND RecordType.Name IN: setOfRecordTypeName AND CCC_Id__c=null AND I_am_the_CEO_President_Founder_or_Owne__c = true ORDER BY LastModifiedDate DESC';


            List<CORECONNECT__CC_Community_Content__c> lstContent = Database.query(query);
            if(!lstContent.isEmpty()){
                for(CORECONNECT__CC_Community_Content__c commContent : lstContent) {  
                    if(linkFilter == commContent.RecordType.Name || linkFilter == 'All') {
                        mapOfIdToSObject.put(commContent.Id, commContent);
                    } 
                }
            }
        }
         if((followFilter == 'Created')) {
             if(linkFilter == 'Venture'){
                    for(CORECONNECT__CC_Community_Content__c commUser : [ SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name
                                                                          FROM CORECONNECT__CC_Community_Content__c WHERE
                                                                          RecordType.Name ='Venture' AND createdbyID =: userInfo.getUserId() AND CCC_Id__c=null 
                                        ]) {
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                    }
              }
              if(linkFilter == 'Business'){
                    for(CORECONNECT__CC_Community_Content__c commUser : [ SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name
                                                                          FROM CORECONNECT__CC_Community_Content__c WHERE
                                                                          RecordType.Name ='Business' AND createdbyID =: userInfo.getUserId() AND CCC_Id__c=null 
                                        ]) {
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                    }
              }
              if(linkFilter == 'People'){
                    for(User commUser : [ SELECT Id, Name, Contact.Id, Contact.Name, SmallPhotoURL, Contact.Graduate_Year__c
                                          FROM User
                                          WHERE createdbyID =: userInfo.getUserId()
                                        ]) {
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                    }
              }
              if(linkFilter == 'All'){
                    for(User commUser : [ SELECT Id, Name, Contact.Id, Contact.Name, SmallPhotoURL, Contact.Graduate_Year__c
                                          FROM User
                                          WHERE createdbyID =: userInfo.getUserId()
                                        ]) {
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                    }
                    
                    for(CORECONNECT__CC_Community_Content__c commUser : [ SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name
                                                                      FROM CORECONNECT__CC_Community_Content__c WHERE
                                                                      createdbyID =: userInfo.getUserId() AND CCC_Id__c=null AND (RecordType.Name ='Business' OR RecordType.Name ='Venture' )
                                    ]) {
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                
                    }
             }
        }
        System.debug('lstOfEntityId==='+lstOfEntityId);
        if(followFilter == 'Follow') {
                if(linkFilter == 'People'){
                    for(User commUser : [ SELECT Id, Name, Contact.Id, Contact.Name, SmallPhotoURL, Contact.Graduate_Year__c
                                          FROM User
                                          WHERE Id IN: lstOfEntityId
                                        ]) {
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                    }
                }
                if(linkFilter == 'Venture'){
                     for(CORECONNECT__CC_Community_Content__c commUser : [ SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name
                                                                  FROM CORECONNECT__CC_Community_Content__c WHERE
                                                                  RecordType.Name ='Venture' AND Id IN: lstOfEntityId AND CCC_Id__c=null 
                                ]) {
                            mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                        }
                        }       
                if(linkFilter == 'FreeText'){       
                    for(CORECONNECT__CC_Community_Content__c commUser : [ SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name      
                                                                  FROM CORECONNECT__CC_Community_Content__c WHERE       
                                                                  RecordType.Name ='FreeText' AND Id IN: lstOfEntityId AND CCC_Id__c=null       
                                ]) {        
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                                    
                    } 
                }
                if(linkFilter == 'ScheduledContent'){      
                    for(CORECONNECT__CC_Community_Content__c commUser : [ SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name      
                                                                  FROM CORECONNECT__CC_Community_Content__c WHERE       
                                                                  RecordType.Name ='ScheduledContent' AND Id IN: lstOfEntityId AND CCC_Id__c=null       
                                ]) {        
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                                    
                     }     
                }
                if(linkFilter == 'Business'){
                     for(CORECONNECT__CC_Community_Content__c commUser : [ SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name
                                                                  FROM CORECONNECT__CC_Community_Content__c WHERE
                                                                  RecordType.Name ='Business' AND Id IN: lstOfEntityId AND CCC_Id__c=null 
                                ]) {
                            mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                        }
                }
            
                if(linkFilter == 'All'){
                    for(User commUser : [ SELECT Id, Name, Contact.Id, Contact.Name, SmallPhotoURL, Contact.Graduate_Year__c
                                          FROM User
                                          WHERE Id IN: lstOfEntityId
                                        ]) {
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                    }
                    
                    for(CORECONNECT__CC_Community_Content__c commUser : [ SELECT Title__c,Id, CORECONNECT__Short_Description__c, Name, RecordType.Name
                                                                      FROM CORECONNECT__CC_Community_Content__c WHERE
                                                                      Id IN: lstOfEntityId AND CCC_Id__c=null 
                                    ]) {
                        mapOfIdToSObject.put(commUser.Id, commUser);                                                             
                
                    }
             }
       } 
       
       
        //updated to find groups where the user is a member vs is following
        if(linkFilter == 'All' || linkFilter == 'Groups') {
            
            String collQuery = ' SELECT Id, Name, MemberCount ' +
                               ' FROM CollaborationGroup WHERE ' +
                               ((followFilter == 'Follow') ? ' Id IN: lstOfGroupId ' : ' CreatedById =: communityUserId');
            System.debug('@@collQuery'+collQuery);
                               
            for(CollaborationGroup commGrp : Database.query(collQuery)) {
                
                mapOfIdToSObject.put(commGrp.Id, commGrp);                                                             
            }
        }
        
        noRecordSection = mapOfIdToSObject.isEmpty();
        
    }
    /* */
    
    public void updateContactTermTimeStamp(){
        contact con = new contact(id=contactid );
        con.isBabsonTermandConsitionAccepted__c = true;
        con.Babson_Connector_Terms_Acceptance_Date__c = system.now();
        update con;
    
    }
    /* Method to fetch all Entity Subscription record which user has fetched */
    private void entitySubscription() {   
        
        lstOfEntityId = new List<Id>();
        
        for(EntitySubscription entity : [SELECT Id, ParentId
                                            FROM EntitySubscription 
                                            WHERE SubscriberId =: communityUserId
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1000
                                        ]) {
            lstOfEntityId.add((String) entity.ParentId);   
        }
    }
    
    /* Method to fetch all Entity Subscription record which user has fetched */
    private void entityCReated() {        
        
        
    }

    /* Method to fetch all Groups which user is a member */
    private void groupMembership() {   
        
        lstOfGroupId = new List<Id>();
        
        for(CollaborationGroupMember groupMember : [   SELECT Id, CollaborationGroupId
                                            FROM CollaborationGroupMember 
                                            WHERE MemberId =: communityUserId
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1000
                                        ]) {
            lstOfGroupId.add((String) groupMember.CollaborationGroupId);   
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
                                                              
        mapOfContentTypeHomePersonalization = new Map<Integer, String>{1 => aluminiPersonal.Content_Type_Home_Page_Tile_1__c,
                                                                       2 => aluminiPersonal.Content_Type_Home_Page_Tile_2__c,
                                                                       3 => aluminiPersonal.Content_Type_Home_Page_Tile_3__c,
                                                                       4 => aluminiPersonal.Content_Type_Home_Page_Tile_4__c,
                                                                       5 => aluminiPersonal.Content_Type_Home_Page_Tile_5__c,
                                                                       6 => aluminiPersonal.Content_Type_Home_Page_Tile_6__c
                                                                      };
       
       
        mapOfUserPersonalization = new Map<Integer, String>{1 => aluminiPersonal.User_Personalization_Field_1__c,
                                                            2 => aluminiPersonal.User_Personalization_Field_2__c,
                                                            3 => aluminiPersonal.User_Personalization_Field_3__c,
                                                            4 => aluminiPersonal.User_Personalization_Field_4__c,
                                                            5 => aluminiPersonal.User_Personalization_Field_5__c,
                                                            6 => aluminiPersonal.User_Personalization_Field_6__c
                                                           };
                                                           
       Id contactId = [SELECT contactID 
                        FROM User 
                        WHERE Id =: communityUserId].contactID;
        
        for(Integer i = 1; i <= 6; i++) {
            
            if(mapOfUserPersonalization.get(i) == null) {
                mapOfUserPersInfo.put(i, null);
            }
            else {
                
                for(Contact contactInfo : Database.query(' SELECT Id, ' + mapOfUserPersonalization.get(i) + ' FROM Contact WHERE Id =: contactId ')){
                    mapOfUserPersInfo.put(i, (String)contactInfo.get(mapOfUserPersonalization.get(i)));
                
                }
            }
        }
    }
    
    /* 
        Generic Method: To fetch Tiles n information based on different filters fetched from CustomSetting.
    */
    private List<CORECONNECT__CC_Community_Content__c> fetchCommunityContent(String recordTypeName) {
        
        List<String> lstOfCCFieldAPIName = new List<String>();
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContent = new List<CORECONNECT__CC_Community_Content__c>();
        Map<Integer, CORECONNECT__CC_Community_Content__c> mapOfIntegerToCommunityContent = 
            new Map<Integer, CORECONNECT__CC_Community_Content__c>{1 => null, 2 => null, 3 => null, 4 => null, 5 => null, 6 => null, 7 => null};
        
        Set<String> setOfAPIName = new Set<String>();                                                         
        for(String str : mapOfContentPersonalization.values()) {
            
            if(str != null) {
                setOfAPIName.add(str);    
            }
        }
        lstOfCCFieldAPIName.addAll(setOfAPIName);
        
        String queryPart = '';
        if(!lstCC.isEmpty()) {
            queryPart = ' AND Id !=: lstCC ';
        }
        
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
        
        String query = ' SELECT Id, Title__c,Name, RecordType.Name, CORECONNECT__Short_Description__c, Default_Content__c, CORECONNECT__Community_Content_Status__c, CreatedDate, ' +
                       ' CORECONNECT__Start_Date__c, CORECONNECT__End_Date__c, CORECONNECT__Location_City__c, CORECONNECT__Location_State_Province__c ' +
                       + strFieldsForQuery + ' FROM CORECONNECT__CC_Community_Content__c WHERE RecordType.Name = \'' + recordTypeName + '\'' + queryPart + ' AND ( ' + 
                       ((mapOfContentPersonalization.get(1) == null) ? ' ' : mapOfContentPersonalization.get(1) + ' includes (\''+ personalisation1 +'\') OR ') +
                       ((mapOfContentPersonalization.get(2) == null) ? ' ' : mapOfContentPersonalization.get(2) + ' includes (\''+ personalisation2 +'\') OR ') +
                       ((mapOfContentPersonalization.get(3) == null) ? ' ' : mapOfContentPersonalization.get(3) + ' includes (\''+ personalisation3 +'\') OR ') +
                       ((mapOfContentPersonalization.get(4) == null) ? ' ' : mapOfContentPersonalization.get(4) + ' includes (\''+ personalisation4 +'\') OR ') +
                       ((mapOfContentPersonalization.get(5) == null) ? ' ' : mapOfContentPersonalization.get(5) + ' includes (\''+ personalisation5 +'\') OR ') +
                       ((mapOfContentPersonalization.get(6) == null) ? ' ' : mapOfContentPersonalization.get(6) + ' includes (\''+ personalisation6 +'\') OR ');
                       
        if(recordTypeName == 'ScheduledContent') {
            
            // query += ' Default_Content__c = TRUE OR Trump_Content__c = TRUE ) AND  (CORECONNECT__Community_Content_Status__c = \'Approved\' or CORECONNECT__Community_Content_Status__c = \'updated\') and CCC_Id__c =null  AND (CORECONNECT__Start_Date__c >= TODAY) ORDER BY Trump_Content__c DESC, CORECONNECT__Start_Date__c ASC LIMIT 200';
            query += ' Trump_Content__c = TRUE OR Default_Content__c = TRUE ) AND  (CORECONNECT__Community_Content_Status__c = \'Approved\' OR CORECONNECT__Community_Content_Status__c = \'updated\') AND CCC_Id__c =null  AND (CORECONNECT__Start_Date__c >= TODAY) ORDER BY Trump_Content__c DESC, CORECONNECT__Start_Date__c ASC LIMIT 200';
        } else if(recordTypeName == 'business'){
            query = ' SELECT Id, Title__c,Name, RecordType.Name, CORECONNECT__Short_Description__c, Default_Content__c, CORECONNECT__Community_Content_Status__c, CreatedDate, ' +
                       ' CORECONNECT__Start_Date__c, CORECONNECT__End_Date__c, CORECONNECT__Location_City__c, CORECONNECT__Location_State_Province__c ' +
                       + strFieldsForQuery + ' FROM CORECONNECT__CC_Community_Content__c WHERE RecordType.Name = \'' + recordTypeName + '\'' + queryPart + ' AND ';
            // query += ' Default_Content__c = TRUE OR Trump_Content__c = TRUE ) AND publish_business__c = true ORDER BY Trump_Content__c DESC,LastModifiedDate DESC LIMIT 200';
            query += ' (Default_Content__c = TRUE OR Trump_Content__c = TRUE ) AND publish_business__c = true AND I_am_the_CEO_President_Founder_or_Owne__c =true ORDER BY Trump_Content__c DESC,LastModifiedDate DESC LIMIT 200';
        } else {
            
            // query += ' Default_Content__c = TRUE ) AND  (CORECONNECT__Community_Content_Status__c = \'Approved\' or CORECONNECT__Community_Content_Status__c = \'updated\') and CCC_Id__c =null  AND CORECONNECT__FreeText_Desired_Publish_Date__c < TOMORROW AND CORECONNECT__FreeText_End_Date__c > YESTERDAY ORDER BY LastModifiedDate DESC LIMIT 200';
            query += ' Trump_Content__c = TRUE OR Default_Content__c = TRUE ) AND  (CORECONNECT__Community_Content_Status__c = \'Approved\' or CORECONNECT__Community_Content_Status__c = \'updated\') and CCC_Id__c =null  AND CORECONNECT__FreeText_Desired_Publish_Date__c < TOMORROW AND CORECONNECT__FreeText_End_Date__c > YESTERDAY ORDER BY Trump_Content__c Desc, LastModifiedDate DESC LIMIT 200';
        }
        
        Integer index = 1;
        System.debug('@@@@ query'+query);
        Map<string,CORECONNECT__CC_Community_Content__c> mpCommunityContent = new Map<string,CORECONNECT__CC_Community_Content__c>();
        for(CORECONNECT__CC_Community_Content__c commContent : Database.query(query)) {
            if(!mpCommunityContent.containsKey(commContent.RecordType.Name))
                mpCommunityContent.put(commContent.RecordType.Name, commContent);
        }       
        for(CORECONNECT__CC_Community_Content__c commContent : Database.query(query)) {
            
            Set<String> setCCPersonalisation1 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(1)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(1))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation2 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(2)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(2))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation3 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(3)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(3))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation4 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(4)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(4))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation5 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(5)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(5))).split(';')) : new Set<String>();
            Set<String> setCCPersonalisation6 =  String.isNotBlank(String.valueOf(commContent.get(mapOfContentPersonalization.get(6)))) ? new Set<String>(String.valueOf(commContent.get(mapOfContentPersonalization.get(6))).split(';')) : new Set<String>();
            
            if(recordTypeName == 'All'){
            /*
            if(mapOfContentPersonalization.get(1) != null && !commContent.Default_Content__c && mapOfIntegerToCommunityContent.get(1) == null
                 && BAB_Util.doesContainsItemFromSet(setPersonalisation1,setCCPersonalisation1)) {
                
                mapOfIntegerToCommunityContent.put(1, commContent);
                break;
            }
            
            if(mapOfContentPersonalization.get(2) != null && mapOfIntegerToCommunityContent.get(2) == null && !commContent.Default_Content__c 
                && BAB_Util.doesContainsItemFromSet(setPersonalisation2,setCCPersonalisation2)) {
                
                mapOfIntegerToCommunityContent.put(2, commContent);
            }
            
            if(mapOfContentPersonalization.get(3) != null && mapOfIntegerToCommunityContent.get(3) == null && !commContent.Default_Content__c 
                && BAB_Util.doesContainsItemFromSet(setPersonalisation3,setCCPersonalisation3)) {
                
                mapOfIntegerToCommunityContent.put(3, commContent);
            }
            
            if(mapOfContentPersonalization.get(4) != null && mapOfIntegerToCommunityContent.get(4) == null && !commContent.Default_Content__c 
                && BAB_Util.doesContainsItemFromSet(setPersonalisation4,setCCPersonalisation4)) {
            
                mapOfIntegerToCommunityContent.put(4, commContent);
            }
            
            if(mapOfContentPersonalization.get(5) != null && mapOfIntegerToCommunityContent.get(5) == null && !commContent.Default_Content__c 
                && BAB_Util.doesContainsItemFromSet(setPersonalisation5,setCCPersonalisation5)) {
            
                mapOfIntegerToCommunityContent.put(5, commContent);
            }
            
            if(mapOfContentPersonalization.get(6) != null && mapOfIntegerToCommunityContent.get(6) == null && !commContent.Default_Content__c
                 && BAB_Util.doesContainsItemFromSet(setPersonalisation6,setCCPersonalisation6)) {
            
                mapOfIntegerToCommunityContent.put(6, commContent);
            }
            
            if(mapOfIntegerToCommunityContent.get(7) == null && commContent.Default_Content__c) {
                
                mapOfIntegerToCommunityContent.put(7, commContent);
            }
            */
            if(mapOfContentTypeHomePersonalization.containsKey(index) && mpCommunityContent.containsKey(mapOfContentTypeHomePersonalization.get(index))){
                    mapOfIntegerToCommunityContent.put(index, mpCommunityContent.get(mapOfContentTypeHomePersonalization.get(index)));
                }
                
                
            }
            else{
                //Added by Anisha to work for recommnded filters
                if(mapOfIntegerToCommunityContent.get(index) == null) {
                    //mapOfContentTypeHomePersonalization.put(index,commContent);
                    mapOfIntegerToCommunityContent.put(index, commContent);
                }                
                index++;
            }
            
        } 
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+mapOfIntegerToCommunityContent);
        for(Integer i = 1; i <= 7; i++) {
            
            //Conidtion Recommended Filter is added by Anisha so that logic works only for All
            if((recommendedFilter == 'All' || recommendedFilter == '' || recommendedFilter == null) && mapOfIntegerToCommunityContent.get(i) != null) {
                
                lstCommunityContent.add(mapOfIntegerToCommunityContent.get(i));

                setOfRecommendedAttachmentCCId.add(mapOfIntegerToCommunityContent.get(i).Id);
                
                /* if(mapOfIntegerToCommunityContent.get(i).RecordType.Name == 'FreeText' || mapOfIntegerToCommunityContent.get(i).RecordType.Name == 'ScheduledContent') {
                    setOfRecommendedAttachmentCCId.add(mapOfIntegerToCommunityContent.get(i).Id);
                }
                else {
                    setOfRecommendedCCId.add(mapOfIntegerToCommunityContent.get(i).Id);
                } */
                
                break;
            }
            //Added by Anisha to work for filters
            else{
                if(mapOfIntegerToCommunityContent.get(i) != null){
                    lstCommunityContent.add(mapOfIntegerToCommunityContent.get(i));
                    setOfRecommendedAttachmentCCId.add(mapOfIntegerToCommunityContent.get(i).Id);
                }
            }
        }
        
        system.debug('>>>>>>>>lstCommunityContent>>>>>>>>>>'+lstCommunityContent.size());
        return lstCommunityContent;   
          
    }
    
    /* This method will be called onload and if user selects view all on page to fetch all the CC_Community Content for all record Type */
    private void fetchContent() {
        
        mapOfCCToAttachId = new Map<String, String>();
        lstCC = new List<CORECONNECT__CC_Community_Content__c>();
        setOfRecommendedCCId = new Set<String>();
        setOfRecommendedAttachmentCCId = new Set<String>();
        
        lstCC.addAll(fetchCommunityContent(mapOfContentTypeHomePersonalization.get(1)));
        lstCC.addAll(fetchCommunityContent(mapOfContentTypeHomePersonalization.get(2)));
        lstCC.addAll(fetchCommunityContent(mapOfContentTypeHomePersonalization.get(3)));
        lstCC.addAll(fetchCommunityContent(mapOfContentTypeHomePersonalization.get(4)));
        lstCC.addAll(fetchCommunityContent(mapOfContentTypeHomePersonalization.get(5)));
        lstCC.addAll(fetchCommunityContent(mapOfContentTypeHomePersonalization.get(6)));
        
        if(!lstCC.isEmpty()) {
            fetchAttachment(setOfRecommendedCCId, setOfRecommendedAttachmentCCId);
        }
        
    }
    
    /* This method will be called onchange of select list from recommended section */
    public void fetchRecommendedContent() {
        
        mapOfCCToAttachId = new Map<String, String>();
        lstCC = new List<CORECONNECT__CC_Community_Content__c>();
        setOfRecommendedCCId = new Set<String>();
        setOfRecommendedAttachmentCCId = new Set<String>();
        
        if(recommendedFilter == 'All') {
            
            fetchContent();
        }
        else {
            
            lstCC.addAll(fetchCommunityContent(recommendedFilter));
            System.debug('>>>>>>>>lstCC>>>>>>>'+lstCC.size());
            if(!lstCC.isEmpty()) {
                fetchAttachment(setOfRecommendedCCId, setOfRecommendedAttachmentCCId);
            }
        }
    }
    
    /* This is used to fetch all the attachments related to the list of community content fetched based on custom settings */
    private void fetchAttachment(Set<String> setOfCContentId, Set<String> setOfRecommendedAttachmentCCId) {
        
        Set<String> setOfCCId = new Set<String>();
        setOfCCId.addAll(setOfRecommendedAttachmentCCId);
        
        for(Attachment attach : [SELECT id, ParentId FROM Attachment WHERE ParentId IN: setOfRecommendedAttachmentCCId ORDER BY CreatedDate DESC]) {
            if(!mapOfCCToAttachId.containsKey(attach.ParentId)) {
                
                mapOfCCToAttachId.put(attach.ParentId, attach.id); 
                setOfCCId.remove(attach.ParentId);
            }
        }
        
        if(!setOfCCId.isEmpty()) {
            setOfCContentId.addAll(setOfCCId);
        }
        
        for(Id ccId : setOfCContentId) {
            
            mapOfCCToAttachId.put(ccId, 'NC');    
        }

    }
    
    public pageReference redirectNonAluminiUser(){
        //----------------- START Changes for deep links -------------------------------------------
        /*String returnValue = '';  
        returnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if (returnValue == '' || returnValue == null) {
            returnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } 
        if (returnValue == '' || returnValue == null) {
            returnValue = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        }
        List<User_Login_History__c>guestUserLoginHistories=[SELECT id,CreatedDate,Session_Id__c,LogOutURL__c,Login_IP__c FROM User_Login_History__c WHERE Login_IP__c=:returnValue LIMIT 1];
        if(guestUserLoginHistories.size()>0){
            String url=guestUserLoginHistories[0].LogOutURL__c;
            delete guestUserLoginHistories;
            PageReference pg =new PageReference(url);
            return pg; 
        }*/
        //---------------------- END changes for Deep Link ------------------------------------------
        /*if(ApexPages.currentPage().getParameters().containsKey('redirect')){
            return null;
        }
        List<User_Login_History__c>userLoginHistories=[SELECT id,CreatedDate,Session_Id__c,LogOutURL__c FROM User_Login_History__c WHERE Name=:UserInfo.getUserId() ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('@@@'+UserInfo.getSessionId());
        if(userLoginHistories.size()>0 && UserInfo.getSessionId()!=userLoginHistories[0].Session_Id__c){
            System.debug('@@@inside');
            if(null!=userLoginHistories[0].LogOutURL__c && String.isNotBlank(userLoginHistories[0].LogOutURL__c )){
                if(userLoginHistories[0].LogOutURL__c.contains('BabsonHome'))
                    return null;
                PageReference pg =new PageReference(userLoginHistories[0].LogOutURL__c );
                return pg;    
            }
            else{
                return null;
            }
        }
        else{
            return null;
        }*/
        return null;
    }

}