public with sharing virtual class DAO_ContactSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_ContactSelector() {
    }

    private static DAO_ContactSelector instance;
    public static DAO_ContactSelector getInstance() {
        if (instance == null) {
            instance = new DAO_ContactSelector();
        }
        return instance;
    }

    private DAO_AccountSelector accountSelector {
        get {
            if (this.accountSelector == null) {
                this.accountSelector = DAO_AccountSelector.getInstance();
            }
            return this.accountSelector;
        }
        set;
    }
    public DAO_ContactSelector setAccountSelector(DAO_AccountSelector accountSelector) {
        this.accountSelector = accountSelector;
        return this;
    }

    public SObjectType getSObjectType() {
        return Contact.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Contact.AccountId,
                Contact.Email,
                Contact.Id,
                Contact.Name
        };
    }

    public virtual List<Contact> secureSelectById(Set<Id> idSet) {
        return this.createQueryFactory()
                .setEnforceFLS()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }
    public virtual List<Contact> secureSelectByShippingStateWithParentAccount(Set<String> shippingStateSet) {
        XAP_DAO_SOQL_QueryFactory contactQueryFactory = this.createQueryFactory()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_RawInterpol8ionClause(
                        'Account.ShippingState IN :${shippingStateSet}',
                        new Map<String, Object>{'shippingStateSet' => shippingStateSet}
                ));

        this.accountSelector
                .injectChildToSelectParentFields(contactQueryFactory, 'Account');

        return contactQueryFactory.query();
    }

}