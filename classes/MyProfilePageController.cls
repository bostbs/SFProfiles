/**
 * An apex class that keeps updates of a portal user in sync with its corresponding contact.
   Guest users are never able to access this page.
 */
public with sharing class MyProfilePageController {

    @TestVisible private User user;
    private boolean isEdit = false;
     public boolean isError {get;set;}
    public String gradYear {get;set;}
    public List<String> lstAffinities {get;set;}
    public List<String> lstContactMeAbout {get;set;}
    public List<String> lstUserAffiliations  {get;set;}
    public List<String> listInterests  {get;set;}
    public Map<String, Object> mapOfContribution {get;set;}         
    private final String COMMUNITY_ID = Network.getNetworkId();  
    public List<String> lstUserVentures {get;set;}
    private String strUserIdParam = (ApexPages.currentPage().getParameters().containsKey('userId') ? ApexPages.currentPage().getParameters().get('userId') : '');
    public hed__Address__c homeAddress1 {get;set;}
    public hed__Address__c homeAddress2 {get;set;}
    public hed__Address__c homeAddress3 {get;set;}
    public hed__Address__c homeAddress4 {get;set;}
    public hed__Address__c hometownAddress {get;set;}
    public Boolean showFeedLink {get;set;}
    private String accountId;
    private String contactId;
    public String displayMsg{get;set;}
    public Map<string,string> mpStates{get; set;}
    public List<CORECONNECT__CC_Community_Content__c> listUserBusinessInfo {get;set;}
    public NetworkMember netobj{get;set;}    
    public boolean allFeedEmail {get; set;}
    public boolean followme {get; set;}
    public boolean postonprofile {get; set;}
    public boolean sharepost {get; set;}
    public boolean likepost {get; set;}
    public boolean mentionpost {get; set;}
    public boolean mentioncomt {get; set;}
    public boolean endorses {get; set;}
    public boolean commentpost {get; set;}
    public boolean comentprof {get; set;}
    public boolean commentaft {get; set;}
    public boolean commentbookmrk {get; set;}
    public boolean commentlike {get; set;}
    
    public User getUser() {
        system.debug('Flow: Get User');
        return user;
    }

    public MyProfilePageController() {
        system.debug('Flow:in MyProfilePageController ');                   
        displayMsg='';
        showFeedLink=true;isval=false;
        if(String.isNotEmpty(ApexPages.currentPage().getParameters().get('userId'))){
           // showFeedLink=false;
        }
        if(String.isNotEmpty(ApexPages.currentPage().getParameters().get('displayMsg'))){
            displayMsg=ApexPages.currentPage().getParameters().get('displayMsg');
             if(displayMsg.contains('problem while')){
                iserror = true;
            }else{
                iserror = false;
            }
        }
         mpStates = new Map<string,string>();       
         Schema.DescribeFieldResult fieldResult = hed__Address__c.Mailing_State__c.getDescribe();        
         for(Schema.PicklistEntry ple: fieldResult.getpicklistvalues()){     
            mpStates.put(ple.getvalue(),ple.getlabel());
        }

    }


//Created by Irakli to retreive Notification preferences
public void retrieveNotificationPreferences(){
		string uId = UserInfo.getUserId();
        Network AlumniCommunity = [SELECT Id FROM Network WHERE Name ='Alumni']; //User existing custom label to assing as conditional variable insetad of had coded 'Alumni'
        netobj=[SELECT MemberId,PreferencesDisableAllFeedsEmail,PreferencesDisableBookmarkEmail,
                            PreferencesDisableChangeCommentEmail,PreferencesDisableDirectMessageEmail,
                            PreferencesDisableEndorsementEmail,PreferencesDisableFollowersEmail,
                            PreferencesDisableItemFlaggedEmail,PreferencesDisableLaterCommentEmail,
                            PreferencesDisableLikeEmail,PreferencesDisableMentionsPostEmail,
                            PreferencesDisableMessageEmail,PreferencesDisablePendingReviewEmail,
                            PreferencesDisableProfilePostEmail,PreferencesDisableSharePostEmail,
                            PreferencesDisCommentAfterLikeEmail,PreferencesDisMentionsCommentEmail,
                            PreferencesDisProfPostCommentEmail
                            FROM NetworkMember WHERE MemberId =:uId and NetworkId=:AlumniCommunity.id];
           
 		system.debug('Irakli original netobj ====>'+netObj);
        allFeedEmail = (netObj.PreferencesDisableAllFeedsEmail ? false:true);     
        followme = (netObj.PreferencesDisableFollowersEmail ? false:true);
        postonprofile =(netObj.PreferencesDisableProfilePostEmail  ? false:true);
        sharepost =(netObj.PreferencesDisableSharePostEmail  ? false:true);
        likepost =(netObj.PreferencesDisableLikeEmail  ? false:true);
        mentionpost =(netObj.PreferencesDisableMentionsPostEmail   ? false:true);
        mentioncomt =(netObj.PreferencesDisMentionsCommentEmail  ? false:true);
        endorses =(netObj.PreferencesDisableEndorsementEmail ? false:true);
        commentpost =(netObj.PreferencesDisableChangeCommentEmail  ? false:true);
        comentprof =(netObj.PreferencesDisProfPostCommentEmail ? false:true);
        commentaft =(netObj.PreferencesDisableLaterCommentEmail  ? false:true);
        commentbookmrk =(netObj.PreferencesDisableBookmarkEmail  ? false:true);
        commentlike =(netObj.PreferencesDisCommentAfterLikeEmail   ? false:true);

        system.debug('Irakli original reveresed netobj ====>'+netObj);
}

    public void setup(){
        isEdit = false;
        mapOfContribution = new Map<String, Object>{'Posts & Comments' => '0', 'Comments Received' => '0', 'Likes Received' => '0', 'Influence Percentile' => 'Observer'};
        
        String userId = (String.isNotBlank(strUserIdParam) ? strUserIdParam : UserInfo.getUserId());
        Boolean isValidId = true;
        try {Id uId = (ID) userId ;}
        catch (Exception e) {isValidId = false;}
        if(!isValidId)
        userId = UserInfo.getUserId();
        user = getUserDetails(userId);
        homeAddress1 = getAddress('Home 1');
        homeAddress2 = getAddress('Home 2');
        homeAddress3 = getAddress('Home 3');
        homeAddress4 = getAddress('Home 4');
        
        //JIRA Ticket #15693
        List<hed__Address__c> hometownAddresses = [SELECT Id, hed__MailingStreet__c, hed__MailingStreet2__c, hed_MailingStreet3__c, 
                                                                            Public_hed_MailingStreet__c, hed__MailingCity__c, 
                                                                            Mailing_State__c, hed__MailingPostalCode__c, Mailing_Country__c, 
                                                                            Public_Home_Address__c, Public_hed_MailingCity__c, 
                                                                            Public_hed_MailingState__c, Public_hed_MailingPostalCode__c, Public_hed_MailingCountry__c,
                                                                            hed__Address_Type__c, hed__Parent_Account__c, Phone__c, Public_Phone__c
                                                                            FROM hed__Address__c 
                                                                            WHERE hed__Parent_Contact__c =: contactId and hed__Address_Type__c='Home Town'
                                                                            ORDER BY LastModifiedDate DESC 
                                                                            LIMIT 1];
        if(contactId != null){
            Contact con = [Select id, AccountId from Contact where Id=:ContactId];
            if(!hometownAddresses.isEmpty())
                hometownAddress = hometownAddresses[0];
            else                                                                            
                hometownAddress = new hed__Address__c(hed__Parent_Contact__c = contactId, hed__Address_Type__c='Home Town', hed__Parent_Account__c=con.accountId);
        }
        //End of code for Ticket #15693
        
        listUserBusinessInfo = getUserBusinessInformation();
        
        if(user == null){
            user = getUserDetails(UserInfo.getUserId());
        }
        
        gradYear = whichGradYear(user.contact.Public_Graduate_Year__c, user.contact.Public_Undergraduate_Year__c,user.contact.Graduate_Year__c,user.contact.Undergraduate_Year__c);
        lstAffinities = String.isNotBlank(user.Contact.affinities__c)?user.Contact.affinities__c.split(';'):new List<String>();
        lstContactMeAbout = String.isNotBlank(user.Contact.Contact_me_about__c)?user.Contact.Contact_me_about__c.split(';'):new List<String>();
        
        fetch_CC_Venture();
        if(!Test.isRunningTest()){
            fetch_Contribution_User();
        }
            
        fetch_user_Affiliations();
        formatUserInterests();
        formatBabsonAffinities();
        
        //Created by Irakli to retrieve preferences
        retrieveNotificationPreferences();


        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }
    
    private User getUserDetails(String userId){
        system.debug('Flow:getUserDetails ');
        List<User> objUser = new List<User>( [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, fullphotourl, Public_Graduate_Year__c, Public_Undergraduate_Year__c,
                Graduate_Year__c,Undergraduate_Year__c,Constituency__c,Contact.Public_Constituency__c , Preferred_constituency__c,
                Contact.Name,Contact.Alumni_Directory_Name__c, Contact.FirstName, Contact.LastName, Contact.affinities__c, Contact.Interests__c,
                Contact.MailingCity, Contact.MailingState, Contact.MailingCountry, Contact.MailingPostalCode, Contact.MailingStreet,
                Contact.Phone, Contact.Undergraduate_Year__c, Contact.Graduate_Year__c, Contact.MobilePhone, Contact.Contact_me_about__c, 
                Contact.Degree__c, Contact.Graduate_Program__c, Contact.Facebook__c, Contact.Twitter__c, Contact.LinkedIn__c,Contact.Email,
                Contact.Instagram__c, Contact.Blog__c, Contact.Other__c, Contact.Skype__c,Contact.Summary_LTA__c,
                Contact.Public_Undergraduate_Year__c, Contact.Public_Email__c, Contact.Public_Phone__c,
                Contact.Public_Graduate_Year__c, Contact.Public_MobilePhone__c, Contact.Public_Contact_me_about__c, Contact.Public_Degree__c, 
                Contact.Public_Graduate_Program__c, Contact.Public_Facebook__c, Contact.Public_Twitter__c,Contact.Public_LinkedIn__c,
                Contact.Public_MailingCity__c,  Contact.Public_MailingCountry__c,  Contact.Public_MailingStreet__c,  Contact.Public_MailingPostalCode__c,  Contact.Public_MailingState__c,
                Contact.Public_Affiliation__c,Contact.Public_Affinities__c, Contact.Babson_Preferred_Affinities__c, Contact.Public_Babson_Affinities__c,
                Contact.Public_FirstName__c,Contact.Public_LastName__c, Contact.Public_Interests__c, Contact.Public_Title__c,
                contact.Certificate_Degree_Year__c, Contact.Public_Certificate_Degree_Year__c,
                contact.Graduate_Degree__c, Contact.Public_Graduate_Degree__c, Contact.Certificate_Degree__c, Contact.Public_Certificate_Degree__c,
                Contact.Preferred_Salutation__c, Contact.Public_Preferred_Salutation__c, 
                Contact.Birth_Name__c, Contact.Public_Birth_Name__c, Contact.Suffix__c, Contact.Public_Suffix__c, Contact.AccountId,
                Contact.Level__c,Contact.Public_Level__c,Contact.Function__c,Contact.Public_Function__c,Contact.Part_Time__c,Contact.Public_Part_Time__c,
                Contact.Undergraduate_Preferred_Year__c,Contact.Public_Undergraduate_Preferred_Year__c,Contact.Graduate_Preferred_Year__c,Contact.Public_Graduate_Preferred_Year__c,Contact.Certificate_Preferred_Year__c,
                Contact.Public_Certificate_Preferred_Year__c,Contact.Linkedin_Sync_Time_Stamp__c,Contact.Public_Timezone__c,
                Contact.Undergraduate_Program__c,Contact.Public_Undergraduate_Program__c,Contact.Certificate_Program__c,Contact.Public_Certificate_Program__c,Contact.Undergraduate_Honors__c,Contact.Public_Undergraduate_Honors__c,
                Contact.Venture_Backer__c,Contact.Public_Venture_Backer__c,
                Contact.President_Society_Member__c,Contact.Public_President_Society_Member__c,Contact.Last_Year_President_Society_Status__c,Contact.Public_LastYear_President_Society_Status__c,Contact.Donor_Status__c,
                Contact.Public_Donor_Status__c,Contact.Most_recent_Gift_Date__c,Contact.Public_Most_recent_Gift_Date__c,Contact.Most_recent_Gift_Amount__c,Contact.Public_Most_recent_Gift_Amount__c,Contact.Most_Recent_Gift_Fund__c,
                Contact.Public_Most_Recent_Gift_Fund__c,Contact.Lifetime_Total__c,Contact.Public_Lifetime_Total__c,Contact.Fiscal_Year_2018__c,Contact.Public_Fiscal_Year_2018__c,Contact.Fiscal_Year_2017__c,Contact.Public_Fiscal_Year_2017__c,Contact.Fiscal_Year_2016__c,
                Contact.Public_Fiscal_Year_2016__c,Contact.Fiscal_Year_2015__c,Contact.Public_Fiscal_Year_2015__c,Contact.Fiscal_Year_2014__c,Contact.Public_Fiscal_Year_2014__c,Contact.Fiscal_Year_2013__c,Contact.Public_Fiscal_Year_2013__c,
                Contact.Public_Preferred_Email__c, Contact.Preferred_Email__c,Contact.Preferred_Email_Type__c, Contact.Public_Preferred_Email_Type__c, Contact.hed__Deceased__c,  Contact.Public_hed_Deceased__c,
                Contact.Preferred_Mailing_Address__c, Contact.Public_Preferred_Mailing_Address__c,Contact.Associations__c,Contact.Specialties__c,
                Contact.LinkedIn_Interests__c,Contact.Languages__c,Contact.Skills__c,Contact.Certifications__c,Contact.Summary_Primary_Job__c,Contact.Start_Date_Primary_Job__c,
                Contact.Past_Position_Primary_Job__c,Contact.Following__c,Contact.Headline__c,Contact.Company_Location__c,Contact.Current_Share_Item__c,Contact.Summary__c,
                Contact.Public_Instagram__c, Contact.Public_Blog__c, Contact.Public_Other__c, Contact.Public_Skype__c,
                Contact.Public_Associations__c,Contact.Public_LinkedIn_Interests__c,Contact.Public_Languages__c,Contact.Public_Skills__c,Contact.Public_Certifications__c,Contact.Public_Summary_Primary_Job__c,Contact.Public_Start_Date_Primary_Job__c,Contact.Public_Past_Position_Primary_Job__c,Contact.Public_Following__c,Contact.Public_Headline__c,Contact.Public_Company_Location__c,Contact.Public_Current_Share_Item__c,Contact.Public_Summary__c,Contact.Public_Specialties__c,
                Contact.January__c,Contact.February__c,Contact.March__c,Contact.April__c,Contact.May__c,Contact.June__c,Contact.July__c,Contact.August__c,Contact.September__c,Contact.October__c,Contact.November__c,Contact.December__c,Contact.Public_Summary_Secondary_Job__c,Contact.Public_Start_Date_Secondary_Job__c,
                Contact.Public_Summary_Tertiary_Job__c,Contact.Start_Date_Tertiary_Job__c,
                Contact.Summary_Secondary_Job__c,Contact.Summary_Tertiary_Job__c,Contact.Start_Date_Secondary_Job__c,Contact.Public_Start_Date_Tertiary_Job__c,Contact.Public_Past_Position_Secondary_Job__c,Contact.Public_Past_Position_Tertiary_Job__c,Contact.Past_Position_Secondary_Job__c,
                Contact.Past_Position_Tertiary_Job__c,Contact.Secondary_Company_Location__c,
                Contact.Public_Secondary_Company_Location__c,contact.Public_Linkedin_Sync_Time_Stamp__c, contact.Public_Email_Address__c, Contact.Title_Primary_Job__c, contact.Public_Title_Primary_Job__c,contact.Title_Secondary_Job__c, contact.Title_Tertiary_Job__c, contact.Public_Title_Secondary_Job__c, contact.Public_Title_Tertiary_Job__c,
                Contact.Tertiary_Company_Location__c, contact.Summary_Primary_Job_LTA__c,contact.Summary_Secondary_Job_LTA__c, contact.Summary_Tertiary_Job_LTA__c,
                Contact.Public_Tertiary_Company_Location__c,Contact.hed__Preferred_Email__c,Contact.Email_Address__c,
                Contact.Home_town_city__c, Contact.Home_town_State__c, Contact.Home_town_country__c, Contact.Public_Home_Town_city__c, Contact.Public_home_town_state__c, Contact.Public_home_town_Country__c,
                Show_giving_information__c, Show_Education_information__c, Show_Home_town_Information__c, Show_Business_3_Section__c , Show_Business_4_Section__c,
                UserPreferencesDisableAllFeedsEmail, UserPreferencesDisableMessageEmail, UserPreferencesEnableAutoSubForFeeds, UserPreferencesDisableBookmarkEmail, 
                UserPreferencesDisableChangeCommentEmail, UserPreferencesDisableEndorsementEmail,  UserPreferencesDisableFileShareNotificationsForApi, 
                UserPreferencesDisableFollowersEmail, UserPreferencesDisableLaterCommentEmail, UserPreferencesDisableLikeEmail, 
                UserPreferencesDisableMentionsPostEmail, UserPreferencesDisableProfilePostEmail, UserPreferencesDisableSharePostEmail, 
                UserPreferencesDisCommentAfterLikeEmail, UserPreferencesDisMentionsCommentEmail, UserPreferencesDisProfPostCommentEmail
                FROM User
                WHERE id = : userId]);
                
            if(!objUser.isEmpty()){
                system.debug('Flow:if objuser is not empty');
                accountId = objUser[0].Contact.AccountId;
                contactId = objUser[0].ContactId;
                return objUser[0];
                
            }
            
            return null;
    }

    Private hed__Address__c getAddress(String addressLineNo){
        system.debug('contactId========='+contactId);
        List<hed__Address__c> lstHomeAddress = new List<hed__Address__c>([SELECT Id, hed__MailingStreet__c, hed__MailingStreet2__c, hed_MailingStreet3__c, 
                                                                            Public_hed_MailingStreet__c, hed__MailingCity__c, 
                                                                            Mailing_State__c, hed__MailingPostalCode__c, Mailing_Country__c, 
                                                                            Public_Home_Address__c, Public_hed_MailingCity__c, 
                                                                            Public_hed_MailingState__c, Public_hed_MailingPostalCode__c, Public_hed_MailingCountry__c,
                                                                            hed__Address_Type__c, hed__Parent_Account__c, Phone__c, Public_Phone__c
                                                                            FROM hed__Address__c 
                                                                            WHERE hed__Parent_Contact__c =: contactId
                                                                            AND Address_Line_No__c =: addressLineNo
                                                                            ORDER BY LastModifiedDate DESC 
                                                                            LIMIT 1]);
                
        if(!lstHomeAddress.isEmpty()){
            return lstHomeAddress[0];
        }
        return new hed__Address__c(hed__Parent_Contact__c = contactId, hed__Parent_Account__c = accountId, Address_Line_No__c = addressLineNo);
    }
    

    
    private List<CORECONNECT__CC_Community_Content__c> getUserBusinessInformation(){
        List<CORECONNECT__CC_Community_Content__c> lstUserBusinessInfo = new List<CORECONNECT__CC_Community_Content__c>([SELECT Id, Name ,I_am_the_CEO_President_Founder_or_Owne__c
                                                        FROM CORECONNECT__CC_Community_Content__c 
                                                        WHERE RecordType.Name = 'Business' 
                                                        AND OwnerId =: user.Id 
                                                        AND LineNo__c != null
                                                        AND LineNo__c like 'Business %'
                                                        ORDER BY LineNo__c DESC]);
        return lstUserBusinessInfo;
    }
    
    
    /* Method to fetch Community Content records to show on View Profile */
    private void fetch_CC_Venture() {
        lstUserVentures = new List<String>();
        for(CORECONNECT__CC_Community_Content__c cc : [SELECT Id, Name 
                                                        FROM CORECONNECT__CC_Community_Content__c 
                                                        WHERE RecordType.Name = 'Venture' 
                                                        AND OwnerId =: user.Id 
                                                        AND (CORECONNECT__Community_Content_Status__c = 'Approved' OR CORECONNECT__Community_Content_Status__c = 'updated') AND CCC_Id__c=null
                                                        ORDER BY CreatedDate DESC ]){
            
            lstUserVentures.add(cc.Name);
        }
    }
    
    public String whichGradYear(Boolean gradYearPublic,Boolean undergradYearPublic, String gradYear, String undergradYear ){
        // Preferably use grad year
        if (gradYearPublic &&  String.isNotBlank(gradYear) ){
            return gradYear;
        }
        // If not, use undergrad year
        if (undergradYearPublic && String.isNotBlank(undergradYear) ){
            return undergradYear;
        }
        return '';
    }

    /* In this we are fetching chatter activity for the user Id whose user is viewing the profile */
    @TestVisible
    public void fetch_Contribution_User() {
        system.debug('COMMUNITY_ID============='+COMMUNITY_ID+'============='+ user.Id);
        ConnectApi.UserDetail userDetail = ConnectApi.ChatterUsers.getUser(COMMUNITY_ID, user.Id);
        if(userDetail.chatterActivity != null) {
            Integer totalCount = ((ConnectApi.ChatterActivity) userDetail.chatterActivity).commentCount + ((ConnectApi.ChatterActivity) userDetail.chatterActivity).postCount;
            mapOfContribution.put('Posts & Comments', totalCount);
            mapOfContribution.put('Comments Received', ((ConnectApi.ChatterActivity) userDetail.chatterActivity).commentReceivedCount);
            mapOfContribution.put('Likes Received', ((ConnectApi.ChatterActivity) userDetail.chatterActivity).likeReceivedCount);
        }
        
        Decimal percentile = 0.0;
        if(userDetail.chatterInfluence != null) {   
            percentile = Decimal.valueOf((String) ((ConnectApi.GlobalInfluence) userDetail.chatterInfluence).percentile);
        }
        
        /* TODO : Need to change if we are able to change the threshold for Influence */
        if(percentile < 0.25) {
            mapOfContribution.put('Influence Percentile', 'Observer');
        }
        else if(percentile >= 0.25 && percentile < 0.8) {
            mapOfContribution.put('Influence Percentile', 'Active Influencer');
        }
        else {
            mapOfContribution.put('Influence Percentile', 'Top Influencer');
        }
        
        //influence percentage
        mapOfContribution.put('Influence Percentage', percentile*100+'%');
        
    }
    
    public Boolean getIsEdit() {
        return isEdit;
    }

    public void edit() {
        isEdit=true;
    }
    public boolean isVal{get; set;}
    public PageReference save() {
        // assume we'll pass validation
        isVal = false;
        // Manual checks
        if( String.isBlank(user.contact.firstName)){             
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill out this mandatory field: First Name'));
            isVal=true;
            }
            
        if( String.isBlank(user.contact.lastName)){             
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill out this mandatory field: Last Name'));
            isVal=true;
            }
            
        if( String.isBlank(user.contact.Preferred_Email__c)){             
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill out this mandatory field: preferred email'));
            isVal=true;
            System.debug('++1++');
        }
       if( String.isNotBlank(user.contact.Preferred_Email__c) && !validateEmail(user.contact.Preferred_Email__c)){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid email address'));
            isVal=true;
             System.debug('++2++');
        }
       if( String.isBlank(homeAddress1.hed__MailingStreet__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill out this mandatory field: home address'));
            isVal=true;
        }
        if( String.isBlank(homeAddress1.hed__MailingCity__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill out this mandatory field: home city'));
            isVal=true;
        }
       if(String.isBlank(homeAddress1.Mailing_State__c) && ('UNITED STATES'.equalsIgnoreCase(homeAddress1.Mailing_Country__c) || 'CANADA'.equalsIgnoreCase(homeAddress1.Mailing_Country__c))){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill out this mandatory field: home state/province'));
            isVal=true;
        }
        if( String.isBlank(homeAddress1.Mailing_Country__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill out this mandatory field: home country'));
            isVal=true;
        }
       
        if(!isValidUSZip(homeAddress1.Mailing_Country__c,homeAddress1.hed__MailingPostalCode__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Zip Code entered is invalid. US zip code must be in formatted 12345 or 12345-1234'));
            isVal=true;
        }
        if(!isValidUSZip(homeAddress2.Mailing_Country__c,homeAddress2.hed__MailingPostalCode__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Zip Code entered is invalid. US zip code must be in formatted 12345 or 12345-1234'));
            isVal=true;
        }
        if(!isValidUSZip(homeAddress3.Mailing_Country__c,homeAddress3.hed__MailingPostalCode__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Zip Code entered is invalid. US zip code must be in formatted 12345 or 12345-1234'));
            isVal=true;
        }
        if(!isValidUSZip(homeAddress4.Mailing_Country__c,homeAddress4.hed__MailingPostalCode__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Zip Code entered is invalid. US zip code must be in formatted 12345 or 12345-1234'));
            isVal=true;
        }
        System.debug('>>>>>>>>>>>>>>>>>>>>isVal>>>>>>>>'+isVal);
        if(isVal)
        return null;
        
        if (!isVal){
            try {
                user.firstname = user.contact.firstname;
                user.lastname = user.contact.lastname;
                user.email = user.contact.Preferred_Email__c;
                update user;
                // Upsert addresses if filled out
                if( String.isNotBlank(homeAddress1.hed__MailingStreet__c) && String.isNotBlank(homeAddress1.hed__MailingCity__c) && String.isNotBlank(homeAddress1.Mailing_Country__c)){
                    homeAddress1.Address_Line_No__c = 'Home 1';
                    System.debug('>>>>>>homeAddress1>>>>>>>>>'+homeAddress1);
                    upsert homeAddress1;
                } 

                if( String.isNotBlank(homeAddress2.hed__MailingStreet__c) || String.isNotBlank(homeAddress2.hed__MailingStreet2__c) || String.isNotBlank(homeAddress2.hed_MailingStreet3__c) ||
                    String.isNotBlank(homeAddress2.hed__MailingCity__c) || String.isNotBlank(homeAddress2.Mailing_State__c) ||
                    String.isNotBlank(homeAddress2.hed__MailingPostalCode__c) || String.isNotBlank(homeAddress2.Mailing_Country__c) || String.isNotBlank(homeAddress2.Phone__c) || 
                    String.isNotBlank(homeAddress2.Id)){

                    homeAddress2.Address_Line_No__c = 'Home 2';
                    System.debug('>>>>>>homeAddress2>>>>>>>>>'+homeAddress2);
                    upsert homeAddress2;
                }

                if( String.isNotBlank(homeAddress3.hed__MailingStreet__c) || String.isNotBlank(homeAddress3.hed__MailingStreet2__c) || String.isNotBlank(homeAddress3.hed_MailingStreet3__c) ||
                    String.isNotBlank(homeAddress3.hed__MailingCity__c) || String.isNotBlank(homeAddress3.Mailing_State__c) ||
                    String.isNotBlank(homeAddress3.hed__MailingPostalCode__c) || String.isNotBlank(homeAddress3.Mailing_Country__c) || String.isNotBlank(homeAddress3.Phone__c) || 
                    String.isNotBlank(homeAddress3.Id)){

                    homeAddress3.Address_Line_No__c = 'Home 3';
                    upsert homeAddress3;
                }

                if( String.isNotBlank(homeAddress4.hed__MailingStreet__c) || String.isNotBlank(homeAddress4.hed__MailingStreet2__c) || String.isNotBlank(homeAddress4.hed_MailingStreet3__c) ||
                    String.isNotBlank(homeAddress4.hed__MailingCity__c) || String.isNotBlank(homeAddress4.Mailing_State__c) ||
                    String.isNotBlank(homeAddress4.hed__MailingPostalCode__c) || String.isNotBlank(homeAddress4.Mailing_Country__c) || String.isNotBlank(homeAddress4.Phone__c) || 
                    String.isNotBlank(homeAddress4.Id)){

                    homeAddress4.Address_Line_No__c = 'Home 4';
                    upsert homeAddress4;
                }
                
                if( String.isNotBlank(hometownAddress.hed__MailingCity__c) || String.isNotBlank(hometownAddress.Mailing_State__c) || String.isNotBlank(hometownAddress.Mailing_Country__c)|| 
                    String.isNotBlank(hometownAddress.Id)){

                    hometownAddress.hed__Address_Type__c = 'Home Town';
                    hometownAddress.Address_Line_No__c = 'Home Town';
                    upsert hometownAddress;
                }
                //JIRA Ticket #15693
                //upsert hometownAddress;
                //End of #15693
                if (user.contact != null) {
                    update user.contact;
                 }
                 saveUserPreferences(); //update notification preferences//Irakli

                fetch_user_Affiliations();
                System.debug('++isVal++'+isVal);
        
        
                pagereference ref = new pagereference('/MyProfilePage');
                ref.setRedirect(true);
                return ref;
                
            } catch(Exception e) {
                system.debug('e====='+e.getMessage());
                ApexPages.addMessages(e);
                isVal=true;
            }  
            return null;//Page.MyProfilePage;          
        }

        // In case of save but with failures, set up again so that cancel and/or rerender action reflects actual (non-error) values
        System.debug('++isVal++'+isVal);
        setup();
        isEdit = isVal;
        return null;           
    }

    public PageReference changePassword() {
        return Page.ChangePassword;
    }

    public void cancel() {
        setup();
    }
    
    public static Boolean validateEmail(String email) {
        Boolean res = true;
            
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches()) {
            res = false;
        }
        return res; 
    }

    public static Boolean isValidUSZip(String country, String zip){
        if( String.isNotBlank(country) && country == 'UNITED STATES' && !validateZip(zip)){
            return false;
        }
        return true;
    }

    public static Boolean validateZip(String zip) {
        Boolean res = false;
        if(String.isNotEmpty(zip)){
             // Why doesn't ^[0-9]{5}(?:-[0-9]{4})?$ work?!?
            String zipRegex = '^[0-9]{5}$';
            String zipRegexAlt = '^[0-9]{5}-[0-9]{4}$';
            Pattern MyPattern = Pattern.compile(zipRegex);
            Matcher MyMatcher = MyPattern.matcher(zip);
            Pattern MyPatternAlt = Pattern.compile(zipRegexAlt);
            Matcher MyMatcherAlt = MyPatternAlt.matcher(zip);
            
            if (MyMatcher.matches() || MyMatcherAlt.matches()) {
                res = true;
            }
        }
        else{
            res = true;
        }
       return res; 
    }
    
    /*  Affiliation, the controller should query to find all Affiliation records where hed_Contact_c = the current user. 
    For each Affiliation record found, the hed_Account_c.Name should be returned to the page*/
    @TestVisible
    private void fetch_user_Affiliations(){
        List<hed__Affiliation__c> lstUserAffiliationRecords = new List<hed__Affiliation__c>([SELECT Id, Name, Public_hed_Account__c, hed__Account__r.Name
                                FROM hed__Affiliation__c
                                WHERE hed__Contact__c =: user.ContactId]);
        
        lstUserAffiliations = new List<String>();
        for(hed__Affiliation__c affiliation : lstUserAffiliationRecords){
           lstUserAffiliations.add(affiliation.hed__Account__r.Name);
        }
    }
    
    /* redirect SSF To Home Page if this page is accessed with invalid id or its own id */
    public PageReference redirectToHomePage(){     
        system.debug('strUserIdParam============'+strUserIdParam.length());
        //redirect to babson home
          setup(); 
        return null;
    }

    /* Format interests as list for the bubble list component! */
    private void formatUserInterests(){
        listInterests = new List<String>();
        if (user.contact.Interests__c != null){
            listInterests = user.contact.Interests__c.split(';'); 
        }
    }
    
    public List<String> listBabsonInterests{get; set;}
    private void formatBabsonAffinities(){
        listBabsonInterests = new List<String>();
        if (user.contact.Babson_Preferred_Affinities__c != null){
            listBabsonInterests = user.contact.Babson_Preferred_Affinities__c.split(';'); 
        }
      }
    

    public void saveUserPreferences(){
        system.debug('Irakli Before Save netObj====>'+netObj);

        netObj.PreferencesDisableAllFeedsEmail      =  (allFeedEmail ? false:true);
        netObj.PreferencesDisableFollowersEmail     =  (followme ? false:true);
        netObj.PreferencesDisableProfilePostEmail   =  (postonprofile  ? false:true);
        netObj.PreferencesDisableSharePostEmail     =  (sharepost ? false:true);
        netObj.PreferencesDisableLikeEmail          =  (likepost ? false:true);
        netObj.PreferencesDisableMentionsPostEmail  =  (mentionpost ? false:true);
        netObj.PreferencesDisMentionsCommentEmail   =  (mentioncomt ? false:true);
        netObj.PreferencesDisableEndorsementEmail   =  (endorses ? false:true);
        netObj.PreferencesDisableChangeCommentEmail =  (commentpost  ? false:true);
        netObj.PreferencesDisProfPostCommentEmail   =  (comentprof ? false:true);
        netObj.PreferencesDisableLaterCommentEmail  =  (commentaft ? false:true);
        netObj.PreferencesDisableBookmarkEmail      =  (commentbookmrk ? false:true);
        netObj.PreferencesDisCommentAfterLikeEmail  =  (commentlike ? false:true);
        
       system.debug('Irakli after Save netObj====>'+netObj);

           update netobj; 
        }
    
}