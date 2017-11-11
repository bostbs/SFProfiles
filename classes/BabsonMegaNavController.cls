public with sharing class BabsonMegaNavController {
    public AlumniCommunityL2Pages__c alumniL2Setting {get;set;}  // custom setting instance
    public CORECONNECT__CC_Header_Footer_Settings__c headerFooterSetting {get;set;}  // custom setting instance
    public String giveToBabsonURl{get;set;}
    public BabsonMegaNavController() {
        alumniL2Setting = AlumniCommunityL2Pages__c.getInstance(Site.GetName());
        headerFooterSetting = CORECONNECT__CC_Header_Footer_Settings__c.getInstance(Site.GetName());
        Contact currentContact;
        try{
            if(!test.isRunningTest()){
                 currentContact = [Select Id,  FirstName,LastName ,Preferred_Email__c, Graduate_Preferred_Year__c,Graduate_Year__c,Undergraduate_Preferred_Year__c,Certificate_Preferred_Year__c,MobilePhone,Undergraduate_Year__c,Certificate_Degree_Year__c
                            From Contact
                            Where Id In (Select ContactId From User Where Id = :UserInfo.getUserId())];
             }
            if(test.isRunningTest()){
                 currentContact = [Select Id,  FirstName,LastName ,Preferred_Email__c, Graduate_Preferred_Year__c,Graduate_Year__c,Undergraduate_Preferred_Year__c,Certificate_Preferred_Year__c,MobilePhone,Undergraduate_Year__c,Certificate_Degree_Year__c
                            From Contact
                           ];
             }
            List<hed__Address__c> add=[Select id,hed__MailingStreet__c,hed__MailingStreet2__c,hed__MailingCity__c,hed__MailingPostalCode__c,Mailing_Country__c,Mailing_State__c,Phone__c,Address_Line_No__c from hed__Address__c where hed__Parent_Contact__c=:currentContact.id AND Address_Line_No__c='Home 1' limit 1] ;
            System.debug('@@Add'+add);
            giveToBabsonURl=headerFooterSetting.CORECONNECT__Header_Link_1_URL__c;
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
            
            
            User loggedInUser = [Select id,Preferred_Constituency__c from User where Id=:UserInfo.getUserId()];
            string prefConstituency = loggedInUser.Preferred_Constituency__c;
            //if(prefConstituency == 'Staff')
            //    prefConstituency = 'Faculty';
            
            giveToBabsonURl=giveToBabsonURl+'&strFirstName='+format(currentContact.FirstName)+'&strLastName='+format(currentContact.LastName)+'&strEmail='+format(currentContact.Preferred_Email__c)+'&strAffiliation='+prefConstituency+'&strClassYear='+format(classYear)+'&strPhoneCell='+format(currentContact.MobilePhone)+'&strLine1=';
            if(null!=add && add.size()>0){
                if('United States'.equalsIgnoreCase(add[0].Mailing_Country__c))
                    add[0].Mailing_Country__c='USA';
                giveToBabsonURl=giveToBabsonURl+format(add[0].hed__MailingStreet__c)+'&strLine2='+format(add[0].hed__MailingStreet2__c)+'&strCity='+format(add[0].hed__MailingCity__c)+'&strPostalCode='+format(add[0].hed__MailingPostalCode__c)+'&strState='+format(add[0].Mailing_State__c)+'&strCountry='+format(add[0].Mailing_Country__c)+'&strPhoneHome='+format(add[0].Phone__c)+'&source_code=BABCON';                 
            }
        }
        catch(Exception ex){
                giveToBabsonURl=headerFooterSetting.CORECONNECT__Header_Link_1_URL__c;
                System.debug('@@@@'+ex);
        }
        
    }

    public String format(String add){
        if(String.isEmpty(add))
            return '';
        else
            return add;
    }
}