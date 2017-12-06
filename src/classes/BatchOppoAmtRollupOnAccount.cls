global class BatchOppoAmtRollupOnAccount implements Database.Batchable<sObject> {
	global BatchOppoAmtRollupOnAccount() {
	//	Query = q;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		system.debug('SELECT ID, Total__c FROM 	Account');
		return Database.getQueryLocator('SELECT ID, Total__c FROM Account');
	}
   	global void execute(Database.BatchableContext BC, List<Account> scope) {
  		system.debug('scope---------'+scope);
  		Map<ID, Account> mapOppoAmtonAccount = new Map<ID, Account>();
  		for(Opportunity oppoInst : [SELECT 	Id, Amount, AccountId 
  								    FROM Opportunity 
  									WHERE AccountId IN :scope]){

  			Account accInst = mapOppoAmtonAccount.get(oppoInst.AccountId);
  			if(accInst == null){
  				accInst = New Account(total__c=0);
  			}
  			accInst.total__c += oppoInst.amount;
  			accInst.Id = oppoInst.AccountId;
  			mapOppoAmtonAccount.put(oppoInst.AccountId, accInst);
  			//if(mapOppoAmtonAccount.containsKey(oppoInst.AccountId)){
  			//	mapOppoAmtonAccount.put(oppoInst.AccountId, 
  			//							mapOppoAmtonAccount.get(oppoInst.Acco untId)
  			//								+ oppoInst.Amount);
  			//}
  			//else{
  			//	mapOppoAmtonAccount.put(oppoInst.AccountId,oppoInst.Amount);
  			//}
  		}
  		system.debug('mapOppoAmtonAccount----------'+mapOppoAmtonAccount);
  		List<Account> listAccountUpdate = new List<Account>();
  		for(ID accInst: mapOppoAmtonAccount.keySet()){
  			listAccountUpdate.add(mapOppoAmtonAccount.get(accInst));
  		}
  		update listAccountUpdate;
	}
	
	global void finish(Database.BatchableContext BC) {
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
   		// Send an email to the Apex job's submitter notifying of job completion.
   		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   		String[] toAddresses = new String[] {a.CreatedBy.Email};
   		mail.setToAddresses(toAddresses);
   		mail.setSubject('Apex Sharing Recalculation ' + a.Status);
   		mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
   		' batches with '+ a.NumberOfErrors + ' failures.');
   		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
}