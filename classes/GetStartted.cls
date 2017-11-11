public class GetStartted{

    public String name{get;set;}
    
    public GetStartted(){
        try{
             List<User>loggedInContact=[SELECT ID,Contact.FirstName FROM User WHERE id=:UserInfo.getUserId()];
             if(loggedInContact.size()>0){
                 name=loggedInContact[0].Contact.FirstName;
               System.debug('@@@'+loggedInContact);
             }
             System.debug('@@@name'+name);
        }
        catch(Exception ex){
        }
    }

}