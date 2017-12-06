public with sharing class OppoAmtRollupOnAccContWithoutOffset {
    public ID accID {get; set;}
    public Map<Id,Account> mapAccountIDtotal {get;set;}
    public Integer size{get;set;} 
    public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}

    public OppoAmtRollupOnAccContWithoutOffset() {
        size=10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));

        mapAccountIDtotal = new Map<Id,Account>([SELECT ID,Total__c FROM Account]);
        for(Id accId : mapAccountIDtotal.keySet()) {
          Account accObj = mapAccountIDtotal.get(accId);
          accObj.Total__c = 0;
          mapAccountIDtotal.put(accId,accObj);
      }
    }

    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [SELECT Id,Name,Total__c FROM Account]));
                setCon.setPageSize(size);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }

    public PageReference CalculateTotal(){

      system.debug('-----'+accID);
      OppoAmtRollupExt oppInst = new OppoAmtRollupExt();
      //mapAccountIDtotal.putAll(oppInst.MethodOppoAmtRollupExt(accId));
      //mapAccountIDtotal = new Map<Id,Decimal>();
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
        return null;
    }
    
     
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
         return null;
    }  
     
    public List<Account> getAccount() {
      
        return (List<Account>) setCon.getRecords();
    } 
}