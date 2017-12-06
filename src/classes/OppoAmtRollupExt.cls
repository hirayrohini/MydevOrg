public with sharing class OppoAmtRollupExt {

	public static Map<Id,Account> MethodOppoAmtRollupExt(ID accID) {
		Map<Id,Account> mapAccountIDtotal = new Map<Id,Account>();
		for(Opportunity oppoInst : [SELECT  AccountId, Amount 
                                    FROM    Opportunity 
                                    WHERE   AccountId =:accID]){
        	Account accInst = mapAccountIDtotal.get(oppoInst.AccountId);
            if (accInst == null) {
					accInst = new Account(Total__c = 0);
				}
				accInst.Total__c += oppoInst.Amount;
				system.debug('account.Total__c-----------'+accInst.Total__c);
				mapAccountIDtotal.put(oppoInst.AccountId, accInst);
        }
        system.debug('-mapAccountIDtotal-------'+mapAccountIDtotal);
        return mapAccountIDtotal;
	}
}