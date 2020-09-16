global class TotalAmountBatch implements Database.Batchable<SObject> {
    global List<Account> start(Database.BatchableContext bc) {
        return [SELECT Name, Total_Amount__c, (SELECT Amount FROM Opportunities WHERE StageName='Closed Won')
                FROM Account];
    }

    global void execute(Database.BatchableContext bc, List<Account> accounts){
        for (Account account : accounts) {
            Double totalAmount = 0;
            AccountHierarchyIterator iterator = new AccountHierarchyIterator(account);
            while (iterator.hasNext()) {
                Account acc = iterator.next();
                totalAmount += getOpportunitiesAmounts(acc.Opportunities);
            }
            account.Total_Amount__c = totalAmount;
        }
        update accounts;
    }

    global void finish(Database.BatchableContext bc){
        
    }

    private Double getOpportunitiesAmounts(List<Opportunity> opportunities) {
        Double amountSum = 0;
        for (Opportunity opportunity : opportunities) {
            amountSum += opportunity.Amount;
        }
        return amountSum;
    }
}