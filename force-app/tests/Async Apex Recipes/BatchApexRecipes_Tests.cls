@IsTest
private inherited sharing class BatchApexRecipes_Tests {
    @TestSetup
    static void makeData() {
        TestFactory.createSObjectList(new Account(), 200, true);
    }

    @IsTest
    static void batchApexRecipesTestPositive200Scope() {
        Test.startTest();
        Database.executeBatch(new BatchApexRecipes());
        Test.stopTest();

        List<Account> checkAccounts = [SELECT Name FROM Account];
        System.assert(
            checkAccounts.size() == 200,
            'Expected to find 200 accounts'
        );
        for (Account acct : checkAccounts) {
            System.assert(
                acct.Name.containsIgnoreCase(' Edited by Batch class'),
                'Accounts should have \'edited by batch class\' after batch job execution'
            );
        }
        System.assert(
            BatchApexRecipes.result.equalsIgnoreCase(
                'Successes: 200 Failures: 0'
            ),
            'Expected all successes'
        );
    }

    @IsTest
    static void batchApexRecipesTestNegative() {
        Test.startTest();
        BatchApexRecipes batchJob = new BatchApexRecipes();
        batchJob.throwError = true;
        Database.executeBatch(batchJob);
        Test.stopTest();
        System.assert(
            BatchApexRecipes.result.equalsIgnoreCase(
                'Successes: 0 Failures: 200'
            ),
            'Expected all failures'
        );
    }
}
