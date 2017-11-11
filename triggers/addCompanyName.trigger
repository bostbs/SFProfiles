trigger addCompanyName on User (before insert,before update) {
    // Fetch IDs for Staff/Faculty and Alumni Profiles
    Id ssfID = [Select Id 
            From Profile 
            Where Name = 'Alumni Community - SSF'
            Limit 1].Id; 
    Id alumniID = [Select Id 
            From Profile 
            Where Name = 'Alumni Community - Alumni'
            Limit 1].Id;  

    // For each user, if profile ID is either SSF or Alumni, update their Company name (this replaces what usually appears as "Customer" in the community)
    for(User user : Trigger.New) {
        
        if (user.ProfileId != null && user.ProfileId == alumniID){
            user.CompanyName = 'Alumni';
        }
        
        if(user.ProfileId != null && user.ProfileId == ssfID){
            user.CompanyName = 'Non-Alumni';
        }
        
        if(user.Constituency__c != null){
        
            if(user.Constituency__c.contains('Alumni')){
                user.Preferred_constituency__c = 'Alumni';
                user.Give_to_Babson__c = 'Alumni';
            }
            
            else if(user.Constituency__c.contains('Graduate') || user.Constituency__c.contains('Undergraduate') || user.Constituency__c.contains('Certificate')){
                user.Preferred_constituency__c = 'Student';
                user.Give_to_Babson__c = 'Student';
            }
            
            else if(user.Constituency__c.contains('Parent')){
                user.Preferred_constituency__c = 'Parent';
            }
            
            else if(user.Constituency__c.contains('Staff')) {
                user.Preferred_constituency__c = 'Staff';
            }
            
            else if(user.Constituency__c.contains('Faculty')) {
                user.Preferred_constituency__c = 'Faculty';
            }
            
            
            
            else if(user.Constituency__c.contains('Governance')){
                user.Preferred_constituency__c = 'Other';
            }
        }
    }
}