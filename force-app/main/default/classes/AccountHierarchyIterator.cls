global class AccountHierarchyIterator implements Iterator<Account> {
    List<Account> accounts = new List<Account>();
    Integer i {get; set;}

    public AccountHierarchyIterator(Account account) {
        accounts.add(account);
        generateAccountsList(account, 0);
        i = 0;
    }

    private void generateAccountsList(Account account, Integer depth) {
        List<Account> childAccounts = [SELECT Name, Total_Amount__c, ParentId, (SELECT Amount FROM Opportunities WHERE StageName='Closed Won')
                                    FROM Account
                                    WHERE ParentId = :account.Id];

        if (childAccounts.size() > 0 && depth < 6) {
            depth++;
            for (Account childAccount : childAccounts) {
                accounts.add(childAccount);
                generateAccountsList(childAccount, depth);
            }
        }
        account.Total_Amount__c = countOppotunitiesAmount(account);
    }

    private Double countOppotunitiesAmount(Account account) {
        Double accountOpportunitiesAmount = 0;
        for ( Opportunity opportunity : account.Opportunities) {
            accountOpportunitiesAmount += opportunity.Amount;
        }
        return accountOpportunitiesAmount;
    }

    global boolean hasNext() {
        if (accounts.size() <= i) {
            return false;
        } else {
            return true;
        }
    }

    global Account next(){
        i++;
        return accounts[i - 1];
    }
}