public with sharing class ARTR_ACT_AccountDescrCounterIncrementer implements XAP_TRG_TriggerSteppable {
    private AccountServiceLayer accountService;

    private ARTR_ACT_AccountDescrCounterIncrementer(AccountServiceLayer accountService) {
        this.accountService = accountService;
    }

    public ARTR_ACT_AccountDescrCounterIncrementer() {
        this(AccountServiceLayer.getInstance());
    }

    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Account> newAccountList = context.newSObjectList;

        this.accountService.incrementCounterInDescription(newAccountList, false);

        return new XAP_TRG_TriggerStepSuccess(context);
    }
}