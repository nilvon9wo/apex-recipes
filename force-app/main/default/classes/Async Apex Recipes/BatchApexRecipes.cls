public inherited sharing class BatchApexRecipes implements Database.Batchable<SObject>, Database.Stateful {
    private DAO_AccountSelector accountSelector;
    private XAP_DAO_DML_InheritedSharingDml dml;

    private BatchApexRecipes(DAO_AccountSelector accountSelector, XAP_DAO_DML_InheritedSharingDml dml) {
        this.accountSelector = accountSelector;
        this.dml = dml;
    }

    public BatchApexRecipes() {
        this(DAO_AccountSelector.getInstance(), XAP_DAO_DML_InheritedSharingDml.getInstance());
    }

    private List<Id> successIdList = new List<Id>();
    private List<Id> failureIdList = new List<Id>();

    @TestVisible
    private static String result = '';

    @TestVisible
    private Boolean throwError = false;

    public Database.QueryLocator start(Database.BatchableContext context) {
        return this.accountSelector.getQueryLocatorForAll();
    }

    public void execute(Database.BatchableContext context, List<Account> accountList) {
        for (Account account : accountList) {
            this.resetNAme(account);
        }

        XAP_DAO_DML_SaveResultListWrapper saveResultListWrapper
                = this.dml.doUpdate(accountList, XAP_DAO_DML_OperationModeEnum.BEST_EFFORT);

        for (XAP_DAO_DML_ResultWrapperIntf saveResult : saveResultListWrapper.getResultWrapperList()) {
            this.addToResultList(saveResult);
        }
    }

    private Account resetNAme(Account account) {
        account.Name += ' Edited by Batch class';

        if (this.throwError) {
            account.Name = null;
        }

        return account;
    }

    private BatchApexRecipes addToResultList(XAP_DAO_DML_ResultWrapperIntf saveResult) {
        List<Id> resultList = saveResult.isSuccess()
                ? successIdList
                : failureIdList;
        resultList.add(saveResult.getId());
        return this;
    }

    public void finish(Database.BatchableContext context) {
        BatchApexRecipes.result
                = 'Successes: ' + successIdList.size()
                + ' Failures: ' + failureIdList.size();
    }
}
