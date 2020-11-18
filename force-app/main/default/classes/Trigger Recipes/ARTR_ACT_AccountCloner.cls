public with sharing class ARTR_ACT_AccountCloner implements XAP_TRG_TriggerSteppable {
    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Account> oldAccountList = context.oldSObjectList;

        List<Account> clonedAccountList = new List<Account>();
        for (Account oldAccount : oldAccountList) {
            clonedAccountList.add(oldAccount.clone());
        }

        return new XAP_TRG_TriggerStepSuccess(context.set(ARTR_TriggerStepKeys.ACCOUNT_CLONE_LIST, clonedAccountList));
    }
}