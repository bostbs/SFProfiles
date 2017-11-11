public with sharing class CC_CommunityContentRedirectController {
	private final sObject mysObject;

	public CC_CommunityContentRedirectController(ApexPages.StandardController stdController) {
        this.mysObject = (sObject)stdController.getRecord();
    }

    public PageReference redirectUser(){
    	if (Network.getNetworkId() != null || Test.isRunningTest()){
	    	String rtName = [select RecordType.DeveloperName from CORECONNECT__CC_Community_Content__c where
	            Id =: mysObject.Id].RecordType.DeveloperName;
	        if (rtName == 'FreeText'){
	        	return new PageReference(Page.NewsDetail.getURL() + '?id=' + mysObject.Id);
	        }
	        else if (rtName == 'ScheduledContent'){
	        	return new PageReference(Page.EventDetail.getURL() + '?id=' + mysObject.Id);
	        }
	        else if (rtName == 'Venture'){
	        	return new PageReference(Page.VentureDetail.getURL() + '?id=' + mysObject.Id);
	        }
	        else if (rtName == 'Job'){
	        	return new PageReference(Page.JobDetail.getURL() + '?id=' + mysObject.Id);
	        }
	        else if (rtName == 'Business'){
	        	return new PageReference(Page.BusinessDetail.getURL() + '?id=' + mysObject.Id);
	        }
	    }
        return null;
    }
}