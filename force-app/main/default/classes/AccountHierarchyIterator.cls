global class AccountHierarchyIterator implements Iterator<Account> {
    List<Account> accounts = new List<Account>();
    Integer i {get; set;}

    public AccountHierarchyIterator(Account account) {
        generateAccountsList(account, 0);
        i = 0;
    }

    private void generateAccountsList(Account account, Integer depth) {
        List<Account> childAccounts = [SELECT Name, Total_Amount__c, ParentId
                                    FROM Account
                                    WHERE ParentId = :account.Id];

        if (childAccounts.size() > 0 && depth < 6) {
            depth++;
            for (Account childAccount : childAccounts) {
                accounts.add(childAccount);
                generateAccountsList(childAccount, depth);
            }
        }
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