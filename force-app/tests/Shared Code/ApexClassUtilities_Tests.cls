/*
 * @see Foo, Bar
 */
@IsTest
private class ApexClassUtilities_Tests {
    private static final ApexClassUtilities UTILITIES_UNDER_TEST = new ApexClassUtilities();
    @IsTest
    static void testGetRelatedClassesFromClassBodyPositive() {
        ApexClass acu = [
            SELECT Id, Body
            FROM ApexClass
            WHERE Name LIKE 'ApexClassUtilities_Tests'
        ];
        Test.startTest();
        String results = UTILITIES_UNDER_TEST.getRelatedClassesFromClassBody(acu);
        Test.stopTest();

        System.assert(
            results.containsIgnoreCase('Foo'),
            'Expected to see Foo'
        );
        System.assert(
            results.containsIgnoreCase('Bar'),
            'Expected to see Bar'
        );
    }

    @IsTest
    static void testGetRelatedClassesFromClassBodyNegativeToComplex() {
        ApexClass klass = [
            SELECT Id, Body, Name
            FROM ApexClass
            WHERE Name LIKE 'DynamicSOQLRecipes_Tests'
        ];
        Test.startTest();
        String results = UTILITIES_UNDER_TEST.getRelatedClassesFromClassBody(
            klass
        );
        Test.stopTest();
        System.assertEquals('', results, 'Expected empty string');
    }
}
