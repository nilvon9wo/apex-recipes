@IsTest
private inherited sharing class QueueableChainingRecipes_Tests {
    @TestSetup
    static void makeData() {
        TestFactory.createSObjectList(new Account(), 20, true);
    }

    @IsTest
    static void chainedQueueableTestPositive() {
        Test.startTest();
        new QueueableChainingRecipes().execute(null);
        Test.stopTest();
        List<Account> checkAccounts = [SELECT Description FROM Account];
        System.assert(
            checkAccounts.size() == 20,
            'Expected to find 20 accounts'
        );
        for (Account acct : checkAccounts) {
            System.assert(
                acct.Description.containsIgnoreCase('first chained Queuable'),
                'Expected to see evidence of first Queeuable job in account description'
            );
            System.assert(
                acct.Description.containsIgnoreCase(
                    'Edited by Queueable class'
                ),
                'Expected to see evidence of second Queeuable job in account description'
            );
        }
    }
}
