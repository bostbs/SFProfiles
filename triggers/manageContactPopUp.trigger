trigger manageContactPopUp on VTAC__c (before insert,before update) {
    List<VTAC__c>  lstVTac = new List<VTAC__c> ();
    lstVTac = [SELECT id,createddate,Publish_Date__c from VTAC__c WHERE Community_Content_Status__c  = :'Approved' AND Publish_Date__c!=null order by Publish_Date__c desc LIMIT 1 ];
    VTAC__c objVtac = new VTAC__c();
    List<contact>  lstCOntact = new List<contact>();
    List<contact>  lstCOntactUpdate = new List<contact>();
    
    boolean isChanged = false;
    if(trigger.isUpdate){
        objVtac = lstVTac[0];
        for(VTAC__c  oVTAC : trigger.new){
           if(oVTAC.id == objVtac.id ){
               if(Trigger.oldMap.get(oVTAC.id).Body__c != oVTAC.body__C || 
                   Trigger.oldMap.get(oVTAC.id).Title__c != oVTAC.Title__c){
                       isChanged = true;
               
               }
           } 
            
        }
        
        if(isChanged == true){
            lstCOntact = [SELECT id,isVentureTermsAccepted__c from contact WHERE Venture_Terms_Acceptance_Date__c !=null];
            for(contact oCon : lstCOntact){
                oCon.isVentureTermsAccepted__c = false;
                lstCOntactUpdate.add(oCon);
            
            }
            
            if(lstCOntactUpdate.size()>0){
                update lstCOntactUpdate;
            }
            
        }
    }
     if(trigger.isInsert){
         datetime tempdate;
         for(VTAC__c  oVTAC : trigger.new){
             if(oVTAC.Publish_Date__c!=null){
                
                 if(tempDate ==null || tempDate<oVTAC.Publish_Date__c){
                     tempDate = oVTAC.Publish_Date__c;
                 } 
             }
         }
         if(lstVTac != null && !lstVTac.isempty()){
             objVtac = lstVTac[0];
             System.debug('objVtac=='+objVtac.Publish_Date__c);
             System.debug('objVtac=='+tempdate);
             
             if(objVtac.Publish_Date__c < tempdate){
                lstCOntact = [SELECT id, isVentureTermsAccepted__c from contact WHERE Venture_Terms_Acceptance_Date__c !=null];
                for(contact oCon : lstCOntact){
                    oCon.isVentureTermsAccepted__c = false;
                    lstCOntactUpdate.add(oCon);
                
                }
                
                if(lstCOntactUpdate.size()>0){
                    update lstCOntactUpdate;
                }
             
             }
         }
     }
    
}