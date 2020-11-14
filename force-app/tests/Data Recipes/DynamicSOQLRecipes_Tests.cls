@IsTest
private inherited sharing class DynamicSOQLRecipes_Tests {
    private static final DynamicSOQLRecipes RECIPES_UNDER_TEST = new DynamicSOQLRecipes();

    @TestSetup
    static void makeData() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'MX');
        insert acct;
    }

    @IsTest
    static void simpleDynamicSOQLQueryTest() {
        Test.startTest();
        List<Account> results = RECIPES_UNDER_TEST.simpleDynamicSOQLQuery();
        Test.stopTest();

        System.assert(results.size() == 1, 'Expected to find a single account');
    }

    @IsTest
    static void simpleBindingSOQLQueryTestPositive() {
        String acctName = [SELECT Name FROM Account LIMIT 1].Name;
        Test.startTest();
        List<Account> results = RECIPES_UNDER_TEST.simpleBindingSOQLQuery(
            acctName
        );
        Test.stopTest();

        System.assert(results.size() == 1, 'Expected to find a single account');
    }

    @IsTest
    static void simpleBindingSOQLQueryTestNegative() {
        String acctName = [SELECT Name FROM Account LIMIT 1].Name + '\'';
        Test.startTest();
        List<Account> results = RECIPES_UNDER_TEST.simpleBindingSOQLQuery(
            acctName
        );
        Test.stopTest();

        System.assert(
            results.size() == 0,
            'Expected to fail to find an account'
        );
    }

    @IsTest
    static void resolvedDynamicFieldsSOQLQueryTestPositive() {
        Account acct = [SELECT Name FROM Account LIMIT 1];
        Test.startTest();
        List<Account> results = RECIPES_UNDER_TEST.resolvedDynamicFieldsSOQLQuery(
            acct
        );
        Test.stopTest();

        System.assert(results.size() == 1, 'Expected to find an Account');
    }

    @IsTest
    static void typecastDataIntelligentlyTestPositive() {
        Account acct = [SELECT Name FROM Account LIMIT 1];
        acct.NumberOfEmployees = 55;
        update acct;

        Test.startTest();
        List<Account> results = RECIPES_UNDER_TEST.typecastDataIntelligently(
            '50'
        );
        Test.stopTest();

        System.assert(results.size() == 1, 'Expected to find an Account');
    }

    @IsTest
    static void typecastDataIntelligentlyTestNoResult() {
        Account acct = [SELECT Name FROM Account LIMIT 1];
        acct.NumberOfEmployees = 55;
        update acct;

        Test.startTest();
        List<Account> results = RECIPES_UNDER_TEST.typecastDataIntelligently(
            '500'
        );
        Test.stopTest();

        System.assert(results.size() == 0, 'Expected to not find an Account');
    }

    @IsTest
    static void simpleQueryBuilderTestPositive() {
        Id acctId = [SELECT Id FROM Account LIMIT 1].Id;
        List<String> fields = new List<String>{
            'Name',
            'NumberOfEmployees',
            'BillingAddress'
        };
        String whereClause =
            'id = \'' +
            String.escapeSingleQuotes(acctId) +
            '\'';
        Test.startTest();
        List<Account> results = RECIPES_UNDER_TEST.simpleQueryBuilder(
            fields,
            whereClause
        );
        Test.stopTest();

        System.assert(results.size() == 1, 'Expected to find a single account');
    }
}
