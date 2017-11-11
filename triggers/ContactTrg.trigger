/*
    Author : Anisha
    Description : Contact trigger
    Date : 
    Modification History :

v1.1	26-June-2017		Anisha		Contact Trigger    

*/
trigger ContactTrg on Contact (before insert, before update, after insert, after update) {
    
    if(trigger.isBefore){
        ContactTriggerUtility.beforeHandler(trigger.new, trigger.oldmap, trigger.isInsert, trigger.isUpdate);
    }
    
    if(trigger.isAfter){
        ContactTriggerUtility.afterHandler(trigger.new, trigger.oldmap, trigger.isInsert, trigger.isUpdate);
    }
}