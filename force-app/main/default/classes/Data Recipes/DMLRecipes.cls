@SuppressWarnings('PMD.CyclomaticComplexity')
public inherited sharing class DMLRecipes {
    private XAP_DAO_DML_SecureDml dml;

    private DMLRecipes(XAP_DAO_DML_SecureDml dml) {
        this.dml = dml;
    }

    public DMLRecipes() {
        this(XAP_DAO_DML_SecureDml.getInstance());
    }
    public void insertAccountViaInsertKeyword(String name) {
        try {
            this.dml.doInsert(new List<Account>{new Account(
                    Name = name
            )});
        }
        catch (XAP_DAO_DML_AccessCtrlDmlException accessCtrlDmlException) {
            throw new CustomDMLException('Failed');
        }
        catch (DmlException dmlException) {
            throw new CustomDMLException('Failed');
        }
    }

    public static void insertAccountsViaDatabaseMethod(
            String name,
            Boolean allOrNothing
    ) {
        Account account = new Account(Name = name);
        Account account2 = new Account();

        try {
            if (CanTheUser.create(account)) {
                Database.insert(new List<Account>{account, account2}, allOrNothing);
            }
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
    }

    public static Account upsertAccountViaUpsertKeyword(Account account) {
        //Upsert = (up)date or in(sert)
        if (CanTheUser.create(account) && CanTheUser.edit(account)) {
            try {
                upsert account; //NOPMD
                //- Note: This will cause PMD to raise a violation for not
                // checking CRUD/FLS. However, we're doing just that in the Line
                // above - PMD just isn't aware of CanTheUser.*
            }
            catch (DmlException dmle) {
                System.debug(LoggingLevel.INFO, dmle.getMessage());
                throw dmle;
            }
        }
        return account;
    }

    public static Database.UpsertResult upsertAccountViaDatabaseMethod(
            Account account,
            Boolean allOrNothing
    ) {
        Database.UpsertResult results;
        if (CanTheUser.create(account) && CanTheUser.edit(account)) {
            results = Database.upsert(account, allOrNothing);
        }
        else {
            throw new CustomDMLException(
                    'User has no access to create and edit accounts'
            );
        }
        return results;
    }

    public static List<Account> updateAcccountViaKeyword(List<Account> accounts) {
        for (Account account : accounts) {
            account.Name += ' Updated via Keyword';
        }
        try {
            if (CanTheUser.edit(accounts[0])) {
                update accounts;
            }
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
        return accounts;
    }

    public static List<Account> updateAccountViaDatabaseMethod(
            List<Account> accounts
    ) {
        for (Account account : accounts) {
            account.Name += ' Updated via Keyword';
        }
        try {
            if (CanTheUser.edit(accounts[0])) {
                try {
                    Database.update(accounts);
                }
                catch (DmlException dmle) {
                    System.debug(LoggingLevel.INFO, dmle.getMessage());
                    throw dmle;
                }
            }
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
        return accounts;
    }

    public static void deleteAccountViaKeyword(List<Account> accounts) {
        try {
            if (CanTheUser.destroy(accounts[0])) {
                try {
                    delete accounts;
                }
                catch (DmlException dmle) {
                    System.debug(LoggingLevel.INFO, dmle.getMessage());
                }
            }
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
    }

    public static void deleteAccountViaDatabaseMethod(List<Account> accounts) {
        try {
            if (CanTheUser.destroy(accounts[0])) {
                Database.delete(accounts);
            }
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
    }

    public static List<Account> undeleteAccountViaKeyword(List<Account> accounts) {
        try {
            if (CanTheUser.read(accounts[0])) {
                try {
                    undelete accounts;
                }
                catch (DmlException dmle) {
                    System.debug(LoggingLevel.INFO, dmle.getMessage());
                    throw dmle;
                }
            }
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
        return accounts;
    }

    public static List<Account> undeleteAccountViaDatabaseMethod(
            List<Account> accounts
    ) {
        try {
            if (CanTheUser.read(accounts[0])) {
                Database.undelete(accounts);
            }
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
        return accounts;
    }
}
