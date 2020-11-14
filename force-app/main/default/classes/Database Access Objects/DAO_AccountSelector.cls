public with sharing virtual class DAO_AccountSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_AccountSelector() {
    }

    private static DAO_AccountSelector instance;
    public static DAO_AccountSelector getInstance() {
        if (instance == null) {
            instance = new DAO_AccountSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return Account.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Account.Description,
                Account.Id,
                Account.Name
        };
    }

    public virtual List<Account> selectAll() {
        return this.createQueryFactory()
                .query();
    }

    public virtual List<Account> selectSome(Integer quantity) {
        return this.createQueryFactory()
                .setLimit(quantity)
                .query();
    }

    public virtual Database.QueryLocator getQueryLocatorForAll() {
        return this.createQueryFactory()
                .getQueryLocator();
    }
}