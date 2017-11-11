/*
    Author : Anisha
    Description : Contact trigger Utility
    Date : 
    Modification History :

v1.1	26-June-2017		Anisha		Contact Utility    

*/
public class ContactTriggerUtility {
    
    public static void beforeHandler(list<Contact> lstNew, map<Id,Contact> mpold, boolean isInsert, boolean isUpdate){
        
        
        
    }
    
    public static void afterHandler(list<Contact> lstNew, map<Id,Contact> mpold, boolean isInsert, boolean isUpdate){
        
        map<Id,string> emails = new map<Id, string>();
        for(Contact con: lstNew){
            if(isUpdate){
                system.debug('>>>>>>>>>>>>>>>'+con.Preferred_Email__c+'>>>>>>>>>>>>>>>>>>'+mpOld.get(con.id).Preferred_Email__c);
                if(con.Preferred_Email__c != null && con.Preferred_Email__c != mpOld.get(con.id).Preferred_Email__c){
                       emails.put(con.id, con.Preferred_Email__c);    
                }
                
            }
        }
        
        System.debug('>>>>>>>>emails>>>>>>>>>>>>'+emails);
        if(!emails.isEmpty()){
            List<User> lstUsers2Update = new List<User>();
            for(User u: [Select id, ContactId from User where ContactId in: emails.keyset()]){
                u.email = emails.get(u.ContactId);
                lstUsers2Update.add(u);
            }
            
            if(!lstUsers2Update.isEmpty())
                update lstUsers2Update;
        }
        
    }
    
}