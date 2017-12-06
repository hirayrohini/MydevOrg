trigger PopulateOppoAmountOnAccount on Opportunity (after insert,after update) {
	if(trigger.isAfter) {
		if(trigger.isInsert || trigger.isUpdate){
			PopulateOppoAmountOnAccountHandler oppoClsInst = new PopulateOppoAmountOnAccountHandler();
			oppoClsInst.amountTotal();
		}
	}
}