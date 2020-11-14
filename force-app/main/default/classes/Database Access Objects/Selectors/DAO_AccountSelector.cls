public with sharing virtual class DAO_AccountSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_ContactSelector contactSelector;
    protected DAO_AccountSelector(DAO_ContactSelector contactSelector) {
        this.contactSelector = contactSelector;
    }

    protected DAO_AccountSelector() {
        this(DAO_ContactSelector.getInstance());
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
                Account.Name,
                Account.ShippingCity,
                Account.ShippingState,
                Account.ShippingStreet
        };
    }

    public virtual List<Account> secureSelectById(Set<Id> idSet) {
        return this.createQueryFactory()
                .setEnforceFLS()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }

    public virtual List<Account> selectAll() {
        return this.createQueryFactory()
                .query();
    }

    public virtual List<Account> secureSelectAll() {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .query();
    }

    public virtual List<Account> secureSelectAllWithContacts() {
        XAP_DAO_SOQL_QueryFactory accountQueryFactory = this.createQueryFactory();

        this.contactSelector
                .injectParentToSelectChildFields(accountQueryFactory, 'Contacts');

        return accountQueryFactory.query();
    }


    public virtual List<Account> secureSelectByName(Set<String> nameSet) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(Account.Name, nameSet))
                .query();
    }

    public virtual List<Account> secureSelectByShippingCountry(Set<String> countrySet) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(Account.ShippingCountry, countrySet))
                .query();
    }

    public virtual List<Account> secureSelectByShippingState(Set<String> stateSet) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(Account.ShippingState, stateSet))
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

    public virtual List<Account> secureSelectWithCondition(XAP_DAO_SOQL_WHERE_ClauseIntf clause) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setCondition(clause)
                .query();
    }


    public virtual List<Account> selectSome(Integer quantity) {
        return this.createQueryFactory()
                .setLimit(quantity)
                .query();
    }

    public virtual List<Account> selectAndOrderBy(Integer quantity, SObjectField orderField) {
        return this.createQueryFactory()
                .setOrdering(orderField, XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
                .setLimit(quantity)
                .query();
    }

    public virtual List<Account> secureSelectAndOrderDescendingBy(Integer quantity, SObjectField orderField) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setOrdering(orderField, XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING)
                .setLimit(quantity)
                .query();
    }

    public virtual List<Account> secureSelectWithOffsetAndOrderDescendingBy(
            Integer quantity,
            Integer offset,
            SObjectField orderField
    ) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setOrdering(orderField, XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING)
                .setOffset(offset)
                .setLimit(quantity)
                .query();
    }

    public virtual Database.QueryLocator getQueryLocatorForAll() {
        return this.createQueryFactory()
                .getQueryLocator();
    }

    public virtual DAO_AccountSelector doSecureForAll(XAP_DAO_SOQL_SObjectConsumerIntf consumer) {
        XAP_DAO_SOQL_QueryFactory queryFactory = this.createQueryFactory()
                .setSecurityEnforced();
        this.with(queryFactory, consumer);
        return this;
    }

}