/**
    BabsonHeaderComponentController for BabsonHeader.component

    @version 08/13/2014
    @author 7Summits
*/

global with sharing class BabsonHeaderComponentController {

    public string contactid {get;set;}
    public boolean isDateExist {get;set;}
    public string body{get;set;}
    public string title{get;set;}
    list<BCTAC__c>  lstVTAC ;
    public BCTAC__c oVTAC {get;set;}
    
    
    CORECONNECT__CC_System_Settings__c setting; 
    
    CORECONNECT__CC_Header_Footer_Settings__c footerHeader; 
    
    
    public User loggedInUser{get; set;}
    global BabsonHeaderComponentController (){
        setting = CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName());
        footerHeader = CORECONNECT__CC_Header_Footer_Settings__c.getInstance(Site.GetName());
        loggedInUser = [Select id,contact.isBabsonTermandConsitionAccepted__c,Preferred_Constituency__c from User where Id=:UserInfo.getUserId()];
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
        
       
    }
     
    public void updateContactTermTimeStamp(){
        contact con = new contact(id=contactid );
        con.isBabsonTermandConsitionAccepted__c = true;
        con.Babson_Connector_Terms_Acceptance_Date__c = system.now();
        update con;
        isDateExist = true;
    }
    
    public void saveLastUpdateOnUserLoginHistory(){
        try{
            List<User_Login_History__c>userLoginHistories=[SELECT id,CreatedDate,Session_Id__c,Last_Updated_Date__c FROM User_Login_History__c WHERE Name=:UserInfo.getUserId() ORDER BY CreatedDate DESC LIMIT 1];
            if(null!=userLoginHistories && userLoginHistories.size()>0){
                userLoginHistories[0].Last_Updated_Date__c=System.now();
                //update userLoginHistories;
            }
        }
        catch(QueryException qExc){

        }
        catch(DMLException dmlExc){

        }
        
       
        
    }
    
    @RemoteAction
    global static void saveUserLoginHistory(String url){
        User_Login_History__c userLogin= new User_Login_History__c();
        userLogin.Name=UserInfo.getUserId();
        userLogin.Session_Id__c=UserInfo.getSessionId();
        userLogin.Last_Updated_Date__c=System.now();
        userLogin.Page_Start_Time__c=System.now();
        if(url.indexOf('refURL')>-1){
            String[] urlToStore=url.split('refURL');
            if(urlToStore.size()>0)
                userLogin.LogOutURL__c=urlToStore[0];
            else
                userLogin.LogOutURL__c=url;    
        }   
        else{
            userLogin.LogOutURL__c=url;  
        } 
        if(userLogin.LogOutURL__c !=null && userLogin.LogOutURL__c.length()>255){
            userLogin.LogOutURL__c = userLogin.LogOutURL__c.substring(0,255);       
        }
        System.debug('@@@'+userLogin );
        if(null!=userLogin.Session_Id__c)
            upsert userLogin Session_Id__c;
    }
    
    String defaultValue = 'default';

    global Contact contact {
        get{
        try{
            return [
            Select Id, FirstName
            From Contact
            Where Id In (Select ContactId
                         From User
                         Where Id = :UserInfo.getUserId())
            ];
            }
          catch(Exception ex){
              return new Contact();
          }  
        }
    }
    
     
    global String LoginURL {
        get{    
            if(setting==null){
                return defaultValue;
            }return setting.CORECONNECT__Login_URL__c ;}}

    global String LogoutURL {
        get{    
            if(setting==null){
                return defaultValue;
            }return setting.CORECONNECT__Logout_URL__c ;}}

    global String GuestProfileName {
        get{    
            if(setting==null){
                return defaultValue;
            }return setting.CORECONNECT__Guest_Profile_Name__c ;}set;}

    global String HeaderLogoImageURL {
        get{    
            if(setting==null){
                return defaultValue;
            }return footerHeader.CORECONNECT__Header_Logo_Image_URL__c ;}}
    
    global Boolean ShowGettingStartedLink {
        get {
            if(setting == null){
                return false;
            }return setting.CORECONNECT__Show_Getting_Started_Link__c;
        }
    }
    
    global String Link1Label {
        get {
            if(footerHeader == null){
                return '';
            }return footerHeader.CORECONNECT__Header_Link_1_Label__c;
        }
    }
    
    global String Link1URL {
        get {
            if(footerHeader == null){
                return '';
            }return footerHeader.CORECONNECT__Header_Link_1_URL__c;
        }
    }
    //Added for iConClass
    global String Link1IconClass {
        get {
            if(footerHeader == null){
                return '';
            }return footerHeader.CORECONNECT__Header_Link_1_Icon_Class__c;
        }
    }
    
    global Boolean Link1NewPage {
        get {
            if(footerHeader == null){
                return false;
            }return footerHeader.CORECONNECT__Header_Link_1_New_Page__c;
        }
    }
    
    global String Link2Label {
        get {
            if(footerHeader == null){
                return '';
            }return footerHeader.CORECONNECT__Header_Link_2_Label__c;
        }
    }
    
    global String Link2URL {
        get {
            if(footerHeader == null){
                return '';
            }return footerHeader.CORECONNECT__Header_Link_2_URL__c;
        }
    }
    //Added for iConClass
    global String Link2IconClass {
        get {
            if(footerHeader == null){
                return '';
            }return footerHeader.CORECONNECT__Header_Link_2_Icon_Class__c;
        }
    }
    
    global Boolean Link2NewPage {
        get {
            if(footerHeader == null){
                return false;
            }return footerHeader.CORECONNECT__Header_Link_2_New_Page__c;
        }
    }
    
    global String HeaderCSSBrandingPageName {get{return '';}}
    
    global String HeaderCSSBrandingResourceName {
        get{

                if(footerHeader==null || footerHeader.CORECONNECT__Header_CSS_Branding_Resource_Name__c == null || footerHeader.CORECONNECT__Header_CSS_Branding_Resource_Name__c.trim() == ''){
                    return '';
                }
                else
                {
                    return footerHeader.CORECONNECT__Header_CSS_Branding_Resource_Name__c;
                }

            }
     }
     
    
    
    global String SearchString{get;set;}    
    global ConnectApi.Photo UserPhotos {get{if(UserPhotos == null){UserPhotos = CORECONNECT.CC_CommunityUtil.getUserPhotos(CORECONNECT.CC_CommunityConstants.MY_ID);}return UserPhotos;}set;}
 
     
}