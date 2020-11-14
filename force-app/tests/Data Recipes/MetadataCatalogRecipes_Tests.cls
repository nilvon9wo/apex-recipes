@IsTest
private inherited sharing class MetadataCatalogRecipes_Tests {
    private static final MetadataCatalogRecipes RECIPES_UNDER_TEST = new MetadataCatalogRecipes();

    @IsTest
    static void testFindAllFormulaFieldsPositive() {
        Map<String, Map<String, String>> results;
        Test.startTest();
        results = RECIPES_UNDER_TEST.findAllFormulaFields();
        Test.stopTest();

        System.assertNotEquals(
            null,
            results,
            'Expected the findAllFormulaFields to return some data'
        );
    }

    @IsTest
    static void testFindAllContactFieldsThatLookupToAccountPositive() {
        List<LookupRelationshipDefinition> relatesToAccounts;
        Test.startTest();
        relatesToAccounts = RECIPES_UNDER_TEST.findAllContactFieldsThatLookupToAccount();
        Test.stopTest();

        System.assertNotEquals(
            null,
            relatesToAccounts,
            'Expected to find at least one field on an object that relates to account'
        );
    }
}
