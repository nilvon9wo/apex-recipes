public inherited sharing class SOQLRecipes {
    private DAO_AccountSelector accountSelector;
    private DAO_ContactSelector contactSelector;
    private DAO_JunctionSelector junctionSelector;
    private DAO_OpportunitySelector opportunitySelector;

    private SOQLRecipes(
            DAO_AccountSelector accountSelector,
            DAO_ContactSelector contactSelector,
            DAO_JunctionSelector junctionSelector,
            DAO_OpportunitySelector opportunitySelector
    ) {
        this.accountSelector = accountSelector;
        this.contactSelector = contactSelector;
        this.junctionSelector = junctionSelector;
        this.opportunitySelector = opportunitySelector;
    }

    public SOQLRecipes() {
        this(
                DAO_AccountSelector.getInstance(),
                DAO_ContactSelector.getInstance(),
                DAO_JunctionSelector.getInstance(),
                DAO_OpportunitySelector.getInstance()
        );
    }

    public List<Account> getRecords() {
        return this.accountSelector.secureSelectAll();
    }

    public Integer getLargeNumberOfRecords() {
        AccountSecureCounter counter = new AccountSecureCounter();
        this.accountSelector.doSecureForAll(counter);
        return counter.count;
    }

    public List<Account> getRecordsByFieldValue() {
        return this.accountSelector.secureSelectByShippingCountry(new Set<String>{'UK'});
    }

    public List<Account> getRecordsByMultipleFieldValues() {
        return this.accountSelector.secureSelectWithCondition(new XAP_DAO_SOQL_WHERE_AndClause(new List<XAP_DAO_SOQL_WHERE_ClauseIntf>{
                new XAP_DAO_SOQL_WHERE_IsStringClause(Account.ShippingCountry, 'US'),
                new XAP_DAO_SOQL_WHERE_IsStringClause(Account.ShippingState, 'IN'),
                new XAP_DAO_SOQL_WHERE_InStringSetClause(Account.Industry, new Set<String>{
                        'Fast Food - made whole', 'Slow Food - Made quickly'
                })
        }));
    }

    public List<Account> getSpecificNumberOfRecords() {
        return this.accountSelector.secureSelectAndOrderDescendingBy(10, Account.Industry);
    }

    public List<Account> getFirstXRecords(Integer wantedNumberOfRows) {
        return this.accountSelector.secureSelectAndOrderDescendingBy(wantedNumberOfRows, Account.Industry);
    }

    public List<Account> getAccountRecordsInState(String state) {
        return this.accountSelector.secureSelectByShippingState(new Set<String>{state});
    }

    public List<Account> getSecond10AccountRecords() {
        return this.accountSelector.secureSelectWithOffsetAndOrderDescendingBy(10, 10, Account.Industry);
    }

    public List<Account> getRecordsWithRelatedRecords() {
        return this.accountSelector.secureSelectAllWithContacts();
    }

    public List<Contact> getParentRecordDetailsFromChildRecord() {
        return this.contactSelector.secureSelectByShippingStateWithParentAccount(new Set<String>{'KS'});
    }

    public List<Junction__c> getDetailsFromBothParentRecords() {
        return this.junctionSelector.secureSelectWithParents();
    }

    public Double getSumOfOpportunityRecords(Id accountId) {
        return this.opportunitySelector.sumAmountForAccount(accountId);
    }
}
