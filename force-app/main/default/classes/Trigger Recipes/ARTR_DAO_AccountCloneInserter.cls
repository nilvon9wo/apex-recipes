public with sharing class ARTR_DAO_AccountCloneInserter implements XAP_TRG_TriggerSteppable {
    private XAP_DAO_DML_SecureDml dml;

    private ARTR_DAO_AccountCloneInserter(XAP_DAO_DML_SecureDml dml) {
        this.dml = dml;
    }

    public ARTR_DAO_AccountCloneInserter() {
        this(XAP_DAO_DML_SecureDml.getInstance());
    }

    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Account> clonedAccountList = (List<Account>) context.get(ARTR_TriggerStepKeys.ACCOUNT_CLONE_LIST);

        try {
            this.dml.doInsert(clonedAccountList);
        } catch (XAP_DAO_DML_CrudException crudException) {
            System.debug(
                    LoggingLevel.ERROR,
                    'Inserting cloned accounts failed with DML exception. Details: ' + crudException.getMessage()
            );
        }

        return new XAP_TRG_TriggerStepSuccess(context);
    }
}