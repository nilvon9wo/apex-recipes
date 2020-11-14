public with sharing virtual class DAO_JunctionSelector  extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_JunctionDemo1Selector junctionDemo1Selector;
    private DAO_JunctionDemo2Selector junctionDemo2Selector;

    protected DAO_JunctionSelector(
            DAO_JunctionDemo1Selector junctionDemo1Selector,
            DAO_JunctionDemo2Selector junctionDemo2Selector
    ) {
        this.junctionDemo1Selector = junctionDemo1Selector;
        this.junctionDemo2Selector = junctionDemo2Selector;
    }

    protected DAO_JunctionSelector() {
        this(DAO_JunctionDemo1Selector.getInstance(), DAO_JunctionDemo2Selector.getInstance());
    }

    private static DAO_JunctionSelector instance;
    public static DAO_JunctionSelector getInstance() {
        if (instance == null) {
            instance = new DAO_JunctionSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return Junction__c.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Junction__c.Id
        };
    }

    public virtual List<Junction__c> secureSelectWithParents() {
        XAP_DAO_SOQL_QueryFactory junctionQueryFactory = this.createQueryFactory()
                .setSecurityEnforced();

        this.junctionDemo1Selector
                .injectChildToSelectParentFields(junctionQueryFactory, 'parent1__r');
        this.junctionDemo2Selector
                .injectChildToSelectParentFields(junctionQueryFactory, 'Parent2__r');

        return junctionQueryFactory.query();
    }

}