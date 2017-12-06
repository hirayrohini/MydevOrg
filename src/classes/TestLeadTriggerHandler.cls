/*
Problem Statement : Test class for identifying duplicate leads.
                    Lead can be identified as duplicate on the basis of Phone and Email field.
                    Find duplicate lead and link it to original lead record.
*/

@isTest
public class TestLeadTriggerHandler {
    @testsetup
    static void createTestLeads() {
        Lead leadinst1 = new Lead();
        leadinst1.LastName = 'Test1';
        leadinst1.Email = 'Test@gmail.com';
        leadinst1.Company = 'Test1 Company';
        insert leadinst1;    

        Lead leadinst2 = new Lead();
        leadinst2.LastName = 'Test2';
        leadinst2.Phone = '8888888888';
        leadinst2.Company = 'Test1 Company';
        insert leadinst2;

        Lead leadinst3 = new Lead();
        leadinst3.LastName = 'Test3';
        leadinst3.Email = 'Test@testmail.com';
        leadinst3.Company = 'Test3 Company';
        insert leadinst3; 

        Lead leadinst4 = new Lead();
        leadinst4.LastName = 'Test3';
        leadinst4.Phone = '9090909090';
        leadinst4.Company = 'Test3 Company';
        insert leadinst4; 
    }

    //Test Method for inserting lead with duplicate Email values
    static testMethod void testLeadInsertEmail() {
        List<Lead> leadListEmail = new List<Lead>();
        List<Lead> leadOldList = [SELECT Id 
                                  FROM Lead
                                  WHERE Email = 'Test@gmail.com' limit 1];
        for(Integer i = 0; i < 250; i++) {
            Lead leadinst1 = new Lead (LastName = 'Test'+ i,
                                       Email = 'Test@gmail.com',
                                       Company = 'Test1 Company');
            leadListEmail.add(leadinst1);
        }
        test.starttest();
        insert leadListEmail;
        test.stoptest();
        List<Lead> leadListNew = [SELECT Id, ParentLead__c
                                  FROM Lead
                                  WHERE Email = 'Test@gmail.com'];
        System.assertEquals(leadListNew[1].ParentLead__c,leadOldList[0].Id);
    }

    //Test Method for inserting lead with duplicate Phone values
    static testMethod void testLeadInsertPhone() {    
        List<Lead> leadListPhone = new List<Lead>();
        List<Lead> leadOldList = [SELECT Id 
                                  FROM Lead
                                  WHERE Phone = '8888888888' limit 1];
        for(Integer i = 0; i < 250; i++) {
            Lead leadinst1 = new Lead (LastName = 'Test'+ i,
                                       Phone = '8888888888',
                                       Company = 'Test1 Company');
            leadListPhone.add(leadinst1);
        }
        test.starttest();
        insert leadListPhone;
        test.stoptest();
        List<Lead> leadListNew = [SELECT Id, ParentLead__c
                                  FROM Lead
                                  WHERE Phone = '8888888888'];
        System.assertEquals(leadListNew[1].ParentLead__c,leadOldList[0].Id);
    }

    //Test Method for updating lead with duplicate Email values
    static testMethod void testLeadUpdateEmail() {
        List<Lead> updateLeadEmail = new List<Lead>();
        List<Lead> leadOldList = [SELECT Id 
                                  FROM Lead
                                  WHERE Email = 'Test@gmail.com' limit 1];
        for(Lead leadInst : [SELECT ID, Name, Email, Phone 
                            FROM LEAD 
                            WHERE Email =: 'Test@testmail.com']) {
            leadInst.Email = 'Test@gmail.com';
            updateLeadEmail.add(leadInst);
        }
        test.starttest();
        update updateLeadEmail;
        test.stoptest();
        List<Lead> leadListNew = [SELECT Id, ParentLead__c
                                  FROM Lead
                                  WHERE Email = 'Test@gmail.com'];
        System.assertEquals(leadListNew[1].ParentLead__c,leadOldList[0].Id);
    }

    //Test Method for updating lead with duplicate Phone values
    static testMethod void testLeadUpdatePhone() {
        List<Lead> updateLeadPhone = new List<Lead>();
        List<Lead> leadOldList = [SELECT Id 
                                  FROM Lead
                                  WHERE Phone = '8888888888' limit 1];
        for(Lead leadInst : [SELECT ID, Name, Email, Phone 
                            FROM LEAD 
                            WHERE Phone =: '9090909090']) {
            leadInst.Phone = '8888888888';
            updateLeadPhone.add(leadInst);
        }
        test.starttest();
        update updateLeadPhone;
        test.stoptest();
        List<Lead> leadListNew = [SELECT Id, ParentLead__c
                                  FROM Lead
                                  WHERE Phone = '8888888888'];
        System.assertEquals(leadListNew[1].ParentLead__c,leadOldList[0].Id);
    }
}