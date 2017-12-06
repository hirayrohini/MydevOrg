@isTest
public class ContactTriggerHandlerTest {
	@testSetup 
	public static void createData() {
		List<Contact> conList = new List<Contact>();
		for(Integer i=1; i<10; i++) {
			Contact conInst = new Contact(Lastname = 'Test'+i,
								  Email = 'test'+i+'@gmail.com',
								  Phone = '888888888'+i);
			conList.add(conInst);
		}
		insert conList;
	}
	
	public static testMethod void testContBeforeInsertPhnone() {
		Contact newCont = new Contact();
		newCont.lastname = 'Test1';
		newCont.Phone = '8888888888';
		try {
	        insert newCont;
	    } 
	    catch (DmlException e) {
	        System.assert(e.getDmlFields(0)[0].getDescribe().getName() == 'Phone');
	    }
	}

	public static testMethod void testContBeforeInsertEmail() {
		Contact newCont = new Contact();
		newCont.lastname = 'Test2';
		newCont.Email = 'test8@gmail.com';
		try {
	        insert newCont;
	    } 
	    catch (DmlException e) {
	    	 System.assert(e.getNumDml() == 1);
	    }
	}

	public static testMethod void testcontBeforeUpdateEmail(){
		List<Contact> updateConList = new List<Contact>();
		for(Contact conInst :[SELECT ID,Email 
							  FROM Contact 
							  where Email = 'test8@gmail.com' limit 1]) {
			conInst.Email = 'test5@gmail.com';
			updateConList.add(conInst);
		}
		try {
	        update updateConList;
	    } 
	    catch (DmlException e) {
	    	System.assertEquals(e.getDmlMessage(0),'A Contact with this email address already exists.');
	    }
	}

	public static testMethod void testContBeforeUpdatePhone() {
		List<Contact> updateConList = new List<Contact>();
		for(Contact conInst :[SELECT ID,Phone 
							  FROM Contact 
							  where Phone = '8888888881' limit 1]) {
			conInst.Phone = '8888888885';
			updateConList.add(conInst);
		}
		try {
	        update updateConList;
	    } 

	    catch (DmlException e) {
	    	system.debug('ErrorPhone----'+e);
	        System.assert(e.getDmlFields(0).size() == 1);
	    }
	}

	public static testMethod void testContBeforeUpdateBulk() {
		List<Contact> conList = new List<Contact>();
		for(Integer i=0; i <3; i++) {
			Contact conObj = new Contact(Lastname = 'Test1'+i,
										 Phone = '8080808080',
										 Email = 'test@test.com');
			conList.add(conObj);
		}
		try{
			insert conList;
		}
		catch(DmlException e) {
			System.assertEquals(e.getDmlMessage(0),'Another new Contact has the same email address.');
		}
	}
}