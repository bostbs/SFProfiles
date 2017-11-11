global class batchUserLoginCount implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name FROM User_Login_History__c';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<User_Login_History__c> scope) {
        map<string,integer>  mapCount = new map<string,integer> ();
        for(User_Login_History__c oUH : scope){
            if(mapCount.containsKey(oUH.Name)){
                mapCount.put(oUH.name,mapCount.get(oUH.Name)+1);
            }else{
                mapCount.put(oUH.name,1);
            }
        }
        
        System.debug('mapCount ==>>>'+mapCount);
        List<User>  lst1 = new List<User>();
        for(String str : mapCount.keySet()){
            User u = new user(id= str);
            u.User_Login_Count__c = mapCount.get(str);
            lst1.add(u);
        
        }
        
        if(lst1.size()>0){
           update lst1; 
            
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}