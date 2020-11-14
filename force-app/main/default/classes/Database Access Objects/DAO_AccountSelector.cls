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

    public virtual List<Account> secureSelectByName(Set<String> nameSet) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(Account.Name, nameSet))
                .query();
    }

    public virtual List<Account> secureDynamicSelect(List<String> fieldSet, String whereClause) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .addFields(fieldSet)
                .setCondition(new XAP_DAO_SOQL_WHERE_RawClause(whereClause))
                .query();
    }


    public virtual List<Account> secureSelectWithMoreEmployeesThan(Integer numberOfEmployees) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_MoreThanClause(Account.NumberOfEmployees, numberOfEmployees))
                .query();
    }

    public virtual List<Account> secureSelectOne() {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setLimit(1)
                .query();
    }


    public virtual List<Account> selectSome(Integer quantity) {
        return this.createQueryFactory()
                .setLimit(quantity)
                .query();
    }

    public virtual List<Account> selectAndOrderBy(Integer quantity, SObjectField orderField) {
        return this.createQueryFactory()
                .setLimit(quantity)
                .setOrdering(orderField, XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
                .query();
    }


    public virtual Database.QueryLocator getQueryLocatorForAll() {
        return this.createQueryFactory()
                .getQueryLocator();
    }
}