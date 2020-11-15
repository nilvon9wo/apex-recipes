/*
 * @see Foo, Bar
 */
@IsTest
private class RelatedCodeTabsController_Tests {
    @IsTest
    static void testGetRelatedClassesPositive() {
        Test.startTest();
        String[] relatedClasses = RelatedCodeTabsController.getRelatedClasses(
            'RelatedCodeTabsController_Tests'
        );
        Test.stopTest();
        Set<String> rcSet = new Set<String>(relatedClasses);
        System.assert(
            rcSet.contains('Foo'),
            'Expected to see Foo listed'
        );
        System.assert(
            rcSet.contains('Bar'),
            'Expected to see the Bar listed'
        );
    }

    @IsTest
    static void testGetRElatedClassesNegative() {
        Boolean didCatchProperException = false;
        Test.startTest();
        try {
            RelatedCodeTabsController.getRelatedClasses(
                'FormattedRecipeController_Tests' // this is a non-existant class
            );
        } catch (QueryException qe) {
            if (qe.getMessage().containsIgnoreCase('no rows for assignment')) {
                didCatchProperException = true;
            }
        }

        Test.stopTest();
        System.assert(
            didCatchProperException,
            'Expected to catch a query exception'
        );
    }

    @IsTest
    static void testGetRElatedClassesNegativeNoRelated() {
        Test.startTest();
        String[] relatedClasses = RelatedCodeTabsController.getRelatedClasses(
            'DMLRecipes_Tests'
        );

        Test.stopTest();
        System.assert(
            relatedClasses.size() == 0,
            'Expected to catch a query exception'
        );
    }
}
