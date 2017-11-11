global class scheduledbatchUserLoginCount implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchUserLoginCount b = new batchUserLoginCount(); 
      database.executebatch(b);
   }
}