public class BAB_Util {
    
    private static String strUserProfile = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
    
    public static Boolean is_SSFUser(){
        
        return (strUserProfile.equalsIgnoreCase('Alumni Community - SSF')? true : false);
    }
    
   /* public static Boolean is_AlumniUser(){
        
        If(strUserProfile.equalsIgnoreCase('Alumni Community - Alumni')){
            
            return true;
        }
    
        return false;
    }
*/

    /**
    Contruct all profile id string in where clause
    */
    public static string constructProfilesList(Set<String> profileIds) {
        
        List<NetworkMemberGroup> lisMemGroup = [select NetworkId, ParentId 
                                                from NetworkMemberGroup 
                                                where NetworkId = : CORECONNECT.CC_CommunityConstants.NETWORK_ID];
        
        String objSSFProfileId = [SELECT Id FROM Profile WHERE Name = 'Alumni Community - SSF'].Id;
        
        // get unique profile ids
        for(NetworkMemberGroup nmg:lisMemGroup){
            
            profileIds.add(nmg.ParentId); 
        }
        
        String idString = ' where (ProfileId in (\'';
        Integer c = 1;
        
        system.debug('profileIds================'+profileIds);
        for(String i:profileIds){
            
            if(!i.equalsIgnoreCase(objSSFProfileId)){
                
                if(c!= profileIds.size()){ 
                    
                    idString += i + '\',\''; 
                } else{ 
                    
                    idString += i + '\''; 
                }
            }
            
            c++;
        }
        idString += ')';
        
        system.debug('idString================'+idString);
        
        List<PermissionSetAssignment> permissionAssignments = [select AssigneeId 
                                                                from PermissionSetAssignment 
                                                                where PermissionSetId in: profileIds];
        if(!permissionAssignments.isEmpty()) {
            
            Set<String> userIds = new Set<String>();
            for(PermissionSetAssignment psa : permissionAssignments){ 
                
                userIds.add(psa.AssigneeId); 
            }
            
            idString += ' or Id in (\'';
            c = 1;
            
            for(String u : userIds) {
                
                if(c!= userIds.size()) { 
                    
                    idString += u + '\',\''; 
                } else { 
                    
                    idString += u + '\''; 
                }
                
                c++;
            }
            
            idString += '))';
        } else { 
            
            idString += ')'; 
        }
        
        return idString;
    }

   public static boolean doesContainsItemFromSet(Set<String> personalisationSet_Contact, Set<String> personalisationSet_CC)
   {
       
       system.debug('personalisationSet_Contact=============='+personalisationSet_Contact);
       system.debug('personalisationSet_CC=============='+personalisationSet_CC);
       
       for(String strValue : personalisationSet_CC){
           
           if(personalisationSet_Contact.contains(strValue)){
               
               return true;
           }
       }
       
        return false;
    }
    
    public static List<SelectOption> htmlEscapeSelectOptions( List<SelectOption> lstSelectOption){
        
        List<SelectOption> lstEscapedSelectOptions = new List<SelectOption>();
        for(SelectOption objOption : lstSelectOption){
            
            String option = objOption.getValue().replaceAll('&amp;', '&');
            lstEscapedSelectOptions.add(new SelectOption(option,option));
        }
        return lstEscapedSelectOptions;
    }
}