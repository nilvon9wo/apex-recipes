@IsTest
private inherited sharing class QueueableRecipes_Tests {
    @TestSetup
    static void makeData() {
        TestFactory.createSObjectList(new Account(), 200, true);
    }

    @IsTest
    static void testQueueableWithCalloutRecipesPositive() {
        Test.startTest();
        QueueableRecipes queueable = new QueueableRecipes();
        System.enqueueJob(queueable);
        Test.stopTest();

        List<Account> checkAccounts = [SELECT Description FROM Account];
        System.assert(
            checkAccounts.size() == 200,
            'Expected to find 200 accounts'
        );
        for (Account account : checkAccounts) {
            System.assert(
                account.Description.containsIgnoreCase(
                    'edited by queueable class'
                ),
                'Expected to find all accounts\'s to have been edited to include edited by queueable class'
            );
        }
    }
}
