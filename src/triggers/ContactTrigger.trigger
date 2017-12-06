/*
Requirement : Trigger on Contact that will check for duplicates before allowing a new record
              into the database.
*/
trigger ContactTrigger on Contact (before Insert, before update) {
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            ContactTriggerHandler handler = new ContactTriggerHandler();
            handler.contBeforeInsert(trigger.new);
        }
        if(trigger.isUpdate) {
            ContactTriggerHandler handler = new ContactTriggerHandler();
            handler.contBeforeUpdate(trigger.old,trigger.new);
        }
    }
}