/*
Problem Statement : To identify duplicate leads.
                    Lead can be identified as duplicate on the basis of Phone and Email field.
                    Find duplicate lead and link it to original lead record.

Used Data Structures : 
        1. Set<String>    : Set of Email and Phones to have unique values of Email 
                            and Phone fields.
        2. Map<String,Id> : Map contains values of Email/Phone with the Lead record Id
*/

//Class to handle lead duplication
public class LeadTriggerHandler {    
    //Method to identify duplicate leads and link record to original lead 
    //before inserting the record.
    public void updateLeadBeforeInsert(List<Lead> lstLead) {
        Set<String> setLeadEmails = new Set<String>();
        Set<String> setLeadPhone = new Set<String>();
        //Add the Email and Phone of the coming record to the corresponding Sets.
        for(Lead leadInst :lstLead) {
            //Add email filed value to the set of email if values is not null
            if(leadInst.Email != null) {
                setLeadEmails.add(leadInst.Email);
            }
            //Add phone filed value to the set of phone if values is not null
            if(leadInst.Phone != null) {
                setLeadPhone.add(leadInst.Phone);
            }
        }//End of FOR loop
        //Call to the common method to lonk duplicate lead to the original one
        if((!setLeadEmails.isEmpty() || !setLeadPhone.isEmpty()) && !lstLead.isEmpty()){
            dedupeLead(setLeadEmails,setLeadPhone,lstLead);
        }//End of IF
    } //End of Method updateLeadBeforeInsert().

    //Method to identify duplicate leads and link record to original lead 
    //before updating the record.
    public void updateLeadBeforeUpdate(List<Lead> lstLeadOld,List<Lead> lstLeadNew) {
        Set<String> setLeadEmails = new Set<String>();
        Set<String> setLeadPhone = new Set<String>();
        for(Lead leadInst : lstLeadOld) {
            for(Lead leadInstNew : lstLeadNew) {
                //Add email filed value to the set of email if values is not null
                if(leadInst.Phone != leadInstNew.Phone) {
                    setLeadPhone.add(leadInstNew.Phone);
                }
                //Add phone filed value to the set of phone if values is not null
                if(leadInst.Email != leadInstNew.Email) {
                    setLeadEmails.add(leadInstNew.Email);
                }
            }//END Of Inner FOR loop
        }//END Of Outer FOR loop
        //Call to the common method to lonk duplicate lead to the original one
        if((!setLeadEmails.isEmpty() || !setLeadPhone.isEmpty()) && !lstLeadNew.isEmpty()){
            dedupeLead(setLeadEmails,setLeadPhone,lstLeadNew);
        }
    }//END of Method updateLeadBeforeUpdate().

    //Common method to link duplicate lead record to the original one 
    //on the basis of Email or Phone field values.
    public void dedupeLead(Set<String> setLeadEmails,Set<String> setLeadPhone, List<Lead> lstLead){
        Map<String,Id> mapEmailLeadId = new Map<String,Id>();
        Map<String,Id> mapPhoneLeadId = new Map<String,Id>();
        //Put the records and its corresponding Email or Phone values in the respective Maps.
        if(!setLeadEmails.isEmpty() || !setLeadPhone.isEmpty()) {
            //Query on all leads to find out lead records with matching values of Email and Phone.
            for(Lead leadObj :[SELECT Id, Email, Phone 
                               FROM   Lead 
                               where  Email IN :setLeadEmails 
                               OR     Phone IN :setLeadPhone]) {
                //Add unique phone values to the map with record Id.
                if(!mapPhoneLeadId.containsKey(leadObj.Phone)){
                    mapPhoneLeadId.put(leadObj.Phone,leadObj.Id);
                }
                //Add unique Email values to the map with record Id.
                if(!mapEmailLeadId.containsKey(leadObj.Email)){
                    mapEmailLeadId.put(leadObj.Email,leadObj.Id);
                }
            }
        }
        //Link duplicate lead record to the original record.
        //Loop to iterate on list of newly coming lead records
        for(Lead leadInst : lstLead) {
            if(leadInst.Phone != null) {
                //Identify if phone field value aleady exists in map 
                //then link record to the record present in the map 
                if(mapPhoneLeadId.containsKey(leadInst.Phone)) {
                    //Set parent id of the new record with the old record's Id
                    leadInst.ParentLead__c = mapPhoneLeadId.get(leadInst.Phone);
                }
            }    
            if(leadInst.Email != null) {
                //Identify if email field value aleady exists in map 
                //then link record to the record present in the map 
                if(mapEmailLeadId.containsKey(leadInst.Email)) {
                    //Set parent id of the new record with the old record's Id
                    leadInst.ParentLead__c = mapEmailLeadId.get(leadInst.Email);
                }//End Inner IF
            }//End Outer IF
        }//End FOR Loop
    }//End of method dedupeLead().
}//End Class