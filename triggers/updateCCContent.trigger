trigger updateCCContent on CORECONNECT__CC_Community_Content__c (before update) {
    List<CORECONNECT__CC_Community_Content__c>  lstCCC = new  List<CORECONNECT__CC_Community_Content__c>();
    map<id,Integer>  mapCCC = new  map<id,Integer>();
    Set<id>  setCCCId = new Set<id>();
    id recordTypeIdVenture;
    
    for(CORECONNECT__CC_Community_Content__c  oCCC : trigger.new){
        setCCCId.add(oCCC.id);
    }
    if(setCCCId.size()>0){
        for(CORECONNECT__CC_Community_Content__c oCCC : [SELECT id, CCC_Id__c FROM CORECONNECT__CC_Community_Content__c WHERE CCC_Id__c =:setCCCId]){
             if(!mapCCC.containsKey(oCCC.CCC_Id__c)){
                 mapCCC.put(oCCC.CCC_Id__c,1);  
             }else{
                 mapCCC.put(oCCC.CCC_Id__c,mapCCC.get(oCCC.CCC_Id__c)+1); 
             }
             
        
        } 
    }
   
    recordTypeIdVenture = Schema.SObjectType.CORECONNECT__CC_Community_Content__c.getRecordTypeInfosByName().get('Venture').getRecordTypeId();
    
    for(CORECONNECT__CC_Community_Content__c  oCCC : trigger.new){
        if( oCCC.CCC_Id__c == null && oCCC.recordTypeId == recordTypeIdVenture ){
             CORECONNECT__CC_Community_Content__c oldCCC = Trigger.oldMap.get(oCCC.id);
            if((Trigger.oldMap.get(oCCC.id).Name != oCCC.name)||
                    (Trigger.oldMap.get(oCCC.id).CORECONNECT__Short_Description__c != oCCC.CORECONNECT__Short_Description__c)||
                          (Trigger.oldMap.get(oCCC.id).CORECONNECT__Description__c != oCCC.CORECONNECT__Description__c) ||
                               (Trigger.oldMap.get(oCCC.id).CORECONNECT__Classification1__c != oCCC.CORECONNECT__Classification1__c)||
                                    (Trigger.oldMap.get(oCCC.id).CORECONNECT__Classification2__c != oCCC.CORECONNECT__Classification2__c) ||
                                        (Trigger.oldMap.get(oCCC.id).CORECONNECT__Classification3__c != oCCC.CORECONNECT__Classification3__c) ||
                                              (Trigger.oldMap.get(oCCC.id).Default_Content__c != oCCC.Default_Content__c) ||
                                                  (Trigger.oldMap.get(oCCC.id).Trump_Content__c != oCCC.Trump_Content__c) ||
                                                         (Trigger.oldMap.get(oCCC.id).Interests__c != oCCC.Interests__c) ||
                                                             (Trigger.oldMap.get(oCCC.id).Affiliation_1__c != oCCC.Affiliation_1__c) ||
                                                                 (Trigger.oldMap.get(oCCC.id).Affiliation_2__c != oCCC.Affiliation_2__c)||
                                                                     (Trigger.oldMap.get(oCCC.id).Region__c != oCCC.Region__c) ||
                                                                         (Trigger.oldMap.get(oCCC.id).Industry__c != oCCC.Industry__c) ||
                                                                              (Trigger.oldMap.get(oCCC.id).Affinities__c != oCCC.Affinities__c) ||
                                                                                 (Trigger.oldMap.get(oCCC.id).Backers__c != oCCC.Backers__c) ||
                                                                                      (Trigger.oldMap.get(oCCC.id).Pledged_Dollars__c != oCCC.Pledged_Dollars__c) ||
                                                                                          (Trigger.oldMap.get(oCCC.id).Deadline__c != oCCC.Deadline__c) ||
                                                                                              (Trigger.oldMap.get(oCCC.id).Alumni_Name_Affiliation__c != oCCC.Alumni_Name_Affiliation__c) ||
                                                                                                  (Trigger.oldMap.get(oCCC.id).Additional_Team_Members__c != oCCC.Additional_Team_Members__c) ||
                                                                                                      (Trigger.oldMap.get(oCCC.id).CORECONNECT__FreeText_End_Date__c != oCCC.CORECONNECT__FreeText_End_Date__c )
                                                                                                  
                                                                                                 
                          
                        
                          
                         
                
                    ){
                CORECONNECT__CC_Community_Content__c o = new  CORECONNECT__CC_Community_Content__c() ;  
                if(mapCCC.get(oCCC.id)!=null){
                    o =  oldCCC.clone();
                    integer num = Integer.valueOf(mapCCC.get(oCCC.id))+1;
                    o.name =  o.name+' old -'+ num;
                    o.CCC_Id__c = oCCC.id;
                    o.CORECONNECT__Community_Content_Status__c = 'Archived';
                }else if(mapCCC.get(oCCC.id) == null){
                    o =  oldCCC.clone();
                    o.name =  o.name+' old -1' ;
                    o.CCC_Id__c = oCCC.id;
                    o.CORECONNECT__Community_Content_Status__c = 'Archived';
                }
              
                lstCCC.add(o);
            }
        }
    }
    if(lstCCC.size()>0){
        insert lstCCC;
    }
}