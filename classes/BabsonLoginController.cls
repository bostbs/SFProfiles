public with sharing class BabsonLoginController {
    
    public String username  {get;set;}                                    // to store username which will be entered at the time of login
    public String password  {get;set;}                                    // to store password which will be entered at the time of login
    public String forgotPasswordURL {get;set;}                            // to store forgot password URL
    /* Private Variables */
    private CORECONNECT__CC_System_Settings__c setting;                   // to store custom setting values
    private AlumniCommunity__c customSetting;                            // to store custom setting values
    private String redirectUrl;
    
    public BabsonLoginController(){
        setting = CORECONNECT__CC_System_Settings__c.getInstance(Site.GetName());
        customsetting = AlumniCommunity__c.getInstance(Site.GetName());
        redirectUrl = setting.CORECONNECT__Community_Home_URL__c + '/' + setting.CORECONNECT__Community_Home__c;
        forgotPasswordURL = customSetting.Forgot_Password_URL__c;
    }
    
    /* Method will be called when user log in to community with community username and password */
    public PageReference login(){
        return Site.login(username, password, redirectUrl);
    }
    
    public pageReference redirectToSSO(){
        String url=Apexpages.currentPage().getUrl();
        if('Guest'.equalsIgnoreCase(UserInfo.getUserType())){
            String returnValue = '';  
            returnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
            if (returnValue == '' || returnValue == null) {
                returnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
            } 
            if (returnValue == '' || returnValue == null) {
                returnValue = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
            } 
            String connectorString=url.substringAfter('connector');
            if(String.isNotBlank(connectorString) && connectorString.length()>0){
                List<String> parts = url.split('startURL');
                System.debug('@@@'+parts);  
                System.debug('@@@'+Site.getBaseUrl());
                if(parts.size()>1){
                    String deeplinkURL=EncodingUtil.urlDecode(parts[1], 'UTF-8');
                    List<String> deeplinkURLList = deeplinkURL.split('connector');
                    System.debug('@@@ deeplinkURLList'+deeplinkURLList);
                    User_Login_History__c userLogin= new User_Login_History__c();
                    userLogin.Name=UserInfo.getUserId();
                    userLogin.Session_Id__c=UserInfo.getSessionId();
                    userLogin.Login_IP__c=returnValue;
                    if(null !=deeplinkURLList && deeplinkURLList.size()>1 && !deeplinkURLList[1].contains('BabsonCommunityAssetTemplate')){
                        userLogin.LogOutURL__c=Site.getBaseUrl()+deeplinkURLList[1];
                        insert userLogin;
                    }

                }           
            }
        }
        if(url.contains('BabsonHome') || url.contains('babsonlogin'))
            return null;
        else{
            PageReference pg =new PageReference(Label.SSO_Easy_loginURL);
            return pg;
            //return null;
        }
    }
}