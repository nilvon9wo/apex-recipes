public inherited sharing class DynamicSOQLRecipes {
    private DAO_AccountSelector accountSelector;

    private DynamicSOQLRecipes(DAO_AccountSelector accountSelector) {
        this.accountSelector = accountSelector;
    }

    public DynamicSOQLRecipes() {
        this(DAO_AccountSelector.getInstance());
    }

    public List<Account> simpleDynamicSOQLQuery() {
        return this.accountSelector.secureSelectOne();
    }

    public List<Account> simpleBindingSOQLQuery(String name) {
        return this.accountSelector.secureSelectByName(new Set<String>{name});
    }

    public List<Account> resolvedDynamicFieldsSOQLQuery(Account account) {
        return this.accountSelector.secureSelectByName(new Set<String>{account.Name});
    }

    @SuppressWarnings('PMD.ApexSOQLInjection')
    public List<Account> typecastDataIntelligently(String numberOfRecords) {
        return this.accountSelector.secureSelectWithMoreEmployeesThan(Integer.valueOf(numberOfRecords));
    }

    @SuppressWarnings('PMD.ApexSOQLInjection')
    public List<Account> simpleQueryBuilder(List<String> fieldSet, String whereClause) {
        return this.accountSelector.secureDynamicSelect(fieldSet, whereClause);
    }
}
