public class SendApprovalComments{
    private CORECONNECT__CC_Community_Content__c communityContent;
    public String emailMsg{get;set;}
    private  List<Contact>primaryContact;
    //private Boolean isErrorOccured{get;set;}
    public Boolean isSuccess{get;set;}
    public SendApprovalComments(ApexPages.StandardController stdController) {
        this.communityContent = (CORECONNECT__CC_Community_Content__c)stdController.getRecord();
        this.communityContent=[SELECT Id,Name,RecordType.Name,Contact__c,More_Info_Required__c,CreatedById,CreatedBy.FirstName,CreatedBy.Email,CORECONNECT__Short_Description__c,CORECONNECT__FreeText_Desired_Publish_Date__c,CORECONNECT__End_Date__c FROM CORECONNECT__CC_Community_Content__c WHERE id=:communityContent .id ];
        primaryContact=[SELECT Id,firstName,lastName,email FROM CONTACT WHERE id=:communityContent.Contact__c];
    }

    public void rejectRecord(){
        Set<Id> pIds = (new Map<Id, ProcessInstance>([SELECT Id,Status,TargetObjectId FROM ProcessInstance where Status='Pending' and TargetObjectId = :communityContent.id])).keySet();
        Set<Id> pInstanceWorkitems = (new Map<Id, ProcessInstanceWorkitem>([SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :pIds])).keySet();
        Approval.ProcessWorkitemRequest [] allReq = New Approval.ProcessWorkitemRequest []{}; 
        for (Id pInstanceWorkitemsId:pInstanceWorkitems){
            system.debug(pInstanceWorkitemsId);
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Send for more information.');
            req2.setAction('Removed'); //to approve use 'Approve'
            //req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(pInstanceWorkitemsId);
            // Add the request for approval
            allReq.add(req2);
        }
        Approval.ProcessResult[] result2 =  Approval.process(allReq);
    }

    public void sendEmail(){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add(communityContent.CreatedBy.Email);
            sendTo.add('globicloud55@gmail.com');
            mail.setToAddresses(sendTo);  
            mail.setSenderDisplayName('Babson College Admin');
            mail.setWhatId(communityContent.id);   
            Contact c = [select id, Email from Contact where email <> null limit 1];
            String templateId;
            if('Venture'.equalsIgnoreCase(this.communityContent.RecordType.Name))
                templateId=Label.Venture_NeedMoreInfo;
            else
                templateId=Label.Job_NeedMoreInfo;
            mail.setTargetObjectId(c.Id);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setTemplateId(templateId);
            mail.setSaveAsActivity(false);
            mails.add(mail);
            
            rejectRecord();
            isSuccess=true;
            this.communityContent.More_Info_Required__c=emailMsg;
            this.communityContent.CORECONNECT__Community_Content_Status__c='Need More Info';
            update this.communityContent;
            
            Messaging.sendEmail(mails);
        }
        catch(Exception ex){
            isSuccess=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured during sending email.Please contact adminstrator.'));

        }
              
    }

}