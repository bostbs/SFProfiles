public with sharing class BabsonPeopleController {

public String SearchString {
  get;
  set;
 }
 boolean isAdvancedSearch;
 public String title {
  get;
  set;
 }
 @TestVisible private User user; // added on 3_8_2017(line 10-13,29-32)
 public User getUser() {
  return user;
 }
 private final String communityUserId = UserInfo.getUserId(); // Current user


 public String strCountry {
  get;
  set;
 }
 public String strState {
  get;
  set;
 }
 public String strCity {
  get;
  set;
 }
 public String[] strArrayGraduateYear {
  get;
  set;
 }
 public String[] strArrayUnderGraduateYear {
  get;
  set;
 }
 public String[] strArrayCertificationYear {
  get;
  set;
 }
 public String[] strArrayIndustry {
  get;
  set;
 }
 public String[] strArraydegree {
  get;
  set;
 }
 public String[] strArrayPrograme {
  get;
  set;
 }
 
 public String[] strArrayConstituency {
  get;
  set;
 }

 
 public String strJobFunction {
  get;
  set;
 }
 //   public String strBusinessCity {get;set;}
 public String strBusinessState {
  get;
  set;
 }
 public String strBusinessCountry {
  get;
  set;
 }

 public String strFname {
  get;
  set;
 }
 public String strLname {
  get;
  set;
 }
 public String strMname {
  get;
  set;
 }
 
 public String strCompany {
  get;
  set;
 }
 public String strBCountry {
  get;
  set;
 }
 public String strBState {
  get;
  set;
 }
 public String strBCity {
  get;
  set;
 }

 public String strHomeCountry {
  get;
  set;
 }
 public String strHomeState {
  get;
  set;
 }
 public String strHomeCity {
  get;
  set;
 }
 public boolean iscalledOnload {
  get;
  set;
 }
 
 public Boolean bVentureBacker {
  get;
  set;
 }
 public Boolean following {
  get;
  set;
 }

 map < string, List < CORECONNECT__CC_Community_Content__c >> mapContactBusiness {
  get;
  set;
 }


 Integer userSize;
  
 private transient List < User > lisUser = new List < User > ();
 private List < Id > lstOfEntityId; // list of followed content

 private final Integer LIMIT_FOR_OTHERS = 1000;
 private final Integer PAGE_SIZE = 12;
 private final String LOGGED_IN_USER_ID = UserInfo.getUserId();
 public ApexPages.StandardSetController setController {
  get;
  set;
 }

 private String userBaseQuery;
 private String profileIdClause;
 private Set < String > profileIds = new Set < String > ();
 private Set < Id > setContactIds;
 boolean isConditionTRue;

 public class WrapUser {
  public user u {
   get;
   set;
  }
  public LIst < wrapBusiness > businessW {
   get;
   set;
  }
  public LIst < CORECONNECT__CC_Community_Content__c > business {
   get;
   set;
  }
  public boolean followed {
   get;
   set;
  }

  Public WrapUser(user u, boolean isFollowed, LIst < CORECONNECT__CC_Community_Content__c > business) {

   businessW = new LIst < wrapBusiness > ();
   businessW.clear();
   this.u = u;
   followed = isFollowed;
   businessW = new LIst < wrapBusiness > ();
   if (business != null && business.SIZE() > 0) {
    businessW.clear();
    for (CORECONNECT__CC_Community_Content__c oCC: business) {
     businessW.add(new wrapBusiness(oCC.name, oCC.id, oCC.I_am_the_CEO_President_Founder_or_Owne__c));
    }

   }

  }

 }
 public class wrapBusiness {
  public string name {
   get;
   set;
  }
  public string bId {
   get;
   set;
  }
  public boolean isCEO {
   get;
   set;
  }

  public wrapBusiness(string name, String bid, boolean isCEO) {
   this.name = name;
   this.bId = bid;
   this.isCEO = isCEO;

  }

 }

 public babsonPeopleController() {

  bVentureBacker = false;
  following = false;
  mapContactBusiness = new map < string, List < CORECONNECT__CC_Community_Content__c >> ();
  isAdvancedSearch = false;
  iscalledOnload = true;
  userSize = 0;

  //commented on 16042017 to not show users on page load

  if (setController == null) {
   if (!Test.isRunningTest()) {
    setController = new ApexPages.StandardSetController(Database.getQueryLocator(queryPeopleString()));
   } else if (Test.isRunningTEst()) {
    setController = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id from USER WHere name = 'test']));
   }
  }
  if (ApexPages.currentPage().getParameters().get('isBracker') == 'true') {
   bVentureBacker = true;
   adVancedSerach();
  }

  setController.setPageSize(PAGE_SIZE);
 }



 public List < WrapUser > ListOfUsers {

   get {
    List < User > lis = new List < User > ();
    List < WrapUser > lisW = new List < WrapUser > ();
    if (setController != null) {
     lis = setController.getRecords();
     if (lis.size() > 0) {
      for (User u: lis) {
       lisW.add(new WrapUser(u, false, mapContactBusiness.get(u.id)));
      }
     }
    }
    System.debug('lisUser==' + lisW);
    System.debug('lisUser==' + lisW.size());
    return lisW;
   }

  }
  /**
   * Action methods
   */
 public void adVancedSerach() {
  iscalledOnload = false;
  String searchQuery = '';
  userBaseQuery = '';
  boolean isCommunityCheck = false;
  boolean isAddressCheck = false;
  boolean isContactCheck = false;
  

  set < id > userIds = new set < id > ();
  Set < id > setContactIds = new Set < id > ();
  Set < id > setUserContact = new Set < id > ();
  Set < id > setUserId = new Set < id > ();
  Set < id > globalUserId = new Set < id > ();
  Set < id > addressId = new Set < id > ();

  String tempQuery;
  set < id > setUserAddressId = new set < id > ();

  if (!string.isBlank(searchString)) {
   searchString = searchString.normalizeSpace();
  }
  isAdvancedSearch = true;
  isConditionTRue = false;
  boolean isUserExist = false;
  boolean isGLobalSeach = false;
  boolean isGLobalAddSeach = false;
  string SearchStringtemp;



  if (following) {
   // String objSSFProfileId = [SELECT Id FROM Profile WHERE Name = 'Alumni Community - SSF'].Id;
   profileIdClause = followingProfileIds(communityUserId);
   // profileIdClause += ' AND profileId != \''+ objSSFProfileId  +'\''; //ignore ssf users
   System.debug('profileIdClause==>>>' + profileIdClause);

  } else {
   profileIdClause = BAB_Util.constructProfilesList(profileIds);
   System.debug('profileIdClause==>>>' + profileIdClause);
  }


  userBaseQuery = 'select Id,AboutMe, Contact.Name,Contact.Preferred_Email__c,Contact.Public_Preferred_Email__c, Contact.Affiliation_Display_Name__c,Constituency__c, SmallPhotoUrl, Department,Division, Contact.Title, email, Phone,Username,UserType, Contact.CompanyName__c from User' + profileIdClause + ' AND isActive = true AND CORECONNECT__CC_List_In_Directory__c = TRUE';
  tempQuery = userBaseQuery;

  searchQuery = userBaseQuery;
  if (!String.isEmpty(SearchString)) {
   SearchStringtemp = SearchString;
   SearchString = '\'%' + SearchString + '%\'';
   userBaseQuery += ' AND (Contact.firstName  Like ' + SearchString + ' OR Contact.LastName Like ' + SearchString + ' OR Contact.Birth_Name__c Like ' + SearchString + ')';
  }


  //========Address============

  if (!String.isEmpty(SearchString)) {
    system.debug('SearchString==>'+SearchString);
     string str = SearchStringtemp; 
     str = '%' + str + '%';
   for (hed__Address__c objAddress: [SELECT Id, hed__Parent_Contact__c
     FROM hed__Address__c
     WHERE hed__MailingCity__c LIke: str AND(hed__Address_Type__c = 'Home'
      OR hed__Address_Type__c = 'Home Town')
     AND Public_hed_MailingCity__c = true LIMIT 1000
    ]) {

    setUserAddressId.add(objAddress.hed__Parent_Contact__c);
   }

   isGLobalAddSeach = true;

  }
  // CC Comunity FUnction


  if (!String.isEmpty(SearchString)) {
     //SearchString = '%' + SearchString + '%';
     system.debug('SearchString==>'+SearchString);
     string str = SearchStringtemp; 
     str = '%' + str + '%';
     
     for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
              FROM CORECONNECT__CC_Community_Content__c
              WHERE (City__c like: str OR Title__c like: str or name like: str) AND REcordType.name = 'Business'
             ]) {

         userIds.add(obj.ownerId);
     }
   
   isGLobalSeach = true;
  }
  
  
  if(userIds.size()>0){
      userBaseQuery = userBaseQuery.removeEnd(')');
      userBaseQuery += ' OR id in : userIds )';
  }
  if(setUserAddressId.size()>0){
      userBaseQuery = userBaseQuery.removeEnd(')');
      userBaseQuery += ' OR contact.id in : setUserAddressId )';
  }
  if (!test.isRunningTest()) {
       userBaseQuery += ' AND Id !=: LOGGED_IN_USER_ID  ORDER BY lastName ASC LIMIT 300';
       System.debug('lstUser ===' + userBaseQuery);
  }

  lisUser = database.query(userBaseQuery);
  
  for(User  oU : lisUser){
      globalUserId.add(oU.id);
  
  }
  System.debug('globalUserId===='+globalUserId);
  userBaseQuery = tempQuery;
  
  
  //============== End of global Parameter =============================================================
  
  System.debug('userIds==='+userIds);
  System.debug('userIds==>> '+userIds);
   System.debug('setUserAddressId==='+setUserAddressId.size());
  System.debug('setUserAddressId== >>'+setUserAddressId);


  if (!String.isEmpty(strFname)) {

   strFname = '\'%' + strFname + '%\'';
   userBaseQuery += ' AND contact.firstName Like  ' + strFname;
   isContactCheck = true;
  }

  if (!String.isEmpty(strLname)) {
   strLname = '\'%' + strLname + '%\'';
   userBaseQuery += ' AND contact.LastName Like ' + strLname;
   isContactCheck = true;
  }

  if (!String.isEmpty(strMname)) {
   String tempInput = '\'%' + strMname + '%\'';
   userBaseQuery += ' AND (contact.Birth_Name__c Like ' + tempInput + ' AND contact.Public_Birth_Name__c =true)';
   isContactCheck = true;
  }
  if (strArrayPrograme != null && strArrayPrograme.size() > 0) {
   isContactCheck = true;
   userBaseQuery += ' AND ((contact.Graduate_Program__c in : strArrayPrograme AND contact.Public_Graduate_Program__c =true)  OR (contact.Undergraduate_Program__c in : strArrayPrograme AND contact.Public_Undergraduate_Program__c=true ) OR (contact.Certificate_Program__c in : strArrayPrograme AND contact.Public_Certificate_Program__c=true)) ';
  }

  if (strArrayGraduateYear != null && strArrayGraduateYear.size() > 0) {
   isContactCheck = true;
   userBaseQuery += ' AND ((contact.Graduate_Year__c in : strArrayGraduateYear ) OR (contact.Graduate_Preferred_Year__c in : strArrayGraduateYear ))';
  }
  if (strArrayUnderGraduateYear != null && strArrayUnderGraduateYear.size() > 0) {
   isContactCheck = true;
   userBaseQuery += ' AND ((contact.Undergraduate_Year__c IN : strArrayUnderGraduateYear ) OR (contact.Undergraduate_Preferred_Year__c IN : strArrayUnderGraduateYear))  ';
  }

  if (strArrayCertificationYear != null && strArrayCertificationYear.size() > 0) {
   isContactCheck = true;
   userBaseQuery += ' AND ((contact.Certificate_Degree_Year__c IN : strArrayCertificationYear ) OR (contact.Certificate_Preferred_Year__c IN : strArrayCertificationYear ))  ';
  }

  if (strArraydegree != null && strArraydegree.size() > 0) {
   isContactCheck = true;
   userBaseQuery += ' AND ((contact.Graduate_Degree__c in: strArraydegree AND contact.Public_Graduate_Degree__c =true ) OR (contact.Certificate_Degree__c in : strArraydegree AND contact.Public_Certificate_Degree__c =true) OR (contact.Degree__c in : strArraydegree AND contact.Public_Degree__c =true)) ';

  }

  if (strArrayIndustry != null && strArrayIndustry.size() > 0) {
   isContactCheck = true;
   string strIndustrySearchTerm = '(';
   for (string strTerm: strArrayIndustry) {
    strIndustrySearchTerm += ((strIndustrySearchTerm == '(' ? '' : ',') + '\'' + String.escapeSingleQuotes(strTerm) + '\'');
   }
   strIndustrySearchTerm += ')';
   userBaseQuery += ' AND Contact.Industry__c includes ' + strIndustrySearchTerm ;
  }

  if (bVentureBacker == true) {
   isContactCheck = true;
   userBaseQuery += ' AND (contact.Venture_Backer__c = ' + bVentureBacker + ' AND contact.Public_Venture_Backer__c = True)'; //not on user as well as contact
  }

  System.debug('searchQuery ==::' + userBaseQuery);


  //====CC Comunity Content ==============================================
    
    if (!String.isEmpty(strCompany)) {
        strCompany = '%' + strCompany + '%';
        if (isGLobalSeach == true) {
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                            FROM CORECONNECT__CC_Community_Content__c
                                                            WHERE Name like: strCompany AND REcordType.name = 'Business'
                                                            AND ownerid IN: userIds
                ]) {
            
                   setUserId.add(obj.ownerId);
            }
        }
        if (isCommunityCheck == false) {
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                            FROM CORECONNECT__CC_Community_Content__c
                                                            WHERE Name like: strCompany AND REcordType.name = 'Business'
                                                            ]) {
            
                setUserId.add(obj.ownerId);
            }
        }
        
        isCommunityCheck = true;
        userIds.clear();
        userIds.addAll(setUserId);
    
    }
    
  system.debug('userIds==>>>' + userIds);
  if (!String.isEmpty(title)) {
   setUserId.clear();
   title = '%' + title + '%';
   if((isGLobalSeach == true && userIds.size()>0) || isCommunityCheck == true ){
           for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Title__c, contact__c, ownerId
                                                            FROM CORECONNECT__CC_Community_Content__c
                                                            WHERE Title__c like: title AND REcordType.name = 'Business'
                                                            AND OwnerId IN: userIds
                                                           ]) {
                                                
               setUserId.add(obj.ownerId);
          }
   } else if (isCommunityCheck == false) {
        for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Title__c, contact__c, ownerId
                                                          FROM CORECONNECT__CC_Community_Content__c
                                                          WHERE Title__c like: title AND REcordType.name = 'Business'
                                                         ]) {

              setUserId.add(obj.ownerId);
         }

   }


   userIds.clear();
   userIds.addAll(setUserId);
   isCommunityCheck = true;
  }

   System.debug('userIds==>>titile'+userIds);

    if (!String.isEmpty(strCity)) {
        strCity = '%' + strCity + '%';
        setUserId.clear();
        if((isGLobalSeach == true && userIds.size()>0) || isCommunityCheck == true ){
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                            FROM CORECONNECT__CC_Community_Content__c
                                                            WHERE City__c like: strCity AND REcordType.name = 'Business'
                                                            AND OwnerId IN: userIds LIMIT 1000
                                                            ]) {
                                                            
                setUserId.add(obj.ownerId);
            }
        } else if (isCommunityCheck == false){
        for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                        FROM CORECONNECT__CC_Community_Content__c
                                                        WHERE City__c like: strCity AND REcordType.name = 'Business'
                                                        ]) {
            setUserId.add(obj.ownerId);
            }
        
        }
        
        userIds.clear();
        userIds.addAll(setUserId);
        isCommunityCheck = true;
    }
    if (!String.isEmpty(strBusinessState)){
        setUserId.clear();
        if((isGLobalSeach == true && userIds.size()>0) || isCommunityCheck == true ){
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                            FROM CORECONNECT__CC_Community_Content__c
                                                            WHERE State_Province__c = : strBusinessState AND REcordType.name = 'Business'
                                                            AND OwnerId IN: userIds
                                                            ]) {
            
                 setUserId.add(obj.ownerId);
            }
        } else  {
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                        FROM CORECONNECT__CC_Community_Content__c
                                                        WHERE State_Province__c = : strBusinessState AND REcordType.name = 'Business'
                                                        ]) {
                                                        
                setUserId.add(obj.ownerId);
            }
        
        }
        
        userIds.clear();
        userIds.addAll(setUserId);
        isCommunityCheck = true;
    }

    if (!String.isEmpty(strBusinessCountry)) {
        setUserId.clear();
        if((isGLobalSeach == true && userIds.size()>0) || isCommunityCheck == true ){
        
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                            FROM CORECONNECT__CC_Community_Content__c
                                                            WHERE Country__c = : strBusinessCountry AND REcordType.name = 'Business'
                                                            AND OwnerId IN: userIds
                                                            ]) {
                                                            
                setUserId.add(obj.ownerId);
            }
        }
        else {
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                            FROM CORECONNECT__CC_Community_Content__c
                                                            WHERE Country__c = : strBusinessCountry AND REcordType.name = 'Business'
                                                            ]) {
            
                setUserId.add(obj.ownerId);
            }
        
        }
        
        userIds.clear();
        userIds.addAll(setUserId);
        isCommunityCheck = true;
    }

    if (!String.isEmpty(strJobFunction)) {
        setUserId.clear();
        if((isGLobalSeach == true && userIds.size()>0) || isCommunityCheck == true ){
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
                                                            FROM CORECONNECT__CC_Community_Content__c
                                                            WHERE Function__c = : strJobFunction AND OwnerId IN: userIds AND REcordType.name = 'Business'
                                                            ]) {
                setUserId.add(obj.ownerId);
            }
        }
        else {
            for (CORECONNECT__CC_Community_Content__c obj: [SELECT Id, Function__c, contact__c, ownerId
            FROM CORECONNECT__CC_Community_Content__c
            WHERE Function__c = : strJobFunction AND REcordType.name = 'Business'
            ]) {
            
                setUserId.add(obj.ownerId);
            }
        }
        
        userIds.clear();
        userIds.addAll(setUserId);
        isCommunityCheck = true;
    }
    

  //=====================================   Address fields search ============


  if (!String.isEmpty(strHomeCity)) {
   
   strHomeCity = '%' + strHomeCity + '%';
   System.debug('isGLobalAddSeach === '+isGLobalAddSeach);
   System.debug('strHomeCity === '+strHomeCity);
   if (isGLobalAddSeach == true && setUserAddressId.size()>0) {
     
        for (hed__Address__c objAddress: [SELECT Id, hed__Parent_Contact__c
          FROM hed__Address__c
          WHERE hed__MailingCity__c = : strHomeCity AND(hed__Address_Type__c = 'Home'
           OR hed__Address_Type__c = 'Home Town')
          AND Public_hed_MailingCity__c = true AND hed__Parent_Contact__c IN: setUserAddressId LIMIT 1000
         ]) {
         addressId.add(objAddress.hed__Parent_Contact__c);
        
    }

   } else{
  
    for (hed__Address__c objAddress: [SELECT Id, hed__Parent_Contact__c
                                      FROM hed__Address__c
                                      WHERE(hed__Address_Type__c = 'Home Town'
                                      OR hed__Address_Type__c = 'Home') AND hed__MailingCity__c LIke: strHomeCity AND Public_hed_MailingCity__c = true
                                      LIMIT 1000
     ]) {

     addressId.add(objAddress.hed__Parent_Contact__c);

    }

   }

   setUserAddressId.clear();
   setUserAddressId.addAll(addressId);
   isAddressCheck = true;
  }
  System.debug('setUserAddressId === '+setUserAddressId);

  if (!String.isEmpty(strHomeState)) {
   addressId.clear();
   if ((isGLobalAddSeach == true && setUserAddressId.size()>0) || isAddressCheck == true ) {
     for (hed__Address__c objAddress: [SELECT Id, hed__Parent_Contact__c
                                       FROM hed__Address__c
                                       WHERE Mailing_State__c = : strHomeState AND(hed__Address_Type__c = 'Home'
                                       OR hed__Address_Type__c = 'Home Town')
                                       AND Public_hed_MailingState__c = true AND hed__Parent_Contact__c IN: setUserAddressId LIMIT 1000
     ]) {

     addressId.add(objAddress.hed__Parent_Contact__c);

    }

   } else {
    for (hed__Address__c objAddress: [SELECT Id, hed__Parent_Contact__c
      FROM hed__Address__c
      WHERE Mailing_State__c = : strHomeState AND(hed__Address_Type__c = 'Home'
       OR hed__Address_Type__c = 'Home Town')
      AND Public_hed_MailingState__c = true LIMIT 1000
     ]) {

     addressId.add(objAddress.hed__Parent_Contact__c);

    }

   }


   setUserAddressId.clear();
   setUserAddressId.addAll(addressId);
   isAddressCheck = true;
  }



  if (!String.isEmpty(strHomeCountry)) {
     addressId.clear();
    if ((isGLobalAddSeach == true && setUserAddressId.size()>0) || isAddressCheck == true ) {
         System.debug('strHomeCountry ==='+strHomeCountry);
         System.debug('setUserAddressId ==='+setUserAddressId);
         for (hed__Address__c objAddress: [SELECT Id, hed__Parent_Contact__c
                                         FROM hed__Address__c
                                         WHERE Mailing_Country__c = : strHomeCountry AND(hed__Address_Type__c = 'Home'
                                         OR hed__Address_Type__c = 'Home Town')
                                         AND Public_hed_MailingCountry__c = true and hed__Parent_Contact__c IN : setUserAddressId limit 10000
         ]) {
    
             addressId.add(objAddress.hed__Parent_Contact__c);
         }

   } else {
         for (hed__Address__c objAddress: [SELECT Id, hed__Parent_Contact__c
                                          FROM hed__Address__c
                                          WHERE Mailing_Country__c = : strHomeCountry AND (hed__Address_Type__c = 'Home'
                                          OR hed__Address_Type__c = 'Home Town')
                                          AND Public_hed_MailingCountry__c = true LIMIT 50000
         ]) {
    
            addressId.add(objAddress.hed__Parent_Contact__c);
        }

   }


   setUserAddressId.clear();
   setUserAddressId.addAll(addressId);
   isAddressCheck = true;
  }
  
  System.debug('setUserAddressId =='+setUserAddressId);

  //================================================================================================
  // Address chek ends here
  
  if (strArrayConstituency != null && strArrayConstituency.size() > 0) {
   string strCOnstituencySearchTerm = '(';
   for (string strTerm: strArrayConstituency) {
    strCOnstituencySearchTerm += ((strCOnstituencySearchTerm == '(' ? '' : ',') + '\'' + String.escapeSingleQuotes(strTerm) + '\'');
   }
   strCOnstituencySearchTerm += ')';
   System.debug('setUserContact==4' + setUserContact);
   userBaseQuery += ' AND Constituency__c includes ' + strCOnstituencySearchTerm;
   isContactCheck = true;
  }

  if (!String.isEMpty(searchString) ){
      System.debug('userIds===='+userIds.size());
       System.debug('isCommunityCheck==='+isCommunityCheck);
        System.debug('isContactCheck==='+isContactCheck);
         System.debug('isAddressCheck ==='+isAddressCheck);
         
      if(userIds.size()>0  &&  isCommunityCheck == false &&  isContactCheck == true && isAddressCheck == false  ){
             userBaseQuery += ' AND id in : userIds ';
             if( setUserAddressId.size()>0){
                 userBaseQuery += ' AND contact.id in : setUserAddressId ';
             }
      }
      
      if(userIds.size()>0  &&  isCommunityCheck == false &&  isContactCheck == false && isAddressCheck == false  ){
              userBaseQuery = userBaseQuery.removeEnd(')');
              userBaseQuery += ' OR id in : userIds )';
      }
      
      if(setUserAddressId.size()>0  &&  isCommunityCheck == false &&  isContactCheck == false && isAddressCheck == false  ){
              userBaseQuery = userBaseQuery.removeEnd(')');
              userBaseQuery += ' OR contact.id in : setUserAddressId )';
      }
      if(isCommunityCheck == true ){
          userBaseQuery += ' AND id in : userIds ';
      }
      
      if(isAddressCheck == true ){
         userBaseQuery += ' AND contact.id in : setUserAddressId ';
      }
  }
  if (String.isEMpty(searchString)){
      if(isAddressCheck == true ){
         userBaseQuery += ' AND contact.id in : setUserAddressId ';
      }
      if(isCommunityCheck == true ){
          userBaseQuery += ' AND id in : userIds ';
      }
  }
  
  


 

  if (Test.isRunningTest()) {
   userBaseQuery = 'select Id,AboutMe,contact.Public_Preferred_Email__c FROM User LIMIT 1';
  }
  if (!test.isRunningTest()) {
   userBaseQuery += ' ORDER BY lastName ASC LIMIT 300 ';
   System.debug('lstUser ===' + userBaseQuery);
  }


  if(isCommunityCheck == false &&  isContactCheck == false && isAddressCheck == false){
      
  }else{
      lisUser.clear();
  }



  if(!string.isEmpty(searchString) || isContactCheck == true || isAddressCheck == true || isCommunityCheck == true || following == true || bVentureBacker == true ){
  
      lisUser = database.query(userBaseQuery);
      setController = null;
      setController = new ApexPages.StandardSetController(Database.getQueryLocator(userBaseQuery));
      setController.setPageSize(PAGE_SIZE);
      System.debug('setController.getRecords()===' + setController.getRecords());
      for (User u: lisUser) {
           setUserContact.add(u.id);
        
          }
  }else{
        setController = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id from USER WHere name = 'test userhjkhkh']));
        setController.setPageSize(PAGE_SIZE);
        System.debug('setController.getRecords()===' + setController.getRecords());
  
  }

 
  

  List < CORECONNECT__CC_Community_Content__c > lstUserBusinessInfo = new List < CORECONNECT__CC_Community_Content__c > ([SELECT Id, ownerid, Name, contact__r.name, I_am_the_CEO_President_Founder_or_Owne__c
   FROM CORECONNECT__CC_Community_Content__c
   WHERE RecordType.Name = 'Business'
   AND OWNerId IN: setUserContact

   ORDER BY LineNo__c DESC
  ]);
  mapContactBusiness.clear();
  for (CORECONNECT__CC_Community_Content__c oCC: lstUserBusinessInfo) {

   if (mapContactBusiness.get(oCC.ownerid) == null) {
    mapContactBusiness.put(oCC.ownerid, new LIst < CORECONNECT__CC_Community_Content__c > {
     occ
    });

   } else {
    mapContactBusiness.get(oCC.ownerid).add(occ);

   }

  }
  System.debug('=====mapContactBusiness' + mapContactBusiness);
  if (mapContactBusiness != null && !mapContactBusiness.isEmpty()) {
   userSize = mapContactBusiness.size();
  }






 }
 public PageReference search() {
  //setController = new ApexPages.StandardSetController(Database.getQueryLocator(queryPeopleString()));
  setController.setPageSize(PAGE_SIZE);
  iscalledOnload = false;
  return null;
 }

 @TestVisible private String queryPeopleString() {
  // Profile ID where clause - either only where IDs are found in following, or from full ID list


  userBaseQuery = 'select Id,AboutMe, contact.Business_State__c, contactId,contact.Preferred_Email__c, Constituency__c,  contact.CompanyName__c, contact.Business_Country__c,contact.Business_City__c,Contact.Name, contact.Affiliation_Display_Name__c,SmallPhotoUrl, Department,Division, Contact.Title, email, Phone,Username,UserType, contact.Graduate_Year__c from User LIMIT 1';



  return userBaseQuery;
 }

 /* Method to fetch all Entity Subscription record which user has fetched */
 @TestVisible
 private String followingProfileIds(Id communityUserId) {

  // Query subscribtion results
  List < String > profileIds = new List < String > ();
  for (EntitySubscription entity: [SELECT Id, ParentId
    FROM EntitySubscription
    WHERE SubscriberId = : communityUserId
    ORDER BY CreatedDate DESC
    LIMIT 1000
   ]) {
   if (String.ValueOf(entity.ParentId).subString(0, 3) == '005') {
    profileIds.add((String) entity.ParentId);
    system.debug('parent id' + entity.ParentId);
   }
  }

  // Build string of results
  if (profileIds.isEmpty()) {

   return ' where Id = null ';
  }

  String idString = ' where (Id in (\'';
  Integer c = 1;
  for (String i: profileIds) {

   if (c != profileIds.size()) {
    idString += i + '\',\'';
   } else {
    idString += i + '\'';
   }
   c++;
  }
  idString += '))';

  system.debug('idString======' + idString);
  return idString;
 }



 /**
     Methods for pagination
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

 public Integer TotalPages {
  get {

   if (Math.mod(setController.getResultSize(), setController.getPageSize()) == 0) {
    //System.debug();
    return setController.getResultSize() / setController.getPageSize();
   } else {
    return setController.getResultSize() / setController.getPageSize() + 1;
   }

  }
 }

 public Integer SpecifiedPageNumber {
  get;
  set;
 }

 public void prevSet() {
  setController.previous();
 }


 public void nextSet() {
  setController.next();
 }

 public void GoToPage() {
  if (SpecifiedPageNumber != null) {
   setController.setpageNumber(SpecifiedPageNumber);
  }
 }

 public List < SelectOption > getGraduateYear() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = Contact.Class_Year__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }

 public List < SelectOption > getBusinessState() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = CORECONNECT__CC_Community_Content__c.State_Province__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getvalue(), picklistEntry.getlabel()));
  }
  return options;
 }

 /*public List<SelectOption> getConstituency() {

      List<SelectOption> options = new List<SelectOption>();
      List<Schema.PicklistEntry> lstPicklistEntry = USER.Constituency__c.getDescribe().getPicklistValues();
      
      options.add(new SelectOption('', 'None'));

      for(Schema.PicklistEntry picklistEntry : lstPicklistEntry) {
          options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
      }       
      return options; 
  } */

 public List < SelectOption > getIndustry() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = Contact.Industry__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }
 public List < SelectOption > getConstituency() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = Schema.User.Constituency__c.getDescribe().getPicklistValues();
  //DescribeFieldResult fieldResult = 

  //options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }

 public List < SelectOption > getJobFunction() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = hed__Affiliation__c.Job_Function__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }
 public List < SelectOption > getAdvJobFunction() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = CORECONNECT__CC_Community_Content__c.Function__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }

 public List < SelectOption > getBusinessCountry() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = Contact.Business_Country__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }
 public List < SelectOption > getHomeState() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = hed__Address__c.Mailing_State__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getvalue(), picklistEntry.getlabel()));
  }
  return options;
 }
 public List < SelectOption > getHomeCountry() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = hed__Address__c.Mailing_Country__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }


 public List < SelectOption > getDegrees() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = Contact.Degree1__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }
 
 public List < SelectOption > getPrograme() {

  List < SelectOption > options = new List < SelectOption > ();
  List < Schema.PicklistEntry > lstPicklistEntry = Contact.Program__c.getDescribe().getPicklistValues();

  options.add(new SelectOption('', 'None'));

  for (Schema.PicklistEntry picklistEntry: lstPicklistEntry) {
   options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
  }
  return options;
 }


 private string formatMultiSelectToSearchable(string str) {
  str = str.replace('[', '(');
  str = str.replace(']', ')');
  //str= str.replaceAll(', ',';');
  System.debug('==' + str);
  return str;
 }



}