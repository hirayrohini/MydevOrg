/*
Problem Statement : Trigget to identify duplicate leads.
                    Lead can be identified as duplicate on the basis of Phone and Email field.
                    Find duplicate lead and link it to original lead record.
*/

trigger LeadTrigger on Lead (before insert, before update) {
    //trigger event is before
    if(trigger.isbefore) {
        //trigger event is Insert
    	if(trigger.isInsert) {
    		leadTriggerHandler handler = new leadTriggerHandler();
        	handler.updateLeadBeforeInsert(trigger.new);
    	}
        //trigger event is Update
        if(trigger.isUpdate) {
    		leadTriggerHandler handler = new leadTriggerHandler();
        	handler.updateLeadBeforeUpdate(trigger.old,trigger.new);
    	}
    }
}