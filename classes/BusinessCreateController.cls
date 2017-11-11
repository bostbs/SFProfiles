public with sharing class BusinessCreateController {
    
    public CORECONNECT__CC_Community_Content__c CC {
        get;set;
    }

    public Attachment att {
        get{
             if (att == null)
                     att = new Attachment();
            return att;
        }
        set;
    }

    public Integer userBusinessCount {
        get{
            Integer count = [SELECT Count()
                FROM CORECONNECT__CC_Community_Content__c 
                WHERE RecordType.Name = 'Business' 
                AND OwnerId =: UserInfo.getUserId() 
                AND LineNo__c != null];

            return count;
        }
        set;
    }
    
    // public Id addId {get;set;}
    public String businessId {get;set;}
    public Map<String,string> mpStates{get;set;}
    
    private Boolean isValid;
    
    public BusinessCreateController() {
        
        CC = new CORECONNECT__CC_Community_Content__c();
        businessId = (ApexPages.currentPage().getParameters().containsKey('Id') && ApexPages.currentPage().getParameters().get('Id') != '') ? ApexPages.currentPage().getParameters().get('Id') : '';
        
        if(String.isNotBlank(businessId)) {
            
            try {
                CC = [  SELECT Id, Name, Business_Summary__c, Business_Descriptions__c, Title__c,
                                Default_Content__c, Trump_Content__c, CORECONNECT__Classification1__c, Business_Location_Classification_Filter__c, Business_Industry__c,
                                Affiliation_1__c, Affiliation_2__c, Affinities__c, Interests__c, Industry__c, Region__c, CORECONNECT__Location__c, Phone__c,
                                Email__c ,My_Company_Discount__c, ownerId, Publish_Business__c, Level__c, Function__c, Family_Business__c, Start_up__c, Matching_Gift_Company__c,
                                Website__c, Part_Time__c, My_Company_Online__c, Discount_Coupon_Code__c,  Address_1__c, Address_2__c, Address_3__c,
                                City__c, State_Province__c, Country__c, Postal_Code__c,I_am_the_CEO_President_Founder_or_Owne__c
                        FROM CORECONNECT__CC_Community_Content__c
                        WHERE Id =: businessId]; 
            }
            catch(Exception e) {
                
                CC = new CORECONNECT__CC_Community_Content__c();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No record found'));
            }
        }
        
        CC.RecordTypeId = [select Id from RecordType where DeveloperName = 'Business' ] [0].id;
        
    }
    
    public PageReference goToBusinessDirectoryPage(){
        
        if(String.isNotBlank(businessId)) {
            
            isValid = (businessId InstanceOf ID) ? true : false ;
            
            if(!isValid){
                
                return Page.BusinessDirectory;
                
            } else if(isValid && (CC.ownerId != UserInfo.getUserId() && CC.Publish_Business__c == false)){

                return  new PageReference(Page.BusinessDetail.getURL()+'?id='+ businessId);
            }
        }
        return null;
    }
    
    public PageReference createBusinessRecord(){
        
        if(!validateForBusinessRecord()){
            return null;
        }
        
        CC.RecordTypeId = [select Id from RecordType where DeveloperName = 'Business' ] [0].id;
       /* Schema.DescribeFieldResult fieldResult = hed__Address__c.Mailing_State__c.getDescribe();
        for(Schema.PicklistEntry ple: fieldResult.getpicklistvalues()){
            mpStates.put(ple.getvalue(),ple.getlabel());                            
        }  */
        User userContact = [Select contact.Affiliation_1__c,contact.Affiliation_2__c from user Where Id = :UserInfo.getUserId()];
        System.debug('userContact ==>>'+userContact.contact.Affiliation_1__c );
        System.debug('userContact ==>>22'+userContact.contact.Affiliation_2__c);
        if(userContact.contact.Affiliation_1__c!=null){
            cc.Affiliation_1__c = userContact.contact.Affiliation_1__c;
        }
        if(userContact.contact.Affiliation_2__c!=null){
            cc.Affiliation_2__c= userContact.contact.Affiliation_2__c;
        }
        
        // Update Business number as next number, when creating Business.
        if(CC.Id == null) {
            
            Integer index = 1;
        
            for(CORECONNECT__CC_Community_Content__c objCC : [  SELECT LineNo__c
                                                                FROM CORECONNECT__CC_Community_Content__c
                                                                WHERE OwnerId =: UserInfo.getUserId()
                                                                AND LineNo__c <> null
                                                                AND LineNo__c like 'Business %'
                                                                order by LineNo__c ASC
                                                                limit 1
                                                            ]) {
                index = Integer.valueOf(objCC.LineNo__c.split(' ')[1]) + 1;
            }
            
            CC.LineNo__c = 'Business ' + String.valueOf(index);
        }
        
        return submit(Page.BusinessDirectory.getURL()); //+'?thankyou=true');
      
    }
   
    @TestVisible
    private PageReference submit(String business){
        
        if(String.isBlank(businessId)) {
            CC.CORECONNECT__Community_Content_Status__c = 'Created';
        }

        // insert a record
        try{ 
             if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()){
                 
                 upsert CC; 
                //  addId = CC.Id;
                 
                 /*insertNewTopic(addId);*/
             }
        } catch(DMLException de){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Save Error'));
            return null;

        }
     
        att.OwnerId = UserInfo.getUserId();
        att.ParentId = CC.Id; 

        if(att.body != null && att.ParentId != null){
            try {
                if(!Test.isRunningTest() && Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()) {
                    insert att;
                }
            } catch (DMLException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Upload Error'));
                if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isDeletable()){
                    delete CC; 
                }
                CC = new CORECONNECT__CC_Community_Content__c();
                return null;
            } finally {
                att = new Attachment();
            }
        }
        
            
         CC = new CORECONNECT__CC_Community_Content__c();
         att = new Attachment();
         
        return  new PageReference(business);
    }

    public PageReference cancelBusinessRecord(){
         CC = new CORECONNECT__CC_Community_Content__c();
         att = new Attachment();
         return Page.BusinessDirectory;
    }
    
    private Boolean validateForBusinessRecord(){
        
        Boolean val = true;
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Name)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Title_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Business_Summary__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Create_Business_Summary_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Business_Descriptions__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Create_Business_Full_Description_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Classification1__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Create_Business_Classification1_Required));
            val = false;
        }
        /* if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Business_Location_Classification_Filter__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Business_Classification2_Required)); 
            val = false;
        } */
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Business_Industry__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Business_Classification3_Required)); 
            val = false;
        }
        
        if(CC.Trump_Content__c == true && CC.Default_Content__c == true){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Job_Default_Content));
            val=false;
        }
        
        //if(!CC.I_am_the_CEO_President_Founder_or_Owne__c && CC.Publish_Business__c) {
            
        //    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Publish_Business_While_CEO));
        //    val=false;
        //}

        if (!val){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Error_Image_Message));
        }
                
        if(!val){
            
            att = new Attachment();
        }
        return val;
    }
}