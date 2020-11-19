//@group Async Apex Recipes
//@see RestClient
public inherited sharing class QueueableWithCalloutRecipes implements Queueable, Database.AllowsCallouts {
    private XAP_REST_RestClient restClient;
    private DAO_AccountSelector accountSelector;
    private XAP_DAO_DML_InheritedSharingDml dml;

    private QueueableWithCalloutRecipes(
            XAP_REST_RestClient restClient,
            DAO_AccountSelector accountSelector,
            XAP_DAO_DML_InheritedSharingDml dml
    ) {
        this.restClient = restClient;
        this.accountSelector = accountSelector;
        this.dml = dml;
    }

    public QueueableWithCalloutRecipes() {
        this(
                XAP_REST_RestClient.getInstance(),
                DAO_AccountSelector.getInstance(),
                XAP_DAO_DML_InheritedSharingDml.getInstance()
        );
    }

    @TestVisible
    private static Boolean throwError = false;
    @TestVisible
    private static Boolean circuitBreakerThrown = false;

    public void execute(QueueableContext queueableContext) {
        HttpResponse response = makeApiCall();
        List<Account> accountList = handleAccounts(response);

        try {
            this.dml.doUpdate(accountList);
        } catch (DmlException dmlException) {
            System.debug(
                LoggingLevel.ERROR,
                'real life use cases should do something more than just logging the error: ' +
                dmlException.getMessage()
            );
            if (Test.isRunningTest()) {
                QueueableWithCalloutRecipes.circuitBreakerThrown = true;
            }
        }
    }

    private HttpResponse makeApiCall() {
        XAP_REST_RestRequest request = new XAP_REST_RestRequest()
                .setNamedCredential('mockBin')
                .setPath('/');
        HttpResponse response = this.restClient.makeApiCall(request);
        return response;
    }

    private List<Account> handleAccounts(HttpResponse response) {
        List<Account> accountList = this.accountSelector.selectAndOrderBy(1000, Account.Id);
        for (Account account : accountList) {
            account.Description = String.valueOf(response.getStatusCode());
        }

        if (Test.isRunningTest() && throwError) {
            accountList = (List<Account>) TestFactory.invalidateSObjectList(accountList);
        }
        return accountList;
    }
}
