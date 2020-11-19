//@group Async Apex Recipes
public inherited sharing class QueueableRecipes implements Queueable {
    private DAO_AccountSelector accountSelector;
    private XAP_DAO_DML_InheritedSharingDml dml;

    private QueueableRecipes(
            DAO_AccountSelector accountSelector,
            XAP_DAO_DML_InheritedSharingDml dml
    ) {
        this.accountSelector = accountSelector;
        this.dml = dml;
    }

    public QueueableRecipes() {
        this(
                DAO_AccountSelector.getInstance(),
                XAP_DAO_DML_InheritedSharingDml.getInstance()
        );
    }

    public void execute(QueueableContext qc) {
        List<Account> accountList = this.accountSelector.selectSome(1000);

        for (Account account : accountList) {
            account.Description += ' Edited by Queueable class';
        }

        try {
            this.dml.doUpdate(accountList);
        } catch (DmlException dmlException) {
            System.debug(
                    LoggingLevel.ERROR,
                    'real life use cases should do more than just logging the error: ' + dmlException.getMessage()
            );
        }
    }
}
