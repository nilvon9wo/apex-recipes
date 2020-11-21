public inherited sharing class FormattedRecipeDisplayController {
    DAO_ApexClassSelector apexClassSelector;

    private FormattedRecipeDisplayController(DAO_ApexClassSelector apexClassSelector) {
        this.apexClassSelector = apexClassSelector;
    }

    private FormattedRecipeDisplayController() {
        this(DAO_ApexClassSelector.getInstance());
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @AuraEnabled(Cacheable=true)
    public static ClassData getRecipeCode(String recipeName) {
        return new FormattedRecipeDisplayController()
                .selectRecipeCode(recipeName);
    }

    private ClassData selectRecipeCode(String recipeName) {
        ApexClass klass = this.apexClassSelector.selectByName(new Set<String>{recipeName.trim()})[0];
        return new ClassData(klass);
    }
}
