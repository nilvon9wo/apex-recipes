public with sharing class ARTR_ACT_AccountShippingStateChanger implements XAP_TRG_TriggerSteppable {

    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Account> newAccountList = context.newSObjectList;

        for (Account newAccount : newAccountList) {
            if (newAccount.ShippingState != null && newAccount.ShippingState.length() > 2) {
                newAccount.addError('Shipping State Length exceeds maximum allowed');
            }
            newAccount.ShippingStreet += ' before update trigger';
        }

        return new XAP_TRG_TriggerStepSuccess(context);
    }
}