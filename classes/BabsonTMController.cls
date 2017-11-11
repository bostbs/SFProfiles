public class BabsonTMController{
    public string body{get;set;}
    public string title{get;set;}
    list<BCTAC__c>  lstVTAC ;
    
    public BabsonTMController(){
        lstVTAC = new list<BCTAC__c>();
        lstVTAC  = [SELECT Body__c,Community_Content_Status__c,End_Date__c,Publish_Date__c,Title__c FROM BCTAC__c WHERE
                    Community_Content_Status__c =:'Approved' order by Publish_Date__c desc LIMIT 1];
                    
        if(lstVTAC.size()>0 && lstVTAC !=null){
            body =lstVTAC[0].body__c;  
            title =  lstVTAC[0].Title__c ;   
        }
    
    
    }





}