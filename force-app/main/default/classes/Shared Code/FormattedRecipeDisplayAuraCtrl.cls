public inherited sharing class FormattedRecipeDisplayAuraCtrl {
    DAO_ApexClassSelector apexClassSelector;

    private FormattedRecipeDisplayAuraCtrl(DAO_ApexClassSelector apexClassSelector) {
        this.apexClassSelector = apexClassSelector;
    }

    private FormattedRecipeDisplayAuraCtrl() {
        this(DAO_ApexClassSelector.getInstance());
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @AuraEnabled(Cacheable=true)
    public static ClassData getRecipeCode(String recipeName) {
        return new FormattedRecipeDisplayAuraCtrl()
                .selectRecipeCode(recipeName);
    }

    private ClassData selectRecipeCode(String recipeName) {
        ApexClass klass = this.apexClassSelector.selectByName(new Set<String>{recipeName.trim()})[0];
        return new ClassData(klass);
    }
}
