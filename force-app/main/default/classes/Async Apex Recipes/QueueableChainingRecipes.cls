//@group Async Apex Recipes
//@see QueueableRecipes
public inherited sharing class QueueableChainingRecipes implements Queueable {
    private DAO_AccountSelector accountSelector;
    private XAP_ASYNC_Enqueuer enqueuer;
    private XAP_DAO_DML_InheritedSharingDml dml;

    private QueueableChainingRecipes(
            DAO_AccountSelector accountSelector,
            XAP_ASYNC_Enqueuer enqueuer,
            XAP_DAO_DML_InheritedSharingDml dml
    ) {
        this.accountSelector = accountSelector;
        this.enqueuer = enqueuer;
        this.dml = dml;
    }

    public QueueableChainingRecipes() {
        this(
                DAO_AccountSelector.getInstance(),
                XAP_ASYNC_Enqueuer.getInstance(),
                XAP_DAO_DML_InheritedSharingDml.getInstance()
        );
    }

    public void execute(QueueableContext context) {
        List<Account> accountList = this.accountSelector.selectAll();
        for (Account account : accountList) {
            account.Description += ' Edited by first chained Queuable';
        }

        try {
            this.dml.doUpdate(accountList);
        } catch (DmlException dmlException) {
            System.debug(
                LoggingLevel.ERROR,
                'Failed to update accountList. Error is: ' + dmlException.getMessage()
            );
        }

        this.enqueuer.enqueueJob(new QueueableRecipes());
    }
}
