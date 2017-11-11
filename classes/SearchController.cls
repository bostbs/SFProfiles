/**

 VF Controller 

    @version 09/8/2014
    @author 7Summits
*/

global with sharing class SearchController {
    
    global String SearchString{
        get;set;
    }
    global String EscapedSearchString{
        get;set;
    }
    
    global String SearchType {
        get;set;
    }
    
   
    
    private Map<Id, Set<String>> mapParentId_SetFeeds = new Map<Id, Set<String>>();
    
    Set<Id> setParentId = new Set<Id>();
    
    private Integer userCount;
    private Boolean firstTime;
    private Boolean isNext;
    global List<CORECONNECT.CC_CommunityContentWrapper> LisOfCCForALL{
        get;set;
    }
   
    
    global SearchController() {

        //PROFILE_IDS = CORECONNECT.CC_CommunityUtil.constructProfilesList(profileIds);
        PROFILE_IDS = BAB_Util.constructProfilesList(profileIds);
        system.debug('PROFILE_IDS============'+PROFILE_IDS);
        USER_BASE_QUERY= 'select Id,AboutMe, Name, SmallPhotoUrl, Department,CompanyName,Division, Title, Username,UserType,Public_Graduate_Year__c,Graduate_Year__c,Undergraduate_Year__c,Public_Undergraduate_Year__c from User' +  PROFILE_IDS + ' AND isActive = true AND CORECONNECT__CC_List_In_Directory__c = TRUE';
            
        mapParentId_SetFeeds = new Map<Id, Set<String>>();
       
        this.SearchString = ApexPages.currentPage().getParameters().get('SearchString');
        this.SearchType = ApexPages.currentPage().getParameters().get('SearchType');
        
        if(SearchString != null &&  SearchString.trim() != '' && !String.isEmpty(SearchString)){
            EscapedSearchString = String.escapeSingleQuotes(SearchString.trim().replace(' ','%')); 
        }
                
        if(this.SearchType == null &&  !String.isEmpty(SearchString)) {
            this.SearchType = 'All';
            
            LisOfCCForALL = this.queryByType('FreeText');
            LisOfCCForALL.addAll(this.queryScheduledContent());
            LisOfCCForALL.addAll(this.queryPeople());
            LisOfCCForALL.addAll(this.queryGroup());
            LisOfCCForALL.addAll(this.queryContentVersion());
            LisOfCCForALL.addAll(this.queryByType('Venture'));
            LisOfCCForALL.addAll(this.queryByType('Job'));
            // LisOfCCForALL.addAll(this.queryByType('Business')); 
            LisOfCCForALL.addAll(queryBusiness());
        }    
           
        else if (this.SearchType == 'FreeText' && !String.isEmpty(SearchString)){
            LisOfCCForALL = this.queryByType('FreeText');
        }else if (this.SearchType == 'ScheduledContent' && !String.isEmpty(SearchString)){
            LisOfCCForALL = this.queryScheduledContent();
        }
        else if (this.SearchType == 'People' && !String.isEmpty(SearchString)){
            LisOfCCForALL = this.queryPeople();
        }else if (this.SearchType == 'Group' && !String.isEmpty(SearchString)){
            LisOfCCForALL = this.queryGroup();
        }
        else if (this.SearchType == 'File' && !String.isEmpty(SearchString)){
            LisOfCCForALL = this.queryContentVersion();
        }
        else if (this.SearchType == 'Venture' && !String.isEmpty(SearchString)){
            LisOfCCForALL = this.queryByType('Venture');
        }
        else if (this.SearchType == 'Job' && !String.isEmpty(SearchString)){
            LisOfCCForALL = this.queryByType('Job');
        }
        else if (this.SearchType == 'Businesses' && !String.isEmpty(SearchString)){
            // LisOfCCForALL = this.queryByType('Business');
            LisOfCCForALL = this.queryBusiness();
        }
        else {
            LisOfCCForALL = new List<CORECONNECT.CC_CommunityContentWrapper> ();
        }
    }
    
    // for user queries
    private final String USER_BASE_QUERY;
    private final String PROFILE_IDS;
    private Set<String> profileIds = new Set<String>();
    
    
    private final String ScheduledContent_BASE_QUERY = 'select id, Name,RecordType.Name,CORECONNECT__Location__c,CORECONNECT__Classification1__c, CORECONNECT__Start_Date__c,CORECONNECT__End_Date__c, CORECONNECT__Is_All_Day_ScheduledContent__c from CORECONNECT__CC_Community_Content__c where RecordType.Name = \'ScheduledContent\' AND CORECONNECT__Community_Content_Status__c = \'Approved\'';
    private List<CORECONNECT.CC_CommunityContentWrapper> queryScheduledContent(){   
        String QUERY = ScheduledContent_BASE_QUERY;
        if(!String.isEmpty(SearchString)){
             QUERY +=  ' AND ( Name Like \'%' + EscapedSearchString + '%\' or CORECONNECT__Short_Description__c Like \'%' + EscapedSearchString + '%\' ) order by CORECONNECT__Start_Date__c ASC LIMIT 100';
        }else{
            return new List<CORECONNECT.CC_CommunityContentWrapper>();
        }
        List<CORECONNECT__CC_Community_Content__c> lisCC =Database.query(QUERY) ;
        
        List<CORECONNECT.CC_CommunityContentWrapper> lisW = new List<CORECONNECT.CC_CommunityContentWrapper>();
        for(CORECONNECT__CC_Community_Content__c cc: lisCC ){
            CORECONNECT.CC_CommunityContentWrapper w = new CORECONNECT.CC_CommunityContentWrapper();
            w.CCType = 'ScheduledContent';
            w.CC = cc;
            lisW.add(w);
        }
        return lisW ;
    }
    
   
   
    private List<CORECONNECT.CC_CommunityContentWrapper> queryPeople(){
        
        String QUERY = USER_BASE_QUERY;
        if(!String.isEmpty(SearchString)){
             QUERY +=  ' AND ( Name Like \'%' + EscapedSearchString + '%\' or CompanyName Like \'%' + EscapedSearchString + '%\' or CORECONNECT__Classification1__c Like \'%' + EscapedSearchString + '%\' or CORECONNECT__Classification2__c Like \'%' + EscapedSearchString + '%\' or CORECONNECT__Classification3__c Like \'%' + EscapedSearchString + '%\') ORDER BY NAME LIMIT 333';
        }else{
            return new List<CORECONNECT.CC_CommunityContentWrapper>();
        }
        
        List<User> lisUser =  (List<User>)Database.query(QUERY);
        List<CORECONNECT.CC_CommunityContentWrapper> lisW = new List<CORECONNECT.CC_CommunityContentWrapper>();
        for(User u: lisUser){
            CORECONNECT.CC_CommunityContentWrapper w = new CORECONNECT.CC_CommunityContentWrapper();
            w.CCType = 'People';
            w.u = u;
            lisW.add(w);
        }
        return lisW; 
    }
    
    
    private final String GROUP_BASE_QUERY = 'select Name, Description from CollaborationGroup where Network.Name = \'' + CORECONNECT.CC_CommunityConstants.THIS_COMMUNITY_NAME +'\'';
    private List<CORECONNECT.CC_CommunityContentWrapper> queryGroup() {
        
        String QUERY = GROUP_BASE_QUERY;
        if(!String.isEmpty(SearchString)){
             QUERY +=  ' AND ( Name Like \'%' + EscapedSearchString + '%\' or Description Like \'%' + EscapedSearchString +'%\') ORDER BY NAME LIMIT 100';
        }else{
            return new List<CORECONNECT.CC_CommunityContentWrapper>();
        }
        
        List<CollaborationGroup> lisGroup =  (List<CollaborationGroup>)Database.query(QUERY);

        List<CORECONNECT.CC_CommunityContentWrapper> lisW = new List<CORECONNECT.CC_CommunityContentWrapper>();
        for(CollaborationGroup g: lisGroup){
            CORECONNECT.CC_CommunityContentWrapper w = new CORECONNECT.CC_CommunityContentWrapper();
            w.CCType = 'Group';
            w.cg = g;
            lisW.add(w);
        }
        return lisW; 
    }
    
    private final String CONTENT_VERSION_BASE_QUERY = 'select Title,Id,Description from ContentVersion where NetworkId =\'' + CORECONNECT.CC_CommunityConstants.NETWORK_ID + '\'';
    private List<CORECONNECT.CC_CommunityContentWrapper> queryContentVersion() {

        String QUERY = CONTENT_VERSION_BASE_QUERY;
        if(!String.isEmpty(SearchString)){
             QUERY +=  ' AND ( TITLE Like \'%' + EscapedSearchString + '%\' or Description Like \'%' + EscapedSearchString +'%\') ORDER BY Title LIMIT 100';
        }else{
            return new List<CORECONNECT.CC_CommunityContentWrapper>();
        }
        
        List<ContentVersion> lisCont =  (List<ContentVersion>)Database.query(QUERY);
        
        List<CORECONNECT.CC_CommunityContentWrapper> lisW = new List<CORECONNECT.CC_CommunityContentWrapper>();
        for(ContentVersion v: lisCont){
            CORECONNECT.CC_CommunityContentWrapper w = new CORECONNECT.CC_CommunityContentWrapper();
            w.CCType = 'File';
            w.ChatterFile= v;
            lisW.add(w);
        }
        return lisW; 
    }

    private List<CORECONNECT.CC_CommunityContentWrapper> queryByType(String type){
        
        String QUERY = 'SELECT id, Title__c, Name, RecordType.Name, CORECONNECT__Short_Description__c, CORECONNECT__FreeText_Desired_Publish_Date__c,CreatedDate '+
                        'FROM CORECONNECT__CC_Community_Content__c '+
                        'WHERE RecordType.Name = \''+type+'\' AND CCC_Id__c = null AND (CORECONNECT__Community_Content_Status__c = \'Approved\' or CORECONNECT__Community_Content_Status__c = \'updated\')';
                        
        if(!String.isEmpty(SearchString)){
            
             QUERY +=  ' AND (Name Like \'%' + EscapedSearchString + '%\' or CORECONNECT__Short_Description__c Like \'%' + EscapedSearchString + '%\' or Title__c Like \'%' + EscapedSearchString + '%\') order by CORECONNECT__FreeText_Desired_Publish_Date__c DESC LIMIT 100';
        }else{
            
            return new List<CORECONNECT.CC_CommunityContentWrapper>();
        }
       
        List<CORECONNECT__CC_Community_Content__c> lisCC =Database.query(QUERY) ;
       
        List<CORECONNECT.CC_CommunityContentWrapper> lisW = new List<CORECONNECT.CC_CommunityContentWrapper>();
        for(CORECONNECT__CC_Community_Content__c cc: lisCC ){
            CORECONNECT.CC_CommunityContentWrapper w = new CORECONNECT.CC_CommunityContentWrapper();
            w.CCType = type;
            w.CC = cc;
            lisW.add(w);
        }
        return lisW ;
    }
    
    private List<CORECONNECT.CC_CommunityContentWrapper> queryBusiness(){
        
        String QUERY = 'SELECT id, Name, RecordType.Name, Business_Summary__c '+
                        'FROM CORECONNECT__CC_Community_Content__c '+
                        'WHERE RecordType.Name = \'Business\' AND Publish_Business__c = true';
                        
        if(!String.isEmpty(SearchString)){
            
             QUERY +=  ' AND (Name Like \'%' + EscapedSearchString + '%\' or Business_Summary__c Like \'%' + EscapedSearchString + '%\' ) order by LastModifiedDate DESC LIMIT 100';
        }else{
            
            return new List<CORECONNECT.CC_CommunityContentWrapper>();
        }
       
        List<CORECONNECT__CC_Community_Content__c> lisCC =Database.query(QUERY) ;
       
        List<CORECONNECT.CC_CommunityContentWrapper> lisW = new List<CORECONNECT.CC_CommunityContentWrapper>();
        for(CORECONNECT__CC_Community_Content__c cc: lisCC ){
            CORECONNECT.CC_CommunityContentWrapper w = new CORECONNECT.CC_CommunityContentWrapper();
            w.CCType = 'Business';
            w.CC = cc;
            lisW.add(w);
        }
        return lisW ;
    }
}