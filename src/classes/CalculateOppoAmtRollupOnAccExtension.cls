public with sharing class CalculateOppoAmtRollupOnAccExtension {
	public Id accID {get; set;}
    public Map<Id,Account> mapAccountIDtotal {get;set;}
    public Integer totalRecs {get;set;}
	public Integer offsetSize = 0;
	public Integer limitSize= 10;
	public Integer counter = 0;
    //public List<Account> listAcc {get;set;}


    public CalculateOppoAmtRollupOnAccExtension() {

    	totalRecs = [SELECT count() FROM account];
        mapAccountIDtotal = new Map<Id,Account>();
        for (Account account : [SELECT ID,Name,Total__c FROM Account]) {
        	mapAccountIDtotal.put(account.Id, new Account(
        		Id = account.Id,
        		Name = account.Name,
        		Total__c = 0
    		));
    	}
    }

    public PageReference calculateTotal(){
		system.debug('-----'+accID);
    	mapAccountIDtotal.putAll(OppoAmtRollupExt.MethodOppoAmtRollupExt(accId));
    	//mapAccountIDtotal = new Map<Id,Decimal>();
        /*for(Opportunity oppoInst : [SELECT  AccountId, Amount 
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
        system.debug('-mapAccountIDtotal-------'+mapAccountIDtotal); */
    	return null;
    }
    
    public list<Account> getAccounts(){
        return [SELECT Id, Name, Total__c FROM Account ORDER BY Name 
        			  LIMIT :LimitSize OFFSET :OffsetSize];
    }

    public Boolean getDisablePrevious(){
        if(OffsetSize>0){
            return false;
        }
        else return true;
    }

    public Boolean getDisableNext() {
        if (OffsetSize + LimitSize < totalRecs){
            return false;
        }
        else return true;
    }

	public PageReference next() {
        OffsetSize += LimitSize;
        return null;
    }

    public PageReference previous() {
        OffsetSize -= LimitSize;
        return null;
    }

    public PageReference last() { 
      	OffsetSize = totalRecs - math.mod(totalRecs, LimitSize);
      	return null;
    }

    public PageReference first() { 
      	OffsetSize = 0;
      	return null;
   	}
}