public with sharing class ARTR_ACT_AccountShippingStreetChanger implements XAP_TRG_TriggerSteppable {
    private AccountServiceLayer accountService;

    private ARTR_ACT_AccountShippingStreetChanger(AccountServiceLayer accountService) {
        this.accountService = accountService;
    }

    public ARTR_ACT_AccountShippingStreetChanger() {
        this(AccountServiceLayer.getInstance());
    }

    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Account> newAccountList = context.newSObjectList;

        this.accountService.changeShippingStreet(newAccountList);

        return new XAP_TRG_TriggerStepSuccess(context);
    }
}