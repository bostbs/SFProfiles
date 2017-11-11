public with sharing class BabsonFooterSocialCTAController {

	public AlumniCommunity__c socialMediaSetting     {get;set;}               // to store custom setting instance
	
	public BabsonFooterSocialCTAController() {
		socialMediaSetting = AlumniCommunity__c.getInstance(Site.GetName());  
	}
}