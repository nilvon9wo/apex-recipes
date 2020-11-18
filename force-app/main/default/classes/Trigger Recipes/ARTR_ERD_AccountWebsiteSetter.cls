public inherited sharing class ARTR_ERD_AccountWebsiteSetter implements XAP_TRG_TriggerSteppable {
    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Event_Recipes_Demo__e> newDemoList = (List<Event_Recipes_Demo__e>) context.newSObjectList;
        Map<Id, Account> accountByIdMap = (Map<Id, Account>) context.get(ARTR_TriggerStepKeys.ACCOUNT_BY_ID_MAP);

        for (Event_Recipes_Demo__e curEvent : newDemoList) {
            accountByIdMap.get(curEvent.accountId__c).Website = curEvent.url__c;
        }

        return new XAP_TRG_TriggerStepSuccess(context);
    }
}
