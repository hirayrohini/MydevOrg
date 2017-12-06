@isTest
private class TestProductCostingUpdateHandler {

	@testsetup 
	static void testCreate() {
		List<Product2> listProd = new List<Product2>();
		List<Costing__c> listCosting = new List<Costing__c>();
		for(Integer i = 0; i < 5; i++) {
                Product2 prodInst = new Product2(Name = 'Product ' + i);
                listProd.add(prodInst);
        }
        insert listProd;
        for(Integer j = 0; j < 250; j++) {
                Costing__c costInst = new Costing__c(Name = 'Costing ' + j, 
                                              		 Quantity__c = j+10,
                                              		 Product__c = listProd[1].Id,
                                              	     Cost__c = 15000);
                listCosting.add(costInst);
        }
        insert listCosting;
	}

	@isTest static void testUpdateProductsAfterInsert() {
		List<Product2> listProd = new List<Product2>();
		List<Costing__c> listCosting = new List<Costing__c>();
		for(Integer i = 0; i < 5; i++) {
                Product2 prodInst = new Product2(Name = 'Product ' + i);
                listProd.add(prodInst);
        }
        insert listProd;
        for(Integer j = 0; j < 2; j++) {
                Costing__c costInst = new Costing__c(Name = 'Costing ' + j, 
                                              		 Quantity__c = j+10,
                                              		 Product__c = listProd[1].Id,
                                              	     Cost__c = 15000);
                listCosting.add(costInst);
        }
        Test.startTest();
        insert listCosting;
        Test.stopTest();
	}

	@isTest static void testUpdateProductsAfterUpdate() {
		List<Costing__c> listCostingUpdate = new List<Costing__c>();
		List<Product2> listProd = new List<Product2>();
		Test.startTest();
        for(Integer i = 0; i < 3; i++) {
                Product2 prodInst = new Product2(Name = 'Product ' + i);
                listProd.add(prodInst);
        }
        insert listProd;
		
        for(Costing__c costInst : [SELECT ID,NAME,Product__c 
                                   FROM Costing__c 
                                   WHERE Name LIKE '%Costing%']) {
        	costInst.Product__c = listProd.get(2).Id;
        	listCostingUpdate.add(costInst);
        }
        system.debug('listCostingUpdate==='+listCostingUpdate);
        
        update listCostingUpdate;
        Test.stopTest();
	}

	@isTest static void testUpdateProductsAfterDelete() {
		List<Costing__c> listCostingDel = new List<Costing__c>();
		listCostingDel = [SELECT ID,NAME,Product__c FROM Costing__c WHERE Name LIKE '%Costing%' limit 5];
        system.debug('listCostingDel==='+listCostingDel);
        Test.startTest();
        delete listCostingDel;
        Test.stopTest();
	}

}