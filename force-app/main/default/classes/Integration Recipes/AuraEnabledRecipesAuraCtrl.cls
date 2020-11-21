public inherited sharing class AuraEnabledRecipesAuraCtrl {
    private DAO_AccountSelector accountSelector;
    private XAP_DAO_DML_SecureDml dml;

    public AuraEnabledRecipesAuraCtrl(DAO_AccountSelector accountSelector, XAP_DAO_DML_SecureDml dml) {
        this.accountSelector = accountSelector;
        this.dml = dml;
    }

    public AuraEnabledRecipesAuraCtrl() {
        this(DAO_AccountSelector.getInstance(), XAP_DAO_DML_SecureDml.getInstance());
    }

    private static final String DEFAULT_RETURN_VALUE = 'hello world';

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @AuraEnabled
    public static Boolean updateAccountName(Id accountId, String newValue) {
        return new AuraEnabledRecipesAuraCtrl()
                .doUpdate(new Account(
                        Id = accountId,
                        Name = newValue
                ));
    }

    private Boolean doUpdate(Account updatedAccount) {
        Account account;
        try {
            account = this.accountSelector.secureSelectById(new Set<Id>{updatedAccount.Id})[0];
        }
        catch (XAP_DAO_SOQL_DomainSecurityException crudException) {
            throw new AuraHandledException('User does not have access to edit Accounts');
        }

        account.Name = updatedAccount.Name;
        try {
            this.dml.doUpdate(new List<Account>{account});
        }
        catch (DmlException dmlException) {
            throw new AuraHandledException('DML Failed: ' + dmlException.getMessage());
        }
        return true;
    }


    @AuraEnabled(Cacheable=true)
    public static String getFieldValue() {
        return DEFAULT_RETURN_VALUE;
    }
}
