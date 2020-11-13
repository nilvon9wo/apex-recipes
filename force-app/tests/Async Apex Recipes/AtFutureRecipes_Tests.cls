@IsTest
public inherited sharing class AtFutureRecipes_Tests {
    @IsTest
    static void callBasicAtFutureMethodTestPositive() {
        Test.startTest();
        AtFutureRecipes.atFutureMethodWithoutCalloutPrivileges();
        Test.stopTest();
        System.assert(
            AtFutureRecipes.testCircuitBreaker,
            'Expected the code to have set the testCircuitBreaker to true.'
        );
    }

    @SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
    @IsTest
    static void callAtFutureCalloutPositive() {
        HttpCalloutMockFactory mock = new HttpCalloutMockFactory(
            200,
            'OK',
            'Hello World',
            new Map<String, String>()
        );
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        AtFutureRecipes.atFutureMethodWithCalloutPrivileges(
            'https://developer.salesforce.com'
        );
        Test.stopTest();
    }

    @IsTest
    static void callAtFutureMethodWithCalloutNegative() {
        HttpCalloutMockFactory mock = new HttpCalloutMockFactory(
            400,
            'OK',
            'Hello World',
            new Map<String, String>()
        );
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        AtFutureRecipes.atFutureMethodWithCalloutPrivileges(
            'https://developer.salesforce.com'
        );
        Test.stopTest();
        System.assert(
            AtFutureRecipes.testCircuitBreaker,
            'Expected to have triggered the testCircuitBreaker'
        );
    }
}
