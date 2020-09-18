@isTest
private class TestBatch {
    @isTest
    static void TestTotalAmountSchedule() {

        List<Account> accounts = new List<Account>();
        List<Opportunity> opportunites = new List<Opportunity>();
        for (Integer i = 0; i < 6; i++) {
            accounts.add(new Account(Name = 'Account ' + (i + 1),
                                    Total_Amount__c = 0));
        }
        
        upsert accounts;

        for (Integer i = 1; i < 6; i++) {
            accounts[i].ParentId = accounts[i - 1].Id;
        }

        update accounts;
        for (Account account : accounts) {
            for (Integer j = 0; j < 2; j ++) {
                opportunites.add(new Opportunity(Name = account.Name + ' Opportunity' + (j + 1),
                                                    Amount = 10,
                                                    CloseDate = Date.today(),
                                                    StageName = 'Closed Won',
                                                    AccountId = account.Id));
            }
        }
        upsert opportunites;

        Test.startTest();
            TotalAmountBatch batchAmount = new TotalAmountBatch();
            Database.executeBatch(batchAmount);
        Test.stopTest();   
        List<Account> updatedAccounts = [SELECT Total_Amount__c
                                        FROM Account
                                        WHERE Id IN :accounts
                                        AND Total_Amount__c > 0];
        System.assertEquals(6, updatedAccounts.size());
    }
}
