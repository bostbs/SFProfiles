public class SyncLinkedInProfile 
{//BEGIN: class SyncLinkedInProfile
    
    public Contact currentContact {get;set;}
    public string displayError {get;set;}
    private string codeParam {get; set;}
    private string stateParam {get; set;}
    private string storedToken {get; set;}
    private string userId {get; set;}   
    public string myEndPoint {get;set;}
    public Long lastModifiedTimestamp {get;set;} 
    //private LinkInApi__c client {get;set;}
    private User currentUser {get;set;}
    public static string ERRORMESSAGE = 'There was an issue syncing your account. Please try again. If the error continues, please contact support@babson.edu.';
    
    //test string
    public string jsonData {get; set;}
    
    
    /// <summary>
    /// class constructor - set the class variables
    /// </summary>
    public SyncLinkedInProfile() 
    {//SyncLinkedInProfile()
        
        codeParam = ApexPages.CurrentPage().getParameters().get('code');
        stateParam = ApexPages.CurrentPage().getParameters().get('state');
        //currentUser = [SELECT LinkedInExpire__c, LinkedInId__c, LinkedInToken__c FROM User WHERE ID = :UserInfo.getUserId()];
        //storedToken = currentUser.LinkedInToken__c;
        userId = UserInfo.getUserId();
        
        
        //retrieve client id from custom settings
        //client = LinkInApi__c.getValues('BabsonClient');
        
        
        //use the current user's user id as the state variable
        string state = userId; 
        string redirectPage ;
        
        redirectPage =Label.Linkedin_Redirect_URL;
        
        redirectPage = EncodingUtil.urlEncode(redirectPage, 'UTF-8');
        state = EncodingUtil.urlEncode(state, 'UTF-8');
        //myEndPoint = client.AuthorizationUrl__c;
        myEndPoint ='https://www.linkedin.com/uas/oauth2/authorization?';
        myEndPoint += 'response_type=code';
        myEndPoint += '&client_id=' + Label.LinkedIn_ClientId;
        myEndPoint += '&state=' + state;
        myEndPoint += '&redirect_uri=' + redirectPage;
        
        try
        {//retrieve contact record for current user
            if(Test.isrunningtest()){
                currentContact=[Select Id, Name, LinkedIn__c, Associations__c,LinkedIn_Interests__c,Languages__c,Linkedin_Sync_Time_Stamp__c,
                                Skills__c, Certifications__c,Summary_Primary_Job__c, Start_Date_Primary_Job__c, Summary_Secondary_Job__c, Start_Date_Secondary_Job__c, 
                                Summary_Tertiary_Job__c, Start_Date_Tertiary_Job__c, Past_Position_Primary_Job__c, Past_Position_Secondary_Job__c, 
                                Past_Position_Tertiary_Job__c, Following__c, Headline__c, Current_Share_Item__c, Specialties__c, summary__c,Company_Location__c,Secondary_Company_Location__c,
                                Public_Secondary_Company_Location__c,
                                Tertiary_Company_Location__c,
                                Public_Tertiary_Company_Location__c,Preferred_Email__c,Email_Address__c
                                From Contact limit 1];
            }
            else{
                currentContact = [Select Id, Name, LinkedIn__c, Associations__c,LinkedIn_Interests__c,Languages__c,Linkedin_Sync_Time_Stamp__c,
                                  Skills__c, Certifications__c,Summary_Primary_Job__c, Start_Date_Primary_Job__c, Summary_Secondary_Job__c, Start_Date_Secondary_Job__c, 
                                  Summary_Tertiary_Job__c, Start_Date_Tertiary_Job__c, Past_Position_Primary_Job__c, Past_Position_Secondary_Job__c, 
                                  Past_Position_Tertiary_Job__c, Following__c, Headline__c, Current_Share_Item__c, Specialties__c, summary__c,Company_Location__c,Secondary_Company_Location__c,
                                  Public_Secondary_Company_Location__c,
                                  Tertiary_Company_Location__c,
                                  Public_Tertiary_Company_Location__c,Preferred_Email__c,Email_Address__c
                                  From Contact
                                  Where Id In (Select ContactId From User Where Id = :UserInfo.getUserId())];
            }
            
        }//retrieve contact record for current user
        catch (Exception e)
        {
            System.debug(e.getMessage());
        }
    }//SyncLinkedInProfile()
    
    /// <summary>
    /// authorizeLinkedIn
    /// sends user to the allow access linkedin pages
    /// </summary>
    public PageReference authorizeLinkedIn(){
        //authorizeLinkedIn()
        
        /* build the url
https://www.linkedin.com/uas/oauth2/authorization?response_type=code
&client_id=YOUR_API_KEY
&scope=SCOPE
&state=STATE
&redirect_uri=YOUR_REDIRECT_URI
*/
        
        
        
        System.debug('@@@myEndPoint'+myEndPoint);
        //send to url
        PageReference pr = new PageReference(myEndPoint);
        pr.setRedirect(true);
        return pr;    
    }//authorizeLinkedIn()
    
    /// <summary>
    /// updateUser
    /// base method for retrieving the user tokens and syncing the information
    /// </summary>   
    public void updateUser()
    {//updateUser()
        
        string tokenRequest = 'new';
        Datetime currentDate= System.now();
        //System.Debug(storedToken);
        
        
        if (storedToken != null && storedToken != '')
        {//user has token stored in Salesforce
            
            // if (currentDate > currentUser.LinkedInExpire__c.addDays(-10))
            // {//token expired or expiring soon, request new token
            //     requestToken();
            // }//token expired or expiring soon, request new token
            
            //System.Debug(tokenRequest);
            
            //if token is ok, then make a call to sync the fields, otherwise display generic error
            if (tokenRequest == 'new' || tokenRequest == 'success')
                syncLinkedIn();
            else
                displayError = ERRORMESSAGE;
            
        }//user has token stored in Salesforce
        else if (stateParam.Length() > 0)
        {//no token, but state param exists
            
            if (userId == stateParam)
            {//stateparam matches
                tokenRequest = requestToken();
                if (tokenRequest == 'success')
                    syncLinkedIn();
                else
                    displayError = ERRORMESSAGE;
                
                //then sync the data
            }//stateparam matches
            else
            {//stateparam does not match
                displayError = ERRORMESSAGE;
                System.Debug('stateParameter does not match. url.stateparam = ' + stateParam + 'Userid = ' + UserInfo.getUserId());
            }//stateparam does not match
        }//no token, but state param exists            
        
        if (tokenRequest == 'success')
        {//token request was successfull, update the values on the user object
            
            // currentUser.LinkedInToken__c = storedToken;
            // currentUser.LinkedInExpire__c = currentDate.addYears(1);
            
            // update currentUser;
            
        }//token request was successfull, update the values on the user object
    }//updateUser()
    
    
    /// <summary>
    /// syncLinkedIn()
    /// syncs the data from LinkedIn to Salesforce
    /// </summary>
    public PageReference syncLinkedIn()
    {
        requestToken();
        Http h = new Http();
        HttpRequest req2 = new HttpRequest();
        HttpResponse res2 = new HttpResponse();
        
        
        req2.setEndpoint('https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,headline,location,industry,current-share,summary,specialties,api-standard-profile-request,public-profile-url,email-address,following,last-modified-timestamp,associations,interests,languages,skills,certifications,positions,three-current-positions,three-past-positions,picture-url)?format=json');

        req2.setHeader('Authorization', 'Bearer ' + storedToken);
        req2.setMethod('GET');
        try{
            res2 = h.send(req2);
        }
        catch(Exception ex){
            
        }
        string returninfo2 ;
        //make the request
        if(Test.isrunningtest()){
            String jsonRes='{';
            jsonRes+=' "apiStandardProfileRequest": {';
            jsonRes+='"headers": {';
            jsonRes+='  "_total": 1,';
            jsonRes+=' "values": [{';
            jsonRes+='   "name": "x-li-auth-token",';
            jsonRes+='  "value": "name:8OP4"';
            jsonRes+='}]';
            jsonRes+='  },';
            jsonRes+=' "url": "https://api.linkedin.com/v1/people/UiRqjbUpUM"';
            jsonRes+='},';
            jsonRes+='"emailAddress": "linkedinapi@babson.edu",';
            jsonRes+='"firstName": "Babson",';
            jsonRes+='"following": {';
            jsonRes+=' "companies": {';
            jsonRes+='  "_total": 2,';
            jsonRes+='  "values": [';
            jsonRes+=' {';
            jsonRes+='    "id": 6716,';
            jsonRes+='"name": "Babson College"';
            jsonRes+='},';
            jsonRes+=' {';
            jsonRes+='   "id": 697769,';
            jsonRes+='   "name": "Test"';
            jsonRes+=' }';
            jsonRes+=']';
            jsonRes+=' },';
            jsonRes+='"industries": {';
            jsonRes+='  "_total": 2,';
            jsonRes+=' "values": [';
            jsonRes+='   {"id": 80},';
            jsonRes+='   {"id": 68}';
            jsonRes+=' ]';
            jsonRes+=' },';
            jsonRes+='"people": {"_total": 0},';
            jsonRes+='"specialEditions": {"_total": 0}';
            jsonRes+='},';
            jsonRes+='"headline": "SSE at Test",';
            jsonRes+='"id": "UiRqjbUpUM",';
            jsonRes+='"industry": "Higher Education",';
            jsonRes+='"interests": "Golf, Reading, Gardening",';
            jsonRes+='"languages": {';
            jsonRes+=' "_total": 2,';
            jsonRes+='"values": [';
            jsonRes+='  {';
            jsonRes+='     "id": 502406354,';
            jsonRes+='     "language": {"name": "English"}';
            jsonRes+='  },';
            jsonRes+='  {';
            jsonRes+='    "id": 1,';
            jsonRes+='    "language": {"name": "Spanish"}';
            jsonRes+='  }';
            jsonRes+=']';
            jsonRes+='},';
            jsonRes+='"lastModifiedTimestamp": 1474210929674,';
            jsonRes+='"lastName": "AccountAPI",';
            jsonRes+='"location": {';
            jsonRes+='  "country": {"code": "us"},';
            jsonRes+=' "name": "Greater Boston Area"';
            jsonRes+='},';
            jsonRes+='"positions": {';
            jsonRes+='"_total": 4,';
            jsonRes+='"values": [';
            jsonRes+='  {';
            jsonRes+='   "company": {';
            jsonRes+='     "id": 6716,';
            jsonRes+='    "industry": "Higher Education",';
            jsonRes+='    "name": "Babson College",';
            jsonRes+='    "size": "501-1000",';
            jsonRes+='   "type": "Educational"';
            jsonRes+=' },';
            jsonRes+=' "id": 821162101,';
            jsonRes+=' "isCurrent": true,';
            jsonRes+=' "location": {},';
            jsonRes+='"startDate": {';
            jsonRes+='  "month": 3,';
            jsonRes+=' "year": 2015';
            jsonRes+=' },';
            jsonRes+='"summary": "Community Manager",';
            jsonRes+=' "title": "Babson Title1"';
            jsonRes+='},';
            jsonRes+='{';
            jsonRes+=' "company": {';
            jsonRes+='   "id": 697769,';
            jsonRes+='  "industry": "Marketing & Advertising",';
            jsonRes+='  "name": "Test",';
            jsonRes+='  "size": "myself only",';
            jsonRes+=' "type": "Self Employed"';
            jsonRes+='},';
            jsonRes+=' "id": 853355780,';
            jsonRes+=' "isCurrent": true,';
            jsonRes+=' "location": {';
            jsonRes+='  "country": {';
            jsonRes+='   "code": "us",';
            jsonRes+='   "name": "United States"';
            jsonRes+=' },';
            jsonRes+=' "name": "San Francisco Bay Area"';
            jsonRes+=' },';
            jsonRes+='"startDate": {';
            jsonRes+=' "month": 3,';
            jsonRes+='  "year": 2011';
            jsonRes+='  },';
            jsonRes+=' "summary": "Test Desc",';
            jsonRes+=' "title": "SSE"';
            jsonRes+=' },';
            jsonRes+=' {';
            jsonRes+='  "company": {"name": "Test Company"},';
            jsonRes+='  "id": 854489074,';
            jsonRes+=' "isCurrent": true,';
            jsonRes+='  "location": {"name": "Boston, MA"},';
            jsonRes+=' "startDate": {';
            jsonRes+='  "month": 2,';
            jsonRes+='   "year": 2010';
            jsonRes+=' },';
            jsonRes+='  "summary": "This is a test company and test position.",';
            jsonRes+='  "title": "CEO"';
            jsonRes+=' },';
            jsonRes+=' {';
            jsonRes+='  "company": {';
            jsonRes+='  "id": 162479,';
            jsonRes+='  "industry": "Consumer Electronics",';
            jsonRes+='  "name": "Apple",';
            jsonRes+='   "size": "10001+",';
            jsonRes+='   "ticker": "AAPL",';
            jsonRes+='    "type": "Public Company"';
            jsonRes+='  },';
            jsonRes+='"endDate": {';
            jsonRes+='    "month": 7,';
            jsonRes+='   "year": 2016';
            jsonRes+='  },';
            jsonRes+='  "id": 853739613,';
            jsonRes+='  "isCurrent": false,';
            jsonRes+='  "location": {"name": "Addd"},';
            jsonRes+='"startDate": {';
            jsonRes+='    "month": 4,';
            jsonRes+='    "year": 2015';
            jsonRes+='  },';
            jsonRes+=' "summary": "sdasdas",';
            jsonRes+='    "title": "CEO"';
            jsonRes+=' }';
            jsonRes+='  ]';
            jsonRes+='},';
            jsonRes+='"publicProfileUrl": "https://www.linkedin.com/in/babson-accountapi-420269123",';
            jsonRes+='"summary": "My interest is Entrepreneurship and Sustainibility.",';
            jsonRes+='"threeCurrentPositions": {';
            jsonRes+='"_total": 3,';
            jsonRes+='"values": [';
            jsonRes+='{';
            jsonRes+=' "company": {';
            jsonRes+='  "id": 6716,';
            jsonRes+='   "industry": "Higher Education",';
            jsonRes+='   "name": "Babson College",';
            jsonRes+='    "size": "501-1000",';
            jsonRes+='    "type": "Educational"';
            jsonRes+='  },';
            jsonRes+='  "id": 821162101,';
            jsonRes+=' "isCurrent": true,';
            jsonRes+=' "location": {},';
            jsonRes+=' "startDate": {';
            jsonRes+='   "month": 3,';
            jsonRes+='   "year": 2015';
            jsonRes+='  },';
            jsonRes+='  "summary": "Community Manager",';
            jsonRes+='  "title": "Babson Title1"';
            jsonRes+=' },';
            jsonRes+='{';
            jsonRes+='"company": {';
            jsonRes+='   "id": 697769,';
            jsonRes+=' "industry": "Marketing & Advertising",';
            jsonRes+='  "name": "Test",';
            jsonRes+='   "size": "myself only",';
            jsonRes+='   "type": "Self Employed"';
            jsonRes+=' },';
            jsonRes+=' "id": 853355780,';
            jsonRes+=' "isCurrent": true,';
            jsonRes+='"location": {';
            jsonRes+='   "country": {';
            jsonRes+='     "code": "us",';
            jsonRes+='     "name": "United States"';
            jsonRes+='   },';
            jsonRes+='   "name": "San Francisco Bay Area"';
            jsonRes+='  },';
            jsonRes+='  "startDate": {';
            jsonRes+='    "month": 3,';
            jsonRes+='    "year": 2011';
            jsonRes+='  },';
            jsonRes+='  "summary": "Test Desc",';
            jsonRes+='  "title": "SSE"';
            jsonRes+=' },';
            jsonRes+=' {';
            jsonRes+='  "company": {"name": "Test Company"},';
            jsonRes+='  "id": 854489074,';
            jsonRes+='  "isCurrent": true,';
            jsonRes+='  "location": {"name": "Boston, MA"},';
            jsonRes+=' "startDate": {';
            jsonRes+='   "month": 2,';
            jsonRes+='  "year": 2010';
            jsonRes+='},';
            jsonRes+='"summary": "This is a test company and test position.",';
            jsonRes+='  "title": "CEO"';
            jsonRes+='    }';
            jsonRes+='  ]';
            jsonRes+=' },';
            jsonRes+='"threePastPositions": {';
            jsonRes+=' "_total": 1,';
            jsonRes+='"values": [{';
            jsonRes+=' "company": {';
            jsonRes+='  "id": 162479,';
            jsonRes+='    "industry": "Consumer Electronics",';
            jsonRes+='    "name": "Apple",';
            jsonRes+='    "size": "10001+",';
            jsonRes+='    "ticker": "AAPL",';
            jsonRes+='    "type": "Public Company"';
            jsonRes+='  },';
            jsonRes+='  "endDate": {';
            jsonRes+='    "month": 7,';
            jsonRes+='    "year": 2016';
            jsonRes+='  },';
            jsonRes+='"id": 853739613,';
            jsonRes+='   "isCurrent": false,';
            jsonRes+='   "location": {"name": "Addd"},';
            jsonRes+='  "startDate": {';
            jsonRes+='     "month": 4,';
            jsonRes+='     "year": 2015';
            jsonRes+='   },';
            jsonRes+='   "summary": "sdasdas",';
            jsonRes+='   "title": "CEO"';
            jsonRes+='  }]';
            jsonRes+=' }';
            jsonRes+='}';
            returninfo2=jsonRes;
        }
        else{
            returninfo2= res2.getBody();    
        }
        
        
        jsonData = returninfo2;
        System.debug('@@@jsonData'+jsonData);  
        LinkedInProfile profile1 = LinkedInProfile.parse(returninfo2);
        System.debug('@@@LinkedInProfile.parse(returninfo2)'+profile1);  
        
        
        //check for errors
        if (returninfo2.contains('errorCode'))
        {//errors             
            if (returninfo2.contains('token used in this request has been revoked by the user'))
            {
                //need user to approve the sync again. delete stored tokens.
                //url='revoked';
                // currentUser.LinkedInExpire__c=null;
                // currentUser.LinkedInId__c = '';
                // currentUser.LinkedInToken__c = '';
                
                // update currentUser;
            }
            else
            {
                displayError = ERRORMESSAGE;
                System.Debug(returninfo2);
            }
        }//errors
        else
        {//no errors
            try{
                if (currentContact != null){
                    //make sure user has a contact record
                    LinkedInProfile profile = LinkedInProfile.parse(returninfo2);
                    currentContact.Linkedin_Sync_Time_Stamp__c=System.now();
                    
                    //initialize fields - if fields are blank or not present in LinkedIn, they need to be blanked out or deleted in Salesforce
                    currentContact.Email_Address__c = '';
                    currentContact.LinkedIn__c = '';
                    currentContact.LinkedIn_Interests__c = '';
                    currentContact.Associations__c = '';
                    currentContact.Specialties__c = '';
                    currentContact.Headline__c = '';
                    currentContact.Summary__c = '';
                    currentContact.Languages__c = '';
                    currentContact.Skills__c = '';
                    currentContact.Certifications__c = '';
                    currentContact.Following__c = '';
                    currentContact.Current_Share_Item__c = '';
                    currentContact.Summary_Primary_Job__c = '';
                    currentContact.Start_Date_Primary_Job__c = null;
                    currentContact.Company_Location__c = '';
                    currentContact.Past_Position_Primary_Job__c = '';
                    currentContact.Summary_Secondary_Job__c='';
                    currentContact.Start_Date_Secondary_Job__c=null;
                    currentContact.Summary_Tertiary_Job__c='';
                    currentContact.Start_Date_Tertiary_Job__c=null;
                    currentContact.Past_Position_Primary_Job__c='';
                    currentContact.Past_Position_Secondary_Job__c='';
                    currentContact.Past_Position_Tertiary_Job__c='';
                    currentContact.Secondary_Company_Location__c='';
                    currentContact.Tertiary_Company_Location__c='';
                    
                    //delete all affiliations for the user?
                    
                    hed__Affiliation__c[] aff = [Select Id, Title__c From hed__Affiliation__c WHERE hed__Contact__c  = :currentContact.Id];
                    
                    try
                    {
                        delete aff;
                    }
                    catch(DmlException e)
                    {
                        System.debug(e.getMessage());
                    }
                    
                    
                    
                    //set the properties
                    currentContact.Email_Address__c = profile.emailAddress;
                    currentContact.LinkedIn__c = profile.publicProfileUrl;
                    currentContact.LinkedIn_Interests__c = profile.interests;
                    currentContact.Associations__c = profile.associations;
                    currentContact.Specialties__c = profile.specialties;
                    currentContact.Headline__c = profile.headline;
                    if(String.isNotEmpty(profile.summary) && profile.summary.length()>255)
                        profile.summary= profile.summary.substring(0,255);
                    currentContact.Summary__c = profile.summary;
                    
                    
                    currentContact.Languages__c = retrieveLanguages(profile);
                    currentContact.Skills__c = retrieveSkills(profile);
                    currentContact.Certifications__c = retrieveCertifications(profile);
                    currentContact.Following__c = retrieveFollowing(profile);
                    
                    
                    if (profile.CurrentShare != null)
                        currentContact.Current_Share_Item__c = profile.CurrentShare.comment;
                    
                    if ((profile.ThreeCurrentPositions.total1 > 0) || (profile.threePastPositions.total1 > 0))
                    {
                        if (profile.ThreeCurrentPositions.total1 > 0 && profile.ThreeCurrentPositions.values.size()>0)
                        {
                            CORECONNECT__CC_Community_Content__c     content = new CORECONNECT__CC_Community_Content__c ();
                            List<CORECONNECT__CC_Community_Content__c> lstUserBusinessInfo = new List<CORECONNECT__CC_Community_Content__c>([SELECT Id, Name,Business_Description__c,Business_Summary__c,LineNo__c,Address_1__c,
                                                                                                                                             Address_2__c,Address_3__c,City__c,State_Province__c,Postal_Code__c,Country__c,Discount_Coupon_Code__c,My_Company_Discount__c,Family_Business__c,Start_up__c,Matching_Gift_Company__c,
                                                                                                                                             My_Company_Online__c,Phone__c,Website__c,Function__c,Level__c,Part_Time__c,I_am_the_CEO_President_Founder_or_Owne__c,Publish_Business__c,CORECONNECT__Classification1__c
                                                                                                                                             FROM CORECONNECT__CC_Community_Content__c 
                                                                                                                                             WHERE RecordType.Name = 'Business' 
                                                                                                                                             AND OwnerId =:UserInfo.getUserId() 
                                                                                                                                             AND LineNo__c != null
                                                                                                                                             AND LineNo__c like 'Business%']);
                        
                            Id devRecordTypeId = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
                            List<CORECONNECT__CC_Community_Content__c> contentList = new List<CORECONNECT__CC_Community_Content__c> ();
                            
                            Boolean bus1Exist=false;
                            Boolean bus2Exist=false;
                            Boolean bus3Exist=false;
                            for(CORECONNECT__CC_Community_Content__c ccContent:lstUserBusinessInfo){
                                if(profile.ThreeCurrentPositions.values.size()>0 && profile.ThreeCurrentPositions.values[0].isCurrent && 'Business 1'.equalsIgnoreCase(ccContent.LineNo__c)){
                                    blankCCObject(ccContent);
                                    ccContent.Name=profile.ThreeCurrentPositions.values[0].company.name;
                                    ccContent.Business_Industry__c=profile.ThreeCurrentPositions.values[0].company.industry; 
                                    bus1Exist=true;
                                }    
                                if(profile.ThreeCurrentPositions.values.size()>1 && profile.ThreeCurrentPositions.values[1].isCurrent && 'Business 2'.equalsIgnoreCase(ccContent.LineNo__c)){
                                    blankCCObject(ccContent);
                                    ccContent.Name=profile.ThreeCurrentPositions.values[1].company.name;
                                    ccContent.Business_Industry__c=profile.ThreeCurrentPositions.values[1].company.industry; 
                                    bus2Exist=true;
                                }
                                if(profile.ThreeCurrentPositions.values.size()>2 && profile.ThreeCurrentPositions.values[2].isCurrent && 'Business 3'.equalsIgnoreCase(ccContent.LineNo__c)){
                                    blankCCObject(ccContent);
                                    ccContent.Name=profile.ThreeCurrentPositions.values[2].company.name;
                                    ccContent.Business_Industry__c=profile.ThreeCurrentPositions.values[2].company.industry; 
                                    bus3Exist=true;
                                }
                            }
                            
                            if(lstUserBusinessInfo.size()>0)
                                Database.upsert(lstUserBusinessInfo,false);
                            if(!bus1Exist && profile.ThreeCurrentPositions.values.size()>0){
                                CORECONNECT__CC_Community_Content__c content1 = new CORECONNECT__CC_Community_Content__c ();
                                content1.RecordTypeId=devRecordTypeId;
                                content1.Name=profile.ThreeCurrentPositions.values[0].company.name;
                                content1.LineNo__c ='Business 1';
                                content1.Business_Industry__c=profile.ThreeCurrentPositions.values[0].company.industry; 
                                contentList.add(content1);
                            }
                            if(!bus2Exist && profile.ThreeCurrentPositions.values.size()>1 && profile.ThreeCurrentPositions.values[1].isCurrent){
                                CORECONNECT__CC_Community_Content__c content2 = new CORECONNECT__CC_Community_Content__c ();
                                content2.RecordTypeId=devRecordTypeId;
                                content2.Name=profile.ThreeCurrentPositions.values[1].company.name;
                                content2.LineNo__c ='Business 2';
                                content2.Business_Industry__c=profile.ThreeCurrentPositions.values[1].company.industry; 
                                contentList.add(content2);
                            }
                            if(!bus3Exist && profile.ThreeCurrentPositions.values.size()>2 && profile.ThreeCurrentPositions.values[2].isCurrent){
                                CORECONNECT__CC_Community_Content__c content3 = new CORECONNECT__CC_Community_Content__c ();
                                content3.RecordTypeId=devRecordTypeId;
                                content3.Name=profile.ThreeCurrentPositions.values[2].company.name;
                                content3.LineNo__c ='Business 3';
                                content3.Business_Industry__c=profile.ThreeCurrentPositions.values[2].company.industry; 
                                contentList.add(content3);
                            }
                            if(contentList.size()>0){
                                Database.insert(contentList,false);
                            }
                            
                            //only taking the primary job for release 1
                            if(String.isNotEmpty(profile.ThreeCurrentPositions.values[0].summary) && profile.ThreeCurrentPositions.values[0].summary.length()>255)
                                profile.ThreeCurrentPositions.values[0].summary= profile.ThreeCurrentPositions.values[0].summary.substring(0,255);
                            currentContact.Summary_Primary_Job__c = profile.ThreeCurrentPositions.values[0].summary;
                            if(null!=profile.ThreeCurrentPositions.values[0].startDate){
                                Date startDate = date.newInstance(profile.ThreeCurrentPositions.values[0].startDate.year, profile.ThreeCurrentPositions.values[0].startDate.month, 1);
                                currentContact.Start_Date_Primary_Job__c = startDate;
                            }
                            
                            
                            if(profile.ThreeCurrentPositions.values.size()>1){
                                if(String.isNotEmpty(profile.ThreeCurrentPositions.values[1].summary) &&profile.ThreeCurrentPositions.values[1].summary.length()>255)
                                    profile.ThreeCurrentPositions.values[1].summary= profile.ThreeCurrentPositions.values[1].summary.substring(0,255);
                                currentContact.Summary_Secondary_Job__c=profile.ThreeCurrentPositions.values[1].summary;
                                if(null!=profile.ThreeCurrentPositions.values[1].startDate.year){
                                    integer month=profile.ThreeCurrentPositions.values[1].startDate.month;
                                    if(profile.ThreeCurrentPositions.values[1].startDate.month==null)
                                        month=1;
                                        Date startDate = date.newInstance(profile.ThreeCurrentPositions.values[1].startDate.year, profile.ThreeCurrentPositions.values[1].startDate.month, 1);
                                    currentContact.Start_Date_Secondary_Job__c = startDate;
                                }    
                                
                                if(null!=profile.ThreeCurrentPositions.values[1].location)
                                    currentContact.Secondary_Company_Location__c = profile.ThreeCurrentPositions.values[1].location.name;
                                
                            }
                            if(profile.ThreeCurrentPositions.values.size()>2){
                                if(String.isNotEmpty(profile.ThreeCurrentPositions.values[2].summary) &&profile.ThreeCurrentPositions.values[2].summary.length()>255)
                                    profile.ThreeCurrentPositions.values[2].summary= profile.ThreeCurrentPositions.values[2].summary.substring(0,255);
                                currentContact.Summary_Tertiary_Job__c=profile.ThreeCurrentPositions.values[2].summary;
                                if(null!=profile.ThreeCurrentPositions.values[2].startDate.year){
                                    integer month=profile.ThreeCurrentPositions.values[2].startDate.month;
                                    if(profile.ThreeCurrentPositions.values[2].startDate.month==null)
                                        month=1;
                                    Date startDate = date.newInstance(profile.ThreeCurrentPositions.values[2].startDate.year, month, 1);
                                    currentContact.Start_Date_Tertiary_Job__c = startDate;
                                }

                                if(null!=profile.ThreeCurrentPositions.values[2].location)
                                    currentContact.Tertiary_Company_Location__c = profile.ThreeCurrentPositions.values[2].location.name;
                            }
                            
                            
                            if(null!=profile.ThreeCurrentPositions.values[0].location)
                                currentContact.Company_Location__c = profile.ThreeCurrentPositions.values[0].location.name;
                            
                            //delete all companies first?
                            
                            if(null!=profile.ThreeCurrentPositions.values[0].company){
                                content.name = profile.ThreeCurrentPositions.values[0].company.name;
                                content.Industry__c = profile.ThreeCurrentPositions.values[0].company.industry;
                            } 
                            
                            
                            try
                            {//update community content
                                
                                upsert content name;
                                
                            }//update community content
                            catch(DMLException e)
                            {
                                System.Debug(e.getMessage());
                            }
                            
                            hed__Affiliation__c newAff = new hed__Affiliation__c();
                            
                            newAff.Title__c = profile.ThreeCurrentPositions.values[0].title;
                            
                            newAff.hed__Contact__c = currentContact.Id;
                            
                            try
                            {//update affiliation
                                
                                upsert newAff ;
                                
                            }//update affiliation
                            catch(DMLException e)
                            {
                                System.Debug(e.getMessage());
                            }
                        }
                        if (profile.threePastPositions.total1 > 0)
                        {
                            currentContact.Past_Position_Primary_Job__c = profile.ThreePastPositions.values[0].title + ' @ ' + profile.ThreePastPositions.values[0].company.name;
                        }
                        if (profile.threePastPositions.total1 > 1)
                        {
                            currentContact.Past_Position_Secondary_Job__c = profile.ThreePastPositions.values[1].title + ' @ ' + profile.ThreePastPositions.values[1].company.name;
                        }
                        if (profile.threePastPositions.total1 > 2)
                        {
                            currentContact.Past_Position_Tertiary_Job__c = profile.ThreePastPositions.values[2].title + ' @ ' + profile.ThreePastPositions.values[2].company.name;
                        }
                        
                        
                    }
                    
                    try
                    {//update contact
                        System.debug('@@currentContact'+currentContact);
                        update currentContact;
                        displayError=currentContact.Name+' profile data was successfully imported from LinkedIn';
                        
                    }//update contact
                    catch(DMLException e)
                    {
                        displayError=' Error Occured while Linkedin Sync.Please contact System Admin!';
                        System.Debug(e.getMessage());
                    }
                }//make sure user has a contact record
                else{   
                    displayError=' Error Occured while Linkedin Sync.Please contact System Admin!';
                    System.Debug('no contact record');
                }//user has no contact record  
                
            }
            catch(Exception ex){
                System.debug('@@@ Error'+ex.getMessage());
                displayError=' Error Occured while Linkedin Sync.Please contact System Admin!';
            }
        }//no errors
        PageReference returnPage= Page.MyProfilePage;
        returnPage.getParameters().put('displayMsg',displayError);
        
        return returnPage;
    }
    
    public void blankCCObject(CORECONNECT__CC_Community_Content__c ccContent){
        ccContent.Business_Description__c = '';
        ccContent.Business_Summary__c = '';
        ccContent.Address_1__c = '';
        ccContent.Address_2__c = '';
        ccContent.Address_3__c = '';
        ccContent.City__c = '';
        ccContent.Country__c = '';
        ccContent.Postal_Code__c = '';
        ccContent.State_Province__c = '';
        ccContent.Discount_Coupon_Code__c = '';
        ccContent.My_Company_Discount__c =false;
        ccContent.Family_Business__c = '';
        ccContent.Start_up__c = '';
        ccContent.Matching_Gift_Company__c = false;
        ccContent.My_Company_Online__c = false;
        ccContent.Phone__c = '';
        ccContent.Website__c = '';
        ccContent.Function__c = '';
        ccContent.Level__c = '';
        ccContent.Part_Time__c = false;
        ccContent.I_am_the_CEO_President_Founder_or_Owne__c = false;
        ccContent.Publish_Business__c=false;
        ccContent.CORECONNECT__Classification1__c='';
        delete [SELECT id from Attachment WHERE parentId=:ccContent.id];
    }
    /// <summary>
    /// requestToken()
    /// request the access token from linkedIn
    /// </summary>
    @TestVisible private string requestToken()
    {
        
        
        string linkedInTokenUrl ='https://www.linkedin.com/uas/oauth2/accessToken';
        string redirect_uri = Label.Linkedin_Redirect_URL;
        string callbackEndpoint = '';
        string clientID =Label.LinkedIn_ClientId; 
        string clientSecret =Label.Linkedin_Secret;
        
        //build the endpoint
        callbackEndpoint = 'grant_type=authorization_code&code=' + codeParam;
        callbackEndpoint += '&redirect_uri=' + redirect_uri;
        callbackEndpoint += '&client_id=' + clientID;
        callbackEndpoint += '&client_secret='+ clientSecret; 
        
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        string accessToken='';
        
        try
        {//send request for token to LinkedIn
            
            req.setEndpoint(linkedInTokenUrl);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setHeader('Content-Length',string.valueOf(callbackEndpoint.length()));
            req.setBody(callbackEndpoint);
            
            res = http.send(req);
            
            string returninfo = res.getBody();
            System.debug('@@ returninfo'+returninfo);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(returninfo);    
            
            accessToken = (String) m.get('access_token');    
            
            Datetime currentDate= System.now();
            
            storedToken = accessToken;
            
        }//send request for token to LinkedIn
        catch(Exception e)
        {
            System.Debug(e.getMessage());
            
            return 'fail';
        }
        
        return 'success';
        
    }//requestToken()
    
    
    /// <summary>
    /// retrieveLanguages
    /// takes the list of languages returned and combines them into a string
    /// </summary>
    @TestVisible private string retrieveLanguages (LinkedInProfile profile)
    {//retrieveLanguages()
        string languages = '';
        
        if (profile.Languages != null)
        {
            for (LinkedInProfile.Values_x item : profile.Languages.values)
            {
                languages += item.language.name + ', ';
            }
            
            languages = languages.removeEnd(', ');
        }
        if(languages.length()>255){
            languages = languages.substring(0,255);
        }
        return languages;
        
    }//retrieveLanguages()
    
    /// <summary>
    /// retrieveCertifications
    /// takes the list of certifications returned and combines them into a string
    /// </summary>
    @TestVisible  private string retrieveCertifications (LinkedInProfile profile)
    {//retrieveCertifications()
        
        string certifications='';
        
        if (profile.Certifications != null)
        {
            for (LinkedInProfile.Values_Z item : profile.Certifications.values)
            {
                certifications += item.name + ', ';
            }
            
            certifications = certifications.removeEnd(', ');
        }
        if(certifications.length()>255){
            certifications = certifications.substring(0,255);
        }
        
        return certifications;
    }//retrieveCertifications()
    
    /// <summary>
    /// retrieveSkills
    /// takes the list of skills returned and combines them into a string
    /// </summary>
    @TestVisible  private string retrieveSkills (LinkedInProfile profile)
    {//retrieveSkills()
        
        string skills='';
        
        if (profile.Skills != null)
        {
            for (LinkedInProfile.Values_v item : profile.Skills.values)
            {
                skills += item.skill.name + ', ';
                
            }
            
            skills = skills.removeEnd(', ');
        }
        if(skills.length()>255){
            skills = skills.substring(0,255);
        }
        return skills;
        
    }//retrieveSkills()
    
    /// <summary>
    /// retrieveFollowing
    /// takes the list of skills returned and combines them into a string
    /// </summary>
    @TestVisible  private string retrieveFollowing (LinkedInProfile profile)
    {//retrieveFollowing()
        
        string following = '';
        string followingCompanies = '';
        string followingIndustries = '';
        IndustryCodes industries = new IndustryCodes();
        
        if (profile.Following != null)
        {
            if (profile.Following.companies.total1 > 0 )
            {//retrieve companies followed
                for (LinkedInProfile.Values_Z item : profile.Following.companies.values)
                {
                    followingCompanies += item.name + ', ';
                }
                
                followingCompanies = followingCompanies.removeEnd(', ');
            }//retrieve companies followed
            
            
            if (profile.Following.industries.total1 > 0)
            {//retrieve industries followed
                for (LinkedInProfile.Values_Y item : profile.Following.industries.values)
                {
                    followingIndustries += industries.IndustryCodes.get(item.id) + ', ';
                }
                
                followingIndustries = followingIndustries.removeEnd(', '); 
            }//retrieve industries followed
            
            //combine the industries and companies
            if (followingCompanies.length() > 0)
            {
                following += followingCompanies;
                if (followingIndustries.length() > 0)
                {
                    following += ', ' + followingIndustries;
                } 
            }
            else if (followingIndustries.length() > 0)
            {
                following += followingIndustries;
            }
        }        
        if(following.length()>255){
            following = following.substring(0,255);
        }
        System.debug('@@@@'+following);
        return following;
        
    } //retrieveFollowing()
    
}//END: class SyncLinkedInProfil