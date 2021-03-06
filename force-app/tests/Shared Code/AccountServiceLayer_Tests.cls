@IsTest
private inherited sharing class AccountServiceLayer_Tests {
    private static final AccountServiceLayer LAYER_UNDER_TEST = AccountServiceLayer.getInstance();
    @IsTest
    static void justWriteALogStatementPositive() {
        Test.startTest();
        LAYER_UNDER_TEST.justWriteALogStatement('Hello Stream Viewers');
        Test.stopTest();

        System.assertEquals(
            'Hello Stream Viewers',
                AccountServiceLayer.didExecuteMethod,
            'Expected the log to match the input parameter.'
        );
    }

    @IsTest
    static void testChangeShippingStreetNegativeNoEditAccess() {
        TriggerHandler.bypass('AccountTriggerHandler');
        Account[] accounts = (Account[]) TestFactory.createSObjectList(
            new Account(),
            5,
            true
        );
        User testUser = TestFactory.createMinAccessUser(true);
        Boolean didCatchTheProperException = false;

        Test.startTest();
        System.runAs(testUser) {
            try {
                LAYER_UNDER_TEST.changeShippingStreet(accounts);
            } catch (CanTheUserException ctue) {
                if (
                    ctue.getMessage()
                        .containsIgnoreCase('no permission to edit')
                ) {
                    didCatchTheProperException = true;
                }
            }
        }

        Test.stopTest();

        System.assert(
            didCatchTheProperException,
            'Expected to catch a CanTheUserException reporting no edit access'
        );
    }

    @IsTest
    static void incrementDescriptionOnBulkAccountsPositive() {
        List<Account> theAccounts = (List<Account>) TestFactory.createSObjectList(
            new Account(),
            5
        );

        Test.startTest();
        List<Account> updatedAccounts = LAYER_UNDER_TEST.incrementCounterInDescription(
            theAccounts,
            false
        );
        Test.stopTest();
        System.assertEquals(
            5,
            updatedAccounts.size(),
            'updatedAccounts should have 5 accounts'
        );
        for (Account ua : updatedAccounts) {
            System.assert(
                Integer.valueOf(ua.Description) == 1,
                'Expected the code to have incremented to 1'
            );
        }
    }

    @IsTest
    static void incrementDescriptionOnBulkAccountsPositiveInvalidInteger() {
        List<Account> theAccounts = (List<Account>) TestFactory.createSObjectList(
            new Account(Description = 'Hello'),
            5
        );
        Test.startTest();
        List<Account> updatedAccounts = LAYER_UNDER_TEST.incrementCounterInDescription(
            theAccounts,
            false
        );
        Test.stopTest();
        System.assertEquals(
            5,
            updatedAccounts.size(),
            'updatedAccounts should have 5 accounts'
        );
        for (Account ua : updatedAccounts) {
            System.assert(
                Integer.valueOf(ua.Description) == 1,
                'Expected the code to have incremented to 1'
            );
        }
    }

    @IsTest
    static void incrementDescriptionOnBulkAccountsNegativeInvalidIntegerSaves() {
        List<Account> theAccounts = (List<Account>) TestFactory.createSObjectList(
            new Account(Description = 'Hello'),
            5
        );
        Boolean didCatchTheRightException = false;

        Test.startTest();
        try {
            LAYER_UNDER_TEST.incrementCounterInDescription(
                theAccounts,
                true
            );
        } catch (ASLException asle) {
            if (asle.getMessage().containsIgnoreCase('id not specified')) {
                didCatchTheRightException = true;
            }
        }
        Test.stopTest();

        System.assert(
            didCatchTheRightException,
            'Expected to see the save fail'
        );
    }

    @IsTest
    static void safelySaveNegative() {
        List<Account> theAccounts = (List<Account>) TestFactory.createSObjectList(
            new Account(Description = 'Hello'),
            5
        );
        System.assertEquals(
            5,
            theAccounts.size(),
            'updatedAccounts should have 5 accounts'
        );

        for (Account checkAcct : theAccounts) {
            System.assert(checkAcct.Id == null, 'Expected the ID to be null');
        }

        Boolean didCatchTheRightException = false;
        Test.startTest();
        try {
            LAYER_UNDER_TEST.safelySave(theAccounts);
        } catch (ASLException asle) {
            System.debug(LoggingLevel.INFO, asle.getMessage());
            didCatchTheRightException = true;
        }
        Test.stopTest();

        System.assert(
            didCatchTheRightException,
            'Expected to have caught a DML exception'
        );
    }

    @IsTest
    static void safelySaveNegativeNoAccessException() {
        List<Account> theAccounts = (List<Account>) TestFactory.createSObjectList(
            new Account(Description = 'Hello'),
            5
        );
        User testUser = TestFactory.createMinAccessUser(true);

        Boolean didCatchTheRightException = false;
        Test.startTest();
        System.runAs(testUser) {
            try {
                LAYER_UNDER_TEST.safelySave(theAccounts);
            } catch (ASLException asle) {
                if (asle.getMessage().containsIgnoreCase('No Access')) {
                    didCatchTheRightException = true;
                }
            }
        }

        Test.stopTest();

        System.assert(
            didCatchTheRightException,
            'Expected to have caught a No Access Exception exception'
        );
    }
}
