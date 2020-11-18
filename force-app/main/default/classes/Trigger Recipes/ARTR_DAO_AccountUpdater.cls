public inherited sharing class 	ARTR_DAO_AccountUpdater implements XAP_TRG_TriggerSteppable {
    private XAP_DAO_DML_InheritedSharingDml dml;

    public ARTR_DAO_AccountUpdater(XAP_DAO_DML_InheritedSharingDml dml) {
        this.dml = dml;
    }

    public ARTR_DAO_AccountUpdater() {
        this(XAP_DAO_DML_InheritedSharingDml.getInstance());
    }

    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        Map<Id, Account> accountByIdMap = (Map<Id, Account>) context.get(ARTR_TriggerStepKeys.ACCOUNT_BY_ID_MAP);
        this.dml.doUpdate(accountByIdMap.values());
        return new XAP_TRG_TriggerStepSuccess(context);
    }
}
