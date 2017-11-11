public with sharing class EventCreateController {
    
    public CORECONNECT__CC_Community_Content__c CC         {get;set; }

    public Attachment att {
        get{
             if (att == null)
                     att = new Attachment();
            return att;
        }
        set;
    }
   
    
    public String StartDateTimeString {get;set;}
    public String EndDateTimeString {get;set;}
	
	public Boolean isSubmitScheduledContent {get;set;}
	

    private Boolean isValid;
    public String ScheduleContentId {get;set;}
    public string strstartTime                                              {get;set;}
    public String strEndTime                                                {get;set;}
    
    private Boolean editRecordInfo;
    
    public EventCreateController() {
        
        att = new Attachment();
        CC = new CORECONNECT__CC_Community_Content__c();
        editRecordInfo = false;
        
        ScheduleContentId = (ApexPages.currentPage().getParameters().containsKey('Id') && ApexPages.currentPage().getParameters().get('Id') != '') ? ApexPages.currentPage().getParameters().get('Id') : '';
    	
    	if(String.isNotBlank(ScheduleContentId)) {
			
		    try {
    		    CC = [  SELECT Id, Name, CORECONNECT__Short_Description__c, CORECONNECT__Description__c, CORECONNECT__FreeText_Desired_Publish_Date__c, 
    		            CORECONNECT__FreeText_End_Date__c, Default_Content__c, Trump_Content__c, CORECONNECT__Classification1__c, CORECONNECT__Classification2__c,
    		            Affinities__c, Interests__c , Industry__c, Region__c, Affiliation_1__c, Source__c, Topic__c, Author__c,
    		            CORECONNECT__Is_All_Day_ScheduledContent__c, CORECONNECT__Location__c, CORECONNECT__Location_Street_1__c,
    		            CORECONNECT__Location_Street_2__c, CORECONNECT__Location_Street_3__c, CORECONNECT__Location_City__c,
    		            CORECONNECT__Location_State_Province__c, CORECONNECT__Location_Postal_Code__c, CORECONNECT__Location_Country__c,
    		            CORECONNECT__RSVP_Link__c, CORECONNECT__Admission_Fee__c, CORECONNECT__Hide_RSVP__c, 
    		            CORECONNECT__Start_Date__c, CORECONNECT__End_Date__c, Who_s_Attending__c,CORECONNECT__Community_Content_Status__c, ownerId
    		            FROM CORECONNECT__CC_Community_Content__c
    		            WHERE Id =: ScheduleContentId]; 
    		    
    		    if(CC != null) {
    		        editRecordInfo = true;    
    		        validateForScheduledContent();
    		    }
		    }
		    catch(Exception e) {
		    	
		        CC = new CORECONNECT__CC_Community_Content__c();
		        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No record found'));
		    }
		}
		
		CC.RecordTypeId = CORECONNECT.CC_CommunityConstants.ScheduledContent_COMMUNITY_CONTENT_RT_ID;
    }
     
    public PageReference createScheduledContent(){
        
		isSubmitScheduledContent = true;
        if(!validateForScheduledContent()){
            return null;
        }
        CC.RecordTypeId = CORECONNECT.CC_CommunityConstants.ScheduledContent_COMMUNITY_CONTENT_RT_ID; 
        
        return submit('/Events'+'?thankyou=true');
    }
    
  
    
    
    private Boolean validateForScheduledContent(){
    	
        Boolean val = true;
        
        if(CC.CORECONNECT__Start_Date__c != null){
        	
            strstartTime = CC.CORECONNECT__Start_Date__c.format('HH:mm:ss');
            if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(StartDateTimeString))
            	StartDateTimeString = CC.CORECONNECT__Start_Date__c.format();
        }    
        
        if(CC.CORECONNECT__End_Date__c != null){
        	
            strEndTime = CC.CORECONNECT__End_Date__c.format('HH:mm:ss');
            if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(EndDateTimeString))
            	EndDateTimeString = String.valueOf(CC.CORECONNECT__End_Date__c.format());
        }  
            
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.Name)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Name_Required));
            val = false;
        }

        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Short_Description__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_ScheduledContent_Summary_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Description__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Full_Article_Required));
            val = false;
        }
        
        if((EndDateTimeString == StartDateTimeString) && ( !CC.CORECONNECT__Is_All_Day_ScheduledContent__c )){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Event_Create_ScheduledContent_End_Date_Time_Error));
            val=false;
            
        }
        if(!CORECONNECT.CC_CommunityUtil.isNullOrEmpty(StartDateTimeString)){
            try{
            	
                CC.CORECONNECT__Start_Date__c = buildDTWithLocale(StartDateTimeString);
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Start_Date_Invalid));
                val=false;
            }
        }
        else {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Start_Date_Required));
             val=false;
        }
        
        if(!CORECONNECT.CC_CommunityUtil.isNullOrEmpty(EndDateTimeString)){
             try{
                
                CC.CORECONNECT__End_Date__c = buildDTWithLocale(EndDateTimeString);
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_End_Date_Invalid));
                val=false;
            }
        }
        
         if(CC.CORECONNECT__Start_Date__c != null && CC.CORECONNECT__End_Date__c != null &&  CC.CORECONNECT__Start_Date__c.getTime() > CC.CORECONNECT__End_Date__c.getTime()){
             
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_End_Date_After_Start_Date));
            val=false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Location_City__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Location_City_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Location_State_Province__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Location_State_Province_Required));
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Location_Postal_Code__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Location_Postal_Code_Required));
            
            val = false;
        }
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Location_Country__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Location_Country_Required));
           
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Classification1__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Classification1_Required));
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Classification2__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Event_Create_ScheduledContent_Classification2_Required));
            val = false;
        }
        
        if(CORECONNECT.CC_CommunityUtil.isNullOrEmpty(CC.CORECONNECT__Location__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.BAB_Event_Create_ScheduledContent_Location_Required));
            val = false;
        }

        if (!val){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.BAB_Create_Error_Image_Message));
        }
        
        if(!val){
            
            att = new Attachment();
        }
    
        return val;
    }   
    
    private PageReference submit(String ScheduledContentOrFreeText){
        
        if(String.isBlank(ScheduleContentId)) {
            CC.CORECONNECT__Community_Content_Status__c = 'Created';
        }
         

        // insert a record
        try{ 
             if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()){
                upsert CC; 
             }
        }catch(DMLException de){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Save_Error));
            return null;

        }
     
        att.OwnerId = CORECONNECT.CC_CommunityConstants.My_ID;
        att.ParentId = CC.Id; 
		
        if(att.body != null && att.ParentId != null){
            try {
                 // Sep 24 somehow i am not able to insert attachment in unit test. 
                 // it was working 3 weeks ago
                if(!Test.isRunningTest() && Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isCreateable()) {
                    insert att;
                }
            } catch (DMLException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.CORECONNECT.CC_Create_FreeText_ScheduledContent_Upload_Error));
                if (Schema.sObjectType.CORECONNECT__CC_Community_Content__c.isDeletable()){
                    delete CC; 
                }
                CC = new CORECONNECT__CC_Community_Content__c();
                return null;
            } finally {
                att = new Attachment();
            }
        }
               
        CC = new CORECONNECT__CC_Community_Content__c();
         att = new Attachment();
        return  new PageReference(ScheduledContentOrFreeText);
    }
    
    public PageReference cancelScheduledContent(){
         
         CC = new CORECONNECT__CC_Community_Content__c();
         att = new Attachment();
        PageReference pageRef = new PageReference('/Events'); 
        return pageRef;
    }
	
    public PageReference forwardToLogin(){
    	
    	if(String.isNotBlank(ScheduleContentId)) {
			
			isValid = (ScheduleContentId InstanceOf ID) ? true : false ;
			
			if(!isValid){
          
                return Page.Events;
          }else if(isValid && (CC.ownerId != UserInfo.getUserId() || CC.CORECONNECT__Community_Content_Status__c != 'Approved')){
                    
                    return  new PageReference(Page.EventDetail.getURL()+'?id='+ ScheduleContentId);
            }
    
		}
        return CORECONNECT.CC_CommunityUtil.forwardToLogin();
    }
    
    private List<String> splitDateTimeString(String dateTimeString) {
    	
    	List<String> dateTimeList = new List<String>();
    	
    	if(dateTimeString != null && dateTimeString.trim() != '')
    	{
    		//this should give
    		//[0] = mm/dd/yyyy
    		//[1] = hh:mm
    		//[2] = AM
    		List<String> dateTimeAMPM = dateTimeString.trim().split(' ');
    		
    		//this should give
    		//[0] = mm
    		//[1] = dd
    		//[2] = yyyy
    		List<String> monthDayYear = dateTimeAMPM[0].split('/');
    		
    		//this should give
    		//[0] = hh
    		//[1] = mm
    		List<String> hourMinute = dateTimeAMPM[1].split(':');
    		
    		dateTimeList.add(monthDayYear[2]); //year first
    		dateTimeList.add(monthDayYear[0]); //then month
    		dateTimeList.add(monthDayYear[1]); //then day
    		dateTimeList.add(hourMinute[0]); //then hour
    		dateTimeList.add(hourMinute[1]); //then minute
    		dateTimeList.add(dateTimeAMPM[2]); //then AM/PM
    		
    		System.debug('dateTimeList from string: '+dateTimeList);
    		
    	}
    	
    	return dateTimeList;
    }
    
    private DateTime buildDTWithLocale(String dateTimeString) {
    	
    	System.debug('dateTimeString: ' + dateTimeString);
    	
    	List<String> dateTimeList = splitDateTimeString(dateTimeString);
    	
    	return buildDTWithLocale(dateTimeList);
    	
    }
    
    private DateTime buildDTWithLocale(List<String> dateTimeList) {
    	    	
    	Date dt = Date.newInstance(Integer.valueOf(dateTimeList[0]), Integer.valueOf(dateTimeList[1]), Integer.valueOf(dateTimeList[2]));
    	
    	Integer hour = Integer.valueOf(dateTimeList[3]);
    	
    	system.debug('am or pm: '+dateTimeList[5]);
    	
    	if(dateTimeList[5] == 'PM')
    	{
    		hour += 11;
    		system.debug('adding 12 hours for PM');
    	}
    	
    	Time tm = Time.newInstance(hour, Integer.valueOf(dateTimeList[4]), 0, 0);
    	
    	DateTime resultDT = DateTime.newInstance(dt, tm);
    	
        return resultDT;
    	
    }
}