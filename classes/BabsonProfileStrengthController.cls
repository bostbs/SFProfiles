public with sharing class BabsonProfileStrengthController {
	public Decimal percentComplete {get;set;}

	public BabsonProfileStrengthController() {
		percentComplete = profileCompletionField();
	}
	
	public Decimal profileCompletionField(){
	    Decimal percentComplete = 0;
	    User usr = [Select id,  Contact.Profile_Completeness_Total__c, Contact.AccountId, ContactId, UserType FROM User WHERE id =:  UserInfo.getUserId()];
		if (usr.UserType != 'Standard'){
		    percentComplete = usr.Contact.Profile_Completeness_Total__c;
		}
		
		//BAB-350
		//Home 1: Postal Code
		List<hed__Address__c> lstHomePinCode = new List<hed__Address__c>([SELECT hed__MailingPostalCode__c
                                                                            FROM hed__Address__c 
                                                                            WHERE hed__Parent_Contact__c =: usr.ContactId 
                                                                            AND Address_Line_No__c = 'Home 1'
                                                                            ORDER BY LastModifiedDate DESC 
                                                                            LIMIT 1]);
                                                                            
        if(!lstHomePinCode.isEmpty()){
            
            if(String.isNotBlank(lstHomePinCode[0].hed__MailingPostalCode__c)){
                
                percentComplete += 15;
            }
        }
        
        //Business Directory: Company, Title, Industry
        List<CORECONNECT__CC_Community_Content__c> lstUserBusinessInfo = new List<CORECONNECT__CC_Community_Content__c>([SELECT Name, Title__c, Business_Industry__c
                                                                                                                        FROM CORECONNECT__CC_Community_Content__c 
                                                                                                                        WHERE RecordType.Name = 'Business' 
                                                                                                                        AND ownerId =: usr.Id
                                                                                                                        AND Publish_Business__c = True
                                                                                                                        ORDER BY LastModifiedDate DESC
                                                                                                                        LIMIT 1]);                                                                                                           
         if(!lstUserBusinessInfo.isEmpty()){
            
            if(String.isNotBlank(lstUserBusinessInfo[0].Name)){
                
                percentComplete += 10;
            }
            if(String.isNotBlank(lstUserBusinessInfo[0].Title__c)){
                
                percentComplete += 10;
            }
            if(String.isNotBlank(lstUserBusinessInfo[0].Business_Industry__c)){
                percentComplete += 10;
            }
        }

		return percentComplete;
	}
}