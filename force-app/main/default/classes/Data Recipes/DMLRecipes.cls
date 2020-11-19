//@group Data Recipes
//@see CanTheUser
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
        List<Account> accountList = new List<Account>{
                new Account(Name = name)
        };

        try {
            this.dml.doInsert(accountList);
        }
        catch (XAP_DAO_DML_AccessCtrlDmlException accessCtrlDmlException) {
            throw new CustomDMLException('Failed');
        }
        catch (DmlException dmlException) {
            throw new CustomDMLException('Failed');
        }
    }

    public void insertAccountsViaDatabaseMethod(String name, XAP_DAO_DML_OperationModeEnum operationMode) {
        List<Account> accountList = new List<Account>{
                new Account(Name = name),
                new Account()
        };

        try {
            this.dml.doInsert(accountList, operationMode);
        }
        catch (XAP_DAO_DML_AccessCtrlDmlException accessCtrlDmlException) {
            throw new CustomDMLException('Failed');
        }
        catch (DmlException dmlException) {
            throw new CustomDMLException('Failed');
        }
    }

    public Account upsertAccountViaUpsertKeyword(Account account) {
        List<Account> accountList = new List<Account>{account};
        this.dml.doUpsert(accountList);
        return account;
    }

    public XAP_DAO_DML_UpsertResultListWrapper upsertAccountViaDatabaseMethod(
            Account account,
            XAP_DAO_DML_OperationModeEnum operationMode
    ) {
        List<Account> accountList = new List<Account>{account};

        try {
            return this.dml.doUpsert(accountList, operationMode);
        }
        catch (XAP_DAO_DML_AccessCtrlDmlException accessCtrlDmlException) {
            throw new CustomDMLException('User has no access to create and edit accountList');
        }
    }

    public List<Account> updateAcccountViaKeyword(List<Account> accountList) {
        for (Account account : accountList) {
            account.Name += ' Updated via Keyword';
        }

        try {
            this.dml.doUpdate(accountList);
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
        return accountList;
    }

    public List<Account> updateAccountViaDatabaseMethod(
            List<Account> accountList
    ) {
        for (Account account : accountList) {
            account.Name += ' Updated via Keyword';
        }
        try {
            this.dml.doUpdate(accountList);
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
        return accountList;
    }

    public void deleteAccountViaKeyword(List<Account> accountList) {
        try {
            this.dml.doDelete(accountList);
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
    }

    public void deleteAccountViaDatabaseMethod(List<Account> accountList) {
        try {
            this.dml.doDelete(accountList);
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
    }

    public List<Account> undeleteAccountViaKeyword(List<Account> accountList) {
        try {
            this.dml.doUndelete(accountList);
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
        return accountList;
    }

    public List<Account> undeleteAccountViaDatabaseMethod(
            List<Account> accountList
    ) {
        try {
            this.dml.doUndelete(accountList);
        }
        catch (DmlException DMLe) {
            throw new CustomDMLException('Failed');
        }
        return accountList;
    }
}
