/*
Requirement : Trigger on Contact that will check for duplicates before allowing a new record
              into the database.
*/
public class ContactTriggerHandler {
    public void contBeforeInsert(List<Contact> contList) {
        system.debug('conList---' +contList);
        for(Contact conInst :contList) {
            if(conInst.Email != null || conInst.Phone != null) {
                deDupeContcts(contList);
            }
        }
    }

    public void contBeforeUpdate(List<Contact> conOldList,List<Contact> conNewList) {
        system.debug('conOldList---' +conOldList);
        system.debug('conNewList---' +conNewList);
        for(Contact conOld :conOldList) {
            for(Contact conNew :conNewList) {
                if(conOld != conNew) {
                    if(conNew.Email != null || conNew.Phone != null) 
                        deDupeContcts(conNewList);
                }
            }
        }
    }

    public void deDupeContcts(List<Contact> conList) {
        Map<String, Contact> contactEmailMap = new Map<String, Contact>();
        Map<String, Contact> contactPhoneMap = new Map<String, Contact>();
        for(Contact Contact :conList) {
            if(contactEmailMap.containsKey(Contact.Email)) {
                    Contact.Email.addError('Another new Contact has the '
                                        + 'same email address.');
            } 
            else {
                contactEmailMap.put(Contact.Email, Contact);
            }
            if(contactPhoneMap.containsKey(Contact.Phone)) {
                Contact.Phone.addError('Another new Contact has the '
                                    + 'same Phone.');
            } 
            else {
                contactPhoneMap.put(Contact.Phone, Contact);
            }
        }
        
        for (Contact contInst : [SELECT Email,Phone FROM Contact
                                WHERE Email IN :contactEmailMap.KeySet()
                                OR Phone IN :contactPhoneMap.KeySet()]) {
            if(contInst.Email != null) {
                Contact newContact = contactEmailMap.get(contInst.Email);
                if(newContact != null) {
                    newContact.Email.addError('A Contact with this email '
                                   + 'address already exists.');
                }
            }
            if(contInst.Phone != null) {
                Contact newContact = contactPhoneMap.get(contInst.Phone);
                if(newContact != null) {
                    newContact.Phone.addError('A Contact with this Phone '
                                   + 'already exists.');
                    
                }
            }
        }
    }
}