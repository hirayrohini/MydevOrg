trigger ProductCostingUpdate on Costing__c (after Insert,after Update,after Delete) {
	if(trigger.isAfter) {
		if(trigger.isInsert) {
			ProductCostingUpdateHandler handler = new ProductCostingUpdateHandler();
			handler.updateProductsAfterInsert(trigger.new);
		}
		if(trigger.isUpdate) {
			ProductCostingUpdateHandler handler = new ProductCostingUpdateHandler();
			handler.updateProductsAfterUpdate(trigger.oldMap,trigger.new);
		}
		if(trigger.isDelete) {
			ProductCostingUpdateHandler handler = new ProductCostingUpdateHandler();
			handler.updateProductsAfterDelete(trigger.old);
		}
	}
}