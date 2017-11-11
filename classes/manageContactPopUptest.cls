@istest
public class manageContactPopUptest{

   public testmethod static void  unitTest1(){
       
          Account a = new Account(Name='Test Account Name');
          insert a;
          
          Contact c = new Contact(LastName = 'Contact Last Name', FirstName = 'Contact First Name', AccountId = a.id, Interests__c = 'Arts',Affiliation_1__c = 'MBA  Blended Learning MBA',
                                                                                                                Region__c = 'AK-Alaska',
                                                                                                                Industry__c = 'Accounting',
                                                                                                                Affiliation_2__c = 'U2023',
                                                                                                                Affinities__c = 'Undergraduate Advisory Board');
                                                                                                                
                                                                                                                
                                                                                                                
           insert c;
           c.Venture_Terms_Acceptance_Date__c = system.now();
           update c;
                                                                                                                
           
           VTAC__c  oV = new VTAC__c();
           oV.Body__C = 'ruiroe';
           oV.Title__C = 'hht';
           oV.Publish_Date__c = system.now();
           oV.End_Date__c =   system.now().adddays(10);  
           oV.Community_Content_Status__c = 'Approved';
           insert oV;
                    
           oV.Body__C = 'ruiroeher';
           oV.Title__C = 'hhhrebhjewt';
           oV.Publish_Date__c = system.now();
           oV.End_Date__c =   system.now().adddays(11);  
           oV.Community_Content_Status__c = 'Approved';
           update oV;

           VTAC__c  oV1 = new VTAC__c();
           oV1.Body__C = 'ruiroejnnjk';
           oV1.Title__C = 'hht io';
           oV1.Publish_Date__c = system.now();
           oV1.End_Date__c =   system.now().adddays(10);  
           oV1.Community_Content_Status__c = 'Approved';
           insert oV1;
                    
           oV1.Body__C = 'ruiroehe3453r';
           oV1.Title__C = 'hhhrebhjewt43';
           oV1.Publish_Date__c = system.now();
           oV1.End_Date__c =   system.now().adddays(11);  
           oV1.Community_Content_Status__c = 'Approved';
           update oV1;
           
           
           BCTAC__c oV2 = new BCTAC__c();
           oV2.Body__C = 'ruiroejnnjk';
           oV2.Title__C = 'hht io';
           oV2.Publish_Date__c = system.now();
           oV2.End_Date__c =   system.now().adddays(10);  
           oV2.Community_Content_Status__c = 'Approved';
           insert oV2;
                    
           oV2.Body__C = 'ruiroehe3453r';
           oV2.Title__C = 'hhhrebhjewt43';
           oV2.Publish_Date__c = system.now();
           oV2.End_Date__c =   system.now().adddays(11);  
           oV2.Community_Content_Status__c = 'Approved';
           update oV2;
                                                                                                      
                                                                                                                
                                                                                                              
   
   }
    




}