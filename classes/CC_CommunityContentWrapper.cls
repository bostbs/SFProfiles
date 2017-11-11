global class  CC_CommunityContentWrapper {

        global Id AttachmentId {get;set;}
        
        global CORECONNECT__CC_Community_Content__c  CC {get;set;}
        
        

        // For Featured ScheduledContent and More ScheduledContent
        global String DayOfWeek{
            get{
                if(CC.CORECONNECT__Start_Date__c !=null){
                    return CC.CORECONNECT__Start_Date__c.format('EEE');
                }return null;}}
        global String EndDayOfWeek{
            get{
                if(CC.CORECONNECT__End_Date__c !=null){
                    return CC.CORECONNECT__End_Date__c.format('EEE');
                }return null;}}
        global String Month{
            get{
                if(CC.CORECONNECT__Start_Date__c !=null){
                    return CC.CORECONNECT__Start_Date__c.format('MMM');
                }return '';}}
        global String EndMonth{
            get{
                if(CC.CORECONNECT__End_Date__c !=null){
                    return CC.CORECONNECT__End_Date__c.format('MMM');
                }return '';}}
        global String DayInMonth{
            get{
                if(CC.CORECONNECT__Start_Date__c !=null){
                    return CC.CORECONNECT__Start_Date__c.format('dd');
                }return '';}}
        global String EndDayInMonth{
            get{
                if(CC.CORECONNECT__End_Date__c !=null){
                    return CC.CORECONNECT__End_Date__c.format('dd');
                }return '';}}
        global String StartAndEndTime{
            get{
                if(CC.CORECONNECT__Start_Date__c !=null && CC.CORECONNECT__End_Date__c !=null){
                    
                    return  'From: ' + CC.CORECONNECT__Start_Date__c.format('h:mma').toLowerCase() + ' To: ' + CC.CORECONNECT__End_Date__c.format('h:mma').toLowerCase() ;
                }return '';}}
		global String StartAndEndTimeDiffDay{
            get{
                if(CC.CORECONNECT__Start_Date__c !=null && CC.CORECONNECT__End_Date__c !=null){
                    
                    return  'From: '+ CC.CORECONNECT__Start_Date__c.format('EEE MMM dd h:mma') + ' To: ' + CC.CORECONNECT__End_Date__c.format('EEE MMM dd h:mma') ;
                }return '';}}
        global String StartTime{
            get{
                if(CC.CORECONNECT__Start_Date__c !=null){
                    
                    return  CC.CORECONNECT__Start_Date__c.format('h:mm a')  ;
                }return '';}}
        global String EndTime{
            get{
                if(CC.CORECONNECT__End_Date__c !=null){
                    
                    return  CC.CORECONNECT__End_Date__c.format('h:mm a')  ;
                }return '';}}
        global String StartDateDiffDay{
            get{
                if(CC.CORECONNECT__Start_Date__c !=null){
                    
                    return  CC.CORECONNECT__Start_Date__c.format('EEE MMM dd');
                }return '';}}
        global String EndDateDiffDay{
            get{
                if(CC.CORECONNECT__End_Date__c !=null){
                    
                    return  CC.CORECONNECT__End_Date__c.format('EEE MMM dd') ;
                }return '';}}        
        global String MonthAndYear {
            get{
                if(CC.CORECONNECT__Start_Date__c !=null){
                    
                    return  CC.CORECONNECT__Start_Date__c.format('MMMM, yyyy')  ;
                }return '';}}
        global String EndMonthAndYear {
            get{
                if(CC.CORECONNECT__End_Date__c !=null){
                    
                    return  CC.CORECONNECT__End_Date__c.format('MMMM, yyyy')  ;
                }return '';}}
        global Integer MonthValue {
            get{
                if(CC.CORECONNECT__Start_Date__c !=null){
                    
                    return  CC.CORECONNECT__Start_Date__c.month();
                }return null;}}
        global Integer DaysBetweenStartEnd {
        	get {
        		if(CC.CORECONNECT__Start_Date__c != null && CC.CORECONNECT__End_Date__c != null ){
        			return Integer.valueOf((CC.CORECONNECT__End_Date__c.getTime() - CC.CORECONNECT__Start_Date__c.getTime())/(1000*60*60*24)) + 1;
        		}return 0;}}
        
        // For Featured Group
        // and group search
        global  CollaborationGroup CollabGroup {get;set;}


        // For Featured Member
        global User Mem{
            get;set;
        }
        global String FeaturedMemberType{
            get;set;
        }
        
        // For More FreeText and Featured FreeText
        global String FreeTextDate{
            get{
                String FreeTextPublishDate ='';
                if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c !=null){
                    DateTime publishDate = DateTime.newInstance(CC.CORECONNECT__FreeText_Desired_Publish_Date__c.year(),CC.CORECONNECT__FreeText_Desired_Publish_Date__c.month(),CC.CORECONNECT__FreeText_Desired_Publish_Date__c.day());
                    FreeTextPublishDate = publishDate.format('EEEE, MMMM d');
                }
                return FreeTextPublishDate;
            }
        }
        global String MoreFreeTextMonthString{
            get{
                 String FreeTextPublishDate ='';
                if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c !=null){
                    DateTime publishDate = DateTime.newInstance(CC.CORECONNECT__FreeText_Desired_Publish_Date__c.year(),CC.CORECONNECT__FreeText_Desired_Publish_Date__c.month(),CC.CORECONNECT__FreeText_Desired_Publish_Date__c.day());
                    FreeTextPublishDate = publishDate.format('MMMM, yyyy');
                }
                return FreeTextPublishDate;
            }
        }
        global Integer MoreFreeTextMonthValue{
            get{
                if(CC.CORECONNECT__FreeText_Desired_Publish_Date__c !=null){
                   return CC.CORECONNECT__FreeText_Desired_Publish_Date__c.month();
                }
                return null;
            }
        }
        
        
        // For header search
        global String CCType {
            get;set;
        }
        // For header search and people page
        global User u{get;set;}
        global Boolean followed {get;set;}
        // For Group landing
        global CollaborationGroup cg {get;set;}
        global String MyGroupRole {get;set;}
        // for file search
        global ContentVersion ChatterFile {get;set;}
        
        global Id customGroupId    {get;set;}
        
       
        global String strFeedElementBody        {get;set;}
        
        global String strFeedElementParentId        {get;set;}
        
        global String StrFeedCommentBody        {get;set;}
        
}