public inherited sharing class ARTR_DAO_EventRecipesDemoAccountSelector implements XAP_TRG_TriggerSteppable {
    private DAO_AccountSelector accountSelector;
    private XAP_COLL_SObjectValueSetExtractor setExtractor;

    public ARTR_DAO_EventRecipesDemoAccountSelector(
            DAO_AccountSelector accountSelector,
            XAP_COLL_SObjectValueSetExtractor setExtractor
    ) {
        this.accountSelector = accountSelector;
        this.setExtractor = setExtractor;
    }

    public ARTR_DAO_EventRecipesDemoAccountSelector() {
        this(
                DAO_AccountSelector.getInstance(),
                XAP_COLL_SObjectValueSetExtractor.getInstance()
        );
    }

    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Event_Recipes_Demo__e> newDemoList = (List<Event_Recipes_Demo__e>) context.newSObjectList;

        Set<Id> accountIdSet
                = this.setExtractor.extractNonNullIdsFrom(newDemoList, Event_Recipes_Demo__e.accountId__c);
        Map<Id, Account> accountByIdMap
                = new Map<Id, Account>((List<Account>) this.accountSelector.selectById(accountIdSet));

        return new XAP_TRG_TriggerStepSuccess(context.set(ARTR_TriggerStepKeys.ACCOUNT_BY_ID_MAP, accountByIdMap));
    }
}
