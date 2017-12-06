/*
Requirement : Create a trigger on Costing Record to update Product's 'Cost Matrix' with 
			 5 Quantity and its Cost value. The Quantity should be in Ascending Order.
*/

public class ProductCostingUpdateHandler {
	//Method to update Product's 'Cost Matrix' after insertion of records
    public void updateProductsAfterInsert(List<Costing__c> listCost) {
    	Set<Id> setProductIds = new Set<Id>();
    	for(Costing__c costInst : listCost) {
    		if(costInst.Product__c != null) {
    			setProductIds.add(costInst.Product__c);
    		}
    	}
    	if(!setProductIds.isEmpty()){
    		CalcQuantity(setProductIds);
    	}
    }

    //Method to update Product's 'Cost Matrix' after records get updated
    public void updateProductsAfterUpdate(Map<Id,Costing__c> mapOldCost, List<Costing__c> listNewCost) {
    	Set<Id> setProductIds = new Set<Id>();
    	List<Product2> lstProductsUpdate = new List<Product2>();

		for(Costing__c costInst :listNewCost){
			if(costInst.Product__c != null) {
    			//setProductIds.add(costInst.Product__c);
   			}
   			if(mapOldCost.get(costInst.Id).Product__c != null 
   				&& costInst.Product__c != mapOldCost.get(costInst.Id).Product__c) {
   	 		 	setProductIds.add(mapOldCost.get(costInst.Id).Product__c);
   			}
   			
		}
		if(!setProductIds.isEmpty()){
    		CalcQuantity(setProductIds);
    	}
    }

    //Method to update Product's 'Cost Matrix' after records get deleted
    public void updateProductsAfterDelete(List<Costing__c> listCost) {
    	Set<Id> setProductIds = new Set<Id>();
    	for(Costing__c costInst : listCost) {
    		if(costInst.Product__c != null) {
    			setProductIds.add(costInst.Product__c);
    		}
    	}
    	if(!setProductIds.isEmpty()){
    		CalcQuantity(setProductIds);
    	}
    	
    }

    //Common method to update product's cost matrix with Quanity '5' and it's cost value.
    public void CalcQuantity(Set<Id> productIds) {
    	List<Product2> lstProducts = new List<Product2>();
    	Map<Id,List<Costing__c>> mapProductIdCosting = new Map<Id,List<Costing__c>>();
    	for(Costing__c costInst : [SELECT   ID,Product__c,Quantity__c,Cost__c 
    							   FROM     Costing__c 
    							   WHERE    Product__c IN :productIds 
    							   AND      Quantity__c != null 
    							   ORDER BY Quantity__c]) {
    		if(mapProductIdCosting.containsKey(costInst.Product__c)){
    			//List<Costing__c> costList = mapProductIdCosting.get(costInst.Product__c);
    			//costList.add(costInst);
    			mapProductIdCosting.get(costInst.Product__c).add(costInst);
    		}
    		else {
    			mapProductIdCosting.put(costInst.Product__c,new List<Costing__c>{costInst});
    		}
    	}
    	
    	for(Id ids : mapProductIdCosting.keySet()) {
    		Integer i=1;
    		Product2 prodInst = new Product2();
    		prodInst.Id = ids;
    		for(Costing__c costInst : mapProductIdCosting.get(ids)) {
    			if(i<=5) {
    				prodInst.put('Quantity_'+i+'__c',costInst.Quantity__c);
    				prodInst.put('Cost'+i+'__c',costInst.Cost__c);
	    			i++;
    			}
    		}
    		Integer j = i;
    		while(j<=5) {
				prodInst.put('Quantity_'+j+'__c',0);
				prodInst.put('Cost'+j+'__c',0);
				j++;
			}
    		lstProducts.add(prodInst);
    	}
    	if(!lstProducts.isEmpty()) {
    		update lstProducts;
    	}
    }
}