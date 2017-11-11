/*
    * ClassName    : BAB_TestUtil
    * CreatedBy    : 7S
    * Description  : this is the Util class for all test classes
    * Created Date : 03/05/2016
*/ 
public with sharing class BAB_TestUtil {
     /**
    * Random words are required for testing 
    * as you will likely run into any word I can insert
    * during a test class and produce false test results.
    */
    public String createRandomWord() {
      
      String ret = 'User' + math.rint(math.random() * 100000)+'@appirio1.com';
      
      return ret;
    }
    
    public String createRandomNickname() {
      
      String ret = 'nickname' + math.rint(math.random() * 100000);
      
      return ret;
    }
    
    public BAB_TestUtil(){}
    
    public CORECONNECT__CC_Community_Content__c createCommunityContent(Id IdOfRecordType, String strName, Boolean isTrumpContent, Boolean isDefault){
        
        CORECONNECT__CC_Community_Content__c objCommunityContent = new CORECONNECT__CC_Community_Content__c(    RecordTypeId = IdOfRecordType, 
                                                                                                                Name = strName,
                                                                                                                CORECONNECT__FreeText_Desired_Publish_Date__c = date.today(),
                                                                                                                CORECONNECT__FreeText_End_Date__c = date.today()+1,
                                                                                                                CORECONNECT__Short_Description__c = 'Testing',
                                                                                                                CORECONNECT__Description__c = 'Testing Description',
                                                                                                                CORECONNECT__Community_Content_Status__c = 'Approved',
                                                                                                                Trump_Content__c = isTrumpContent,
                                                                                                                CORECONNECT__Classification1__c = 'Alumni Career Spotlights',
                                                                                                                CORECONNECT__Classification2__c = 'Atheltics/Sports',
                                                                                                                Default_Content__c = isDefault,
                                                                                                                CORECONNECT__Start_Date__c = date.today(),
                                                                                                                CORECONNECT__End_Date__c = date.today()+1,
                                                                                                                Interests__c = 'Arts',
                                                                                                                Affiliation_1__c = 'MBA  Blended Learning MBA',
                                                                                                                Publish_business__c = true);
        
        return objCommunityContent;
    }
    
    public CORECONNECT__CC_Community_Content__c createCommunityContent2(Id IdOfRecordType, String strName, Boolean isTrumpContent, Boolean isDefault){
        
        CORECONNECT__CC_Community_Content__c objCommunityContent = new CORECONNECT__CC_Community_Content__c(RecordTypeId = IdOfRecordType, 
            Name = strName,
            CORECONNECT__FreeText_Desired_Publish_Date__c = date.today(),
            CORECONNECT__FreeText_End_Date__c = date.today()+1,
            CORECONNECT__Short_Description__c = 'Testing',
            CORECONNECT__Description__c = 'Testing Description',
            CORECONNECT__Community_Content_Status__c = 'Approved',
            Trump_Content__c = isTrumpContent,
            CORECONNECT__Classification1__c = 'Blogs',
            CORECONNECT__Classification2__c = 'Arts',
            Default_Content__c = isDefault,
            Affiliation_2__c = 'U2023');
        
        insert new CORECONNECT__CC_Community_Content__c(RecordTypeId = IdOfRecordType, 
            Name = strName,
            CORECONNECT__FreeText_Desired_Publish_Date__c = date.today(),
            CORECONNECT__FreeText_End_Date__c = date.today()+1,
            CORECONNECT__Short_Description__c = 'Testing',
            CORECONNECT__Description__c = 'Testing Description',
            CORECONNECT__Community_Content_Status__c = 'Approved',
            Trump_Content__c = isTrumpContent,
            CORECONNECT__Classification1__c = 'Blogs',
            CORECONNECT__Classification2__c = 'Arts',
            Default_Content__c = isDefault,
            Interests__c = 'Arts',
            Publish_business__c = true
            );
        
        insert new CORECONNECT__CC_Community_Content__c(RecordTypeId = IdOfRecordType, 
            Name = strName,
            CORECONNECT__FreeText_Desired_Publish_Date__c = date.today(),
            CORECONNECT__FreeText_End_Date__c = date.today()+1,
            CORECONNECT__Short_Description__c = 'Testing',
            CORECONNECT__Description__c = 'Testing Description',
            CORECONNECT__Community_Content_Status__c = 'Approved',
            Trump_Content__c = isTrumpContent,
            CORECONNECT__Classification1__c = 'Blogs',
            CORECONNECT__Classification2__c = 'Arts',
            Default_Content__c = isDefault,
            Affiliation_1__c = 'MBA  Blended Learning MBA',
            Publish_business__c = true
        );
        
        insert new CORECONNECT__CC_Community_Content__c(RecordTypeId = IdOfRecordType, 
            Name = strName,
            CORECONNECT__FreeText_Desired_Publish_Date__c = date.today(),
            CORECONNECT__FreeText_End_Date__c = date.today()+1,
            CORECONNECT__Short_Description__c = 'Testing',
            CORECONNECT__Description__c = 'Testing Description',
            CORECONNECT__Community_Content_Status__c = 'Approved',
            Trump_Content__c = isTrumpContent,
            CORECONNECT__Classification1__c = 'Blogs',
            CORECONNECT__Classification2__c = 'Arts',
            Default_Content__c = isDefault,
            Region__c = 'AK-Alaska',
            Publish_business__c = true
            
        );
        
        insert new CORECONNECT__CC_Community_Content__c(RecordTypeId = IdOfRecordType, 
            Name = strName,
            CORECONNECT__FreeText_Desired_Publish_Date__c = date.today(),
            CORECONNECT__FreeText_End_Date__c = date.today()+1,
            CORECONNECT__Short_Description__c = 'Testing',
            CORECONNECT__Description__c = 'Testing Description',
            CORECONNECT__Community_Content_Status__c = 'Approved',
            Trump_Content__c = isTrumpContent,
            CORECONNECT__Classification1__c = 'Blogs',
            CORECONNECT__Classification2__c = 'Arts',
            Default_Content__c = isDefault,
            Industry__c = 'Accounting',
            Business_Location_Classification_Filter__c = 'ALL',
            Business_Industry__c = 'Accounting',
            Publish_business__c = true
        );
        
        return objCommunityContent;
    }
    
    public AlumniCommunity__c createAlumniCommunity(){
        
        AlumniCommunity__c objAlumni = new AlumniCommunity__c(Name = 'Alumni',UnAuth_Home_Logo__c = 'test');
        
        return objAlumni;
    }


  
  public AlumniCommunityL2Pages__c createAlumniL2Settings(){
    
    AlumniCommunityL2Pages__c objAlumni = new AlumniCommunityL2Pages__c(Name = 'Alumni',CWA_Splash_Image__c = 'test');
    
    return objAlumni;
  }
    
    public CORECONNECT__CC_System_Settings__c createCoreconnectSystemSettings(){
        
        CORECONNECT__CC_System_Settings__c objCoreconnectSystemSettings = new CORECONNECT__CC_System_Settings__c(   Name = 'Alumni', 
                                                                                                                    CORECONNECT__Site_Admin_Email__c = 'Test@test.com',
                                                                                                                    CORECONNECT__Automated_News_Filtering__c = true,
                                                                                                                    CORECONNECT__Guest_Profile_Name__c = 'Test',
                                                                                                                    CORECONNECT__Automated_Events_Filtering__c = true,
                                                          CORECONNECT__Login_URL__c = 'Test',
                                                          CORECONNECT__Logout_URL__c = 'Test',
                                                          CORECONNECT__Show_Getting_Started_Link__c = false
                                                          );
                                
        return objCoreconnectSystemSettings;
    }
    
    public User createUser(){
        
         Id profileId = [SELECT Id FROM Profile WHERE Name =: 'System Administrator' LIMIT 1].Id;
         
         User objUser = new User(   alias = 'uisgs', email='testtest@test.com',
                                    emailencodingkey='UTF-8', lastname='Tessst', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = profileId, CORECONNECT__Classification1__c = 'Events', CORECONNECT__Classification2__c= 'N/A', CORECONNECT__Classification3__c= 'N/A',
                                    timezonesidkey='America/Los_Angeles', username='test028@testtest.com'); 

         return objUser;
    }
    
    public AlumniCommunityPersonalization__c createAlumniComPersonalization(){
        
        AlumniCommunityPersonalization__c objAlumniComPersonalization = new AlumniCommunityPersonalization__c(  Name = 'Alumni',
                                                                                                                Content_Personalization_Field_1__c = 'Region__c',
                                                                                                                Content_Personalization_Field_2__c = 'Affiliation_1__c',
                                                                                                                Content_Personalization_Field_3__c = 'Interests__c',
                                                                                                                Content_Personalization_Field_4__c = 'Affiliation_2__c',
                                                                                                                Content_Personalization_Field_5__c = 'Affinities__c',
                                                                                                                Content_Personalization_Field_6__c = 'Industry__c',
                                                                                                                User_Personalization_Field_1__c = 'Region__c',
                                                                                                                User_Personalization_Field_2__c = 'Affiliation_1__c',
                                                                                                                User_Personalization_Field_3__c = 'Interests__c',
                                                                                                                User_Personalization_Field_4__c = 'Affiliation_2__c',
                                                                                                                User_Personalization_Field_5__c = 'Affinities__c',
                                                                                                                User_Personalization_Field_6__c = 'Industry__c',
                                                                                                                Content_Type_Home_Page_Tile_1__c = 'ScheduledContent',
                                                                                                                Content_Type_Home_Page_Tile_2__c = 'Venture',
                                                                                                                Content_Type_Home_Page_Tile_3__c = 'ScheduledContent',
                                                                                                                Content_Type_Home_Page_Tile_4__c = 'Business',
                                                                                                                Content_Type_Home_Page_Tile_5__c = 'FreeText',
                                                                                                                Content_Type_Home_Page_Tile_6__c = 'Job');
        return objAlumniComPersonalization;
    }
    
    public Attachment createAttachment(Id ParentId, String strName){
        
        Attachment att = new Attachment(    ParentId = ParentId, 
                                            Name = strName,
                                            description = strName,
                                            Body = Blob.valueOf('Test Attachment Body'));
        
        return att;
    }
    
    public EntitySubscription createEntitySubscription(Id ParentId, Id subscriberId){
        
        EntitySubscription objEntitySubscription = new EntitySubscription(  ParentId = ParentId,
                                                                            SubscriberId = subscriberId);
        
        return objEntitySubscription;
    }
    
    public User createCommunityUser(){
        Id profileId = [Select Id 
            From Profile 
            Where Name = 'Alumni Community - SSF'
            Limit 1].Id;  

        Account a = new Account(Name='Test Account Name');
          insert a;
         
          Contact c = new Contact(LastName = 'Contact Last Name', FirstName='Contact firstname' , AccountId = a.id,
                                                          January__c = 'Home 1',
                                                          February__c = 'Home 1',
                                                          March__c = 'Home 1',
                                                          April__c = 'Home 1',
                                                          May__c = 'Home 1',
                                                          June__c = 'Home 1',
                                                          July__c = 'Home 1',
                                                          August__c = 'Home 1',
                                                          September__c = 'Home 1',
                                                          October__c = 'Home 1',
                                                          November__c = 'Home 1',
                                                          December__c = 'Home 1',
                                                          Preferred_Email__c = 'test@test.com');
          insert c;
         
          User user = new User();
          user.ProfileID = profileId;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = this.createRandomWord();  //'test@appirio1.com';
          user.CommunityNickname =this.createRandomNickname() ;//'testUser123';
          user.Alias = 't1';
          user.Email = 'no@email.com';
          user.IsActive = true;
          user.ContactId = c.Id;
          user.CORECONNECT__Classification1__c = 'Events';
          user.CORECONNECT__Classification2__c= 'N/A';
 
        insert user;
        return user;
        
       /* Id profileId = [Select Id 
            From Profile 
            Where Name = 'Alumni Community - Alumni'
            Limit 1].Id;  

          Account a = new Account(Name='Test Account Name', Ownerid=UserInfo.getuserid());
          insert a;
         
          Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id, Interests__c = 'Arts',Affiliation_1__c = 'MBA  Blended Learning MBA',
                                                                                                                Region__c = 'AK-Alaska',
                                                                                                                Industry__c = 'Accounting',
                                                                                                                Affiliation_2__c = 'U2023',
                                                                                                                Affinities__c = 'Undergraduate Advisory Board',
                                                          January__c = 'Home 1',
                                                          February__c = 'Home 1',
                                                          March__c = 'Home 1',
                                                          April__c = 'Home 1',
                                                          May__c = 'Home 1',
                                                          June__c = 'Home 1',
                                                          July__c = 'Home 1',
                                                          August__c = 'Home 1',
                                                          September__c = 'Home 1',
                                                          October__c = 'Home 1',
                                                          November__c = 'Home 1',
                                                          December__c = 'Home 1',
                                                          Preferred_Email__c = 'test@test.com',
                                                          FirstName = 'TestFirstName');
          insert c;
         
          User user = new User();
          user.ProfileID = profileId;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = 'test123456@appirio.com';   
          user.CommunityNickname = 'testUser123456';
          user.Alias = 'tu12345';
          user.Email = 'no@email.com';
          user.IsActive = true;
          user.ContactId = c.Id;
          user.CORECONNECT__Classification1__c = 'Events';
          user.CORECONNECT__Classification2__c= 'N/A';
          user.UserRole.Name='Alumni Community - Community Manager' ; 
         insert user;
         return user; */
    }
    
    /*
    public hed__Affiliation__c createAffiliation(Id AccId, Id ContactId){
        
        hed__Affiliation__c testAffiliation = new hed__Affiliation__c(hed__Account__c = AccId, hed__Contact__c = ContactId);
        insert testAffiliation;
        return testAffiliation;
    }*/
    
    public hed__Address__c createAddress(Id AccId, Boolean isDefault,String addressType, String addressLineNo){
        
        hed__Address__c testAddress = new hed__Address__c(hed__Parent_Account__c = AccId, hed__Default_Address__c = isDefault, hed__Address_Type__c = addressType, Address_Line_No__c = addressLineNo);
        insert testAddress;
        return testAddress;
    }
    

    public User createSSFCommunityUser(){
        
        Id profileId = [Select Id 
            From Profile 
            Where Name = 'Alumni Community - SSF'
            Limit 1].Id;  

        Account a = new Account(Name='Test Account Name');
          insert a;
         
          Contact c = new Contact(FirstName = 'Contact First Name',LastName = 'Contact Last Name', AccountId = a.id,
                                                          January__c = 'Home 1',
                                                          February__c = 'Home 1',
                                                          March__c = 'Home 1',
                                                          April__c = 'Home 1',
                                                          May__c = 'Home 1',
                                                          June__c = 'Home 1',
                                                          July__c = 'Home 1',
                                                          August__c = 'Home 1',
                                                          September__c = 'Home 1',
                                                          October__c = 'Home 1',
                                                          November__c = 'Home 1',
                                                          December__c = 'Home 1',
                                                          Preferred_Email__c = 'test@test.com');
          insert c;
         
          User user = new User();
          user.ProfileID = profileId;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = this.createRandomWord();  //'test@appirio1.com';
          user.CommunityNickname =this.createRandomNickname() ;//'testUser123';
          user.Alias = 't1';
          user.Email = 'no@email.com';
          user.IsActive = true;
          user.ContactId = c.Id;
          user.CORECONNECT__Classification1__c = 'Events';
          user.CORECONNECT__Classification2__c= 'N/A';
 
        insert user;
        return user;
    }
    
    //create community content records
    public List<CORECONNECT__CC_Community_Content__c> createCommunityContent(Integer noOfRecords, Id IdOfRecordType, String name){
        
        List<CORECONNECT__CC_Community_Content__c> lstCommunityContent = new List<CORECONNECT__CC_Community_Content__c>();
        
        for(integer i=0;i < noOfRecords; i++){
            
            lstCommunityContent.add( new CORECONNECT__CC_Community_Content__c(  RecordTypeId = IdOfRecordType, 
                                                                                Name = name+' '+i,
                                                                                CORECONNECT__FreeText_Desired_Publish_Date__c = date.today(),
                                                                                CORECONNECT__FreeText_End_Date__c = date.today()+1,
                                                                                CORECONNECT__Short_Description__c = 'Job Ventures',
                                                                                CORECONNECT__Description__c = 'Testing Description',
                                                                                CORECONNECT__Community_Content_Status__c = 'Approved',
                                                                                Trump_Content__c = true,
                                                                                CORECONNECT__Classification1__c = 'Alumni Career Spotlights',
                                                                                CORECONNECT__Classification2__c = 'Atheltics/Sports',
                                                                                Default_Content__c = false,
                                                                                CORECONNECT__Start_Date__c = date.today(),
                                                                                CORECONNECT__End_Date__c = date.today()+1, 
                                                                                Interests__c = 'Arts',
                                                                                Affiliation_1__c = 'MBA  Blended Learning MBA'));
                                                                                                                    
        }
        
        insert lstCommunityContent;
        return lstCommunityContent;
    }
    
    
    //insert  content version
    public List<ContentVersion> createContentVersionFiles(Integer noOfRecords,Id networkId){
        List<ContentVersion> testContentInsert = new List<ContentVersion>(); 
        
        for(integer i=0;i < noOfRecords; i++){
            
            ContentVersion objTestContentInsert = new ContentVersion();
            objTestContentInsert.ContentURL = '<a target="_blank" href="http://www.google.com/" rel="nofollow">http://www.google.com/</a>'; 
            objTestContentInsert.Title ='Test '+i; 
            objTestContentInsert.Description = 'test '+i;
            objTestContentInsert.NetworkId = networkId;
        
            testContentInsert.add(objTestContentInsert);
        }
        
        insert testContentInsert; 
        return testContentInsert;
        
    }
    
    //insert collaboration groups
    public List<CollaborationGroup> createGroups(Integer noOfRecords,Id networkId){
        
        List<CollaborationGroup> testGroupList = new List<CollaborationGroup>(); 
        
        for(integer i=0;i < noOfRecords; i++){
            
            CollaborationGroup newGroup = new CollaborationGroup(Name='Test'+i, NetworkId = networkId, CollaborationType = 'Private');
            testGroupList.add(newGroup);
        }
        
        insert testGroupList;
        return testGroupList;
    }
    
    public List<User> createCommunityUsersWithAffiliations(Integer numberOfUsers){
        
        Id profileId = [Select Id 
                    From Profile 
                    Where Name = 'Alumni Community - Alumni'
                    Limit 1].Id;  
        
        List<Account> lstAccount = new List<Account>();
        for(integer i=0;i < numberOfUsers; i++){
            
            Account a = new Account(Name='Test Account Name'+i);
            lstAccount.add(a);
        }    
        insert lstAccount;
        
        List<Contact> lstContact = new List<Contact>();
        for(integer i=0;i < numberOfUsers; i++){
            
            Contact c = new Contact(FirstName='Contact First Name'+i,LastName = 'Contact Last Name'+i, AccountId = lstAccount[i].id, companyName__c = 'Contact Last Name', public_companyName__c = true,
                                                          January__c = 'Home 1',
                                                          February__c = 'Home 1',
                                                          March__c = 'Home 1',
                                                          April__c = 'Home 1',
                                                          May__c = 'Home 1',
                                                          June__c = 'Home 1',
                                                          July__c = 'Home 1',
                                                          August__c = 'Home 1',
                                                          September__c = 'Home 1',
                                                          October__c = 'Home 1',
                                                          November__c = 'Home 1',
                                                          December__c = 'Home 1',
                                                          Preferred_Email__c = 'test@test.com');
            lstContact.add(c);
        }
        insert lstContact;
        
        List<hed__Affiliation__c> lstAffiliation = new List<hed__Affiliation__c>();
        for(integer i=0;i < numberOfUsers; i++){
            
            hed__Affiliation__c objAffiliation = new hed__Affiliation__c(hed__Account__c = lstAccount[i].id, hed__Contact__c = lstContact[i].id, Job_Function__c = 'affiliate', Public_Job_Function__c = true);
            lstAffiliation.add(objAffiliation);
        }    
        insert lstAffiliation;
        
        
        List<User> lstUser = new List<User>();
        
        for(integer i=0;i < numberOfUsers; i++){
          
          User user = new User();
          user.ProfileID = profileId;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = 'test'+i+'@appirio.com';   
          user.CommunityNickname = 'testUser'+i;
          user.Alias = 't1';
          user.Email = 'no'+i+'@email.com';
          user.IsActive = true;
          user.ContactId = lstContact[i].Id;
          user.CORECONNECT__Classification1__c = 'Events';
          user.CORECONNECT__Classification2__c= 'N/A';
          
          lstUser.add(user);
        }
        
        insert lstUser;
        return lstUser;
    }

    public CORECONNECT__CC_Header_Footer_Settings__c createHeaderFooterSettings(){
      CORECONNECT__CC_Header_Footer_Settings__c cf= new CORECONNECT__CC_Header_Footer_Settings__c(CORECONNECT__Header_Link_1_URL__c='test.test@test',Name='Alumni');
      return cf;
    }
    
    
}