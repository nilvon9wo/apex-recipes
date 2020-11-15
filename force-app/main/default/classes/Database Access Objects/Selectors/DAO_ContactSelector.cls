public with sharing virtual class DAO_ContactSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private XAP_COLL_SObjectValueSetExtractor setExtractor;

    protected DAO_ContactSelector(XAP_COLL_SObjectValueSetExtractor setExtractor) {
        this.setExtractor = setExtractor;
    }

    protected DAO_ContactSelector() {
        this(XAP_COLL_SObjectValueSetExtractor.getInstance());
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

    public SObjectType getSObjectType() {
        return Contact.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Contact.AccountId,
                Contact.Email,
                Contact.Id,
                Contact.LastName,
                Contact.Name
        };
    }

    private static final Set<SObjectType> SOBJECT_TYPES_SUPPORTED_BY_MULTI_SOBJECT_SELECTION = new Set<SObjectType>{
            Account.SObjectType, Task.SObjectType
    };

    public virtual List<Contact> secureSelectById(Set<Id> idSet) {
        return this.createQueryFactory()
                .setEnforceFLS()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }

    public virtual List<Contact> secureSelectByAccountId(Set<Id> accountIdSet) {
        return this.createQueryFactory()
                .setEnforceFLS()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(Contact.AccountId, accountIdSet))
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

    public List<Contact> selectFrom(List<SObject> sObjectList) {
        Map<SObjectType, List<SObject>> sObjectListBySObjectTypeMap = this.buildSObjectListBySObjectTypeMap(sObjectList);
        List<XAP_DAO_SOQL_WHERE_ClauseIntf> conditionList = new List<XAP_DAO_SOQL_WHERE_ClauseIntf>();
        if (sObjectListBySObjectTypeMap.containsKey(Account.SObjectType)) {
            Set<Id> accountIdSet = new Map<Id, SObject>(sObjectList).keySet();
            conditionList.add(new XAP_DAO_SOQL_WHERE_InIdSetClause(Contact.AccountId, accountIdSet));
        }

        if (sObjectListBySObjectTypeMap.containsKey(Task.SObjectType)) {
            Set<Id> idSet = this.setExtractor.extractNonNullIdsFrom(sObjectList, Task.WhoId);
            conditionList.add(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet));
        }

        return this.createQueryFactory()
                .setEnforceFLS()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_OrClause(conditionList))
                .query();
    }

    private Map<SObjectType, List<SObject>> buildSObjectListBySObjectTypeMap(List<SObject> inputSObjectList) {
        Map<SObjectType, List<SObject>> sObjectListBySObjectTypeMap = new Map<SObjectType, List<SObject>>();
        for (SObject sObj : inputSObjectList) {
            SObjectType sObjectType = sObj.getSObjectType();
            if (!SOBJECT_TYPES_SUPPORTED_BY_MULTI_SOBJECT_SELECTION.contains(sObjectType)) {
                throw new DAO_UnsupportedSObjectException(
                        'Unknown object type passed. This method only supports Account and Task.'
                );
            }

            List<SObject> typeSObjectList = sObjectListBySObjectTypeMap.get(sObjectType);
            if (typeSObjectList == null) {
                typeSObjectList = new List<SObject>();
                sObjectListBySObjectTypeMap.put(sObjectType, typeSObjectList);
            }
            typeSObjectList.add(sObj);
        }
        return sObjectListBySObjectTypeMap;
    }


}