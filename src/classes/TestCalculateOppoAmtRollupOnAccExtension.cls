@isTest
private class TestCalculateOppoAmtRollupOnAccExtension {

	@testsetup
    static void createRecords(){
    	List<Account> listAcc = new List<Account>();
		List<Opportunity> listOppo = new List<Opportunity>();
		for(Integer i = 0; i < 25; i++) {
                Account accInst = new Account(Name = 'Account ' + i);
                listAcc.add(accInst);
        }
        insert listAcc;
        for(Integer j = 0; j < 5; j++) {
                Opportunity oppoInst = new Opportunity(Name = 'Opportunity ' + j, 
                                              		   Amount = 10,
                                              		   AccountId = listAcc[1].Id,
                                              		   StageName = 'Prospecting',
                                              		   CloseDate = System.today());
                listOppo.add(oppoInst);
        }
        insert listOppo;
    }
	
	/*static testMethod void testConstructor() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.calculateTotal();
    }*/
	
	static testMethod void testCalculateTotal() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.calculateTotal();
    }

	static testMethod void testGetAccounts() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.getAccounts();
	}

	static testMethod void testDisablePrevious() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.getDisablePrevious();
	}

	static testMethod void testDisableNext() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.getDisableNext();
	}

	static testMethod void testNext() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.next();
        controller.getDisablePrevious();
	}

	static testMethod void testprevious() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.previous();
        controller.getDisableNext();
	}

	static testMethod void testlast() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.last();
        controller.getDisableNext();
	}

	static testMethod void testfirst() {
		PageReference pageRef = Page.CalculateOppoAmtRollupOnAccount;
        Test.setCurrentPage(pageRef); 
        CalculateOppoAmtRollupOnAccExtension controller = new CalculateOppoAmtRollupOnAccExtension();
        controller.first();
        controller.getDisableNext();
	}
}