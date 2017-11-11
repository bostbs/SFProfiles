public with sharing class ContactRedirectController {
	
	private final sObject mysObject;

	public ContactRedirectController(ApexPages.StandardController stdController) {
        this.mysObject = (sObject)stdController.getRecord();
    }

    public PageReference redirectUser(){
    	if (Network.getNetworkId() != null || Test.isRunningTest()) {
    		Id userId = [select Id from User where ContactId =: mysObject.Id Limit 1].id;
    		return new PageReference(Page.MyProfilePage.getURL()+'?userId=' + userId);
    	}
    	else {
    		return null;
    	}

    }
}