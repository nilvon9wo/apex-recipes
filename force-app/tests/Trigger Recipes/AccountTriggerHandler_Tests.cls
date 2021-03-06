@IsTest
private inherited sharing class AccountTriggerHandler_Tests {
    static {
        TEST_DummyXapTriggerSettingFactoryOutlet.prepareIntegrationTest();
    }

    @IsTest
    static void beforeInsertTestPositive() {
        Account acct = (Account) TestFactory.createSObject(
            new Account(Name = 'TheBestAccount'),
            false
        );

        Test.startTest();
        insert acct;
        Test.stopTest();

        Account check = [SELECT Id, Description FROM Account LIMIT 1];
        System.assertEquals(
            Integer.valueOf(check.Description),
            1,
            'Expected to see that the before insert trigger has updated the description'
        );
    }

    @IsTest
    static void afterInsertBulkTestPositive() {
        Test.startTest();
        TestFactory.createSObjectList(new Account(), 200, true);
        Test.stopTest();

        List<Account> checkAccounts = [
            SELECT Id, Description, ShippingStreet
            FROM Account
        ];
        System.assertEquals(
            200,
            checkAccounts.size(),
            'updatedAccounts should have 5 accounts'
        );
        for (Account check : checkAccounts) {
            System.assert(
                check.ShippingStreet.containsIgnoreCase('229b baker st'),
                'Expected the after trigger to have set the shipping address'
            );
            System.assertEquals(
                Integer.valueOf(check.Description),
                1,
                'Expected to see that the before insert trigger has updated the description'
            );
        }
    }

    @IsTest
    static void testAfterInsertPositive() {
        // There's debate on where to test the functionality of this code.
        // Some might argue it's in the AccountServiceLayer_tests
        // Others might argue here, in the AccountTriggerHandler_tests
        // This project provides tests in both locations, exercising the code differently
        Test.startTest();
        Account[] testData = (Account[]) TestFactory.createSObjectList(
            new Account(ShippingStreet = '123 sesame st.'),
            200,
            true
        );
        Test.stopTest();

        Account[] afterInsertResults = [
            SELECT Id, ShippingStreet
            FROM Account
            WHERE Id IN :testData
        ];

        System.assertEquals(
            200,
            afterInsertResults.size(),
            'updatedAccounts should have 5 accounts'
        );
        for (Account acct : afterInsertResults) {
            System.assert(
                acct.ShippingStreet.containsIgnoreCase('229b Baker st.'),
                'Expected to see the shipping address updated'
            );
        }
    }

    @IsTest
    static void testBeforeUpdatePositive() {
        // There's debate on where to test the functionality of this code.
        // Some might argue it's in the AccountServiceLayer_tests
        // Others might argue here, in the AccountTriggerHandler_tests
        // This project provides tests in both locations, exercising the code differently
        Test.startTest();
        Account[] testData = (Account[]) TestFactory.createSObjectList(
            new Account(ShippingStreet = '123 sesame st.'),
            200,
            true
        );
        Test.stopTest();

        Account[] afterInsertResults = [
            SELECT Id, ShippingStreet
            FROM Account
            WHERE Id IN :testData
        ];

        System.assertEquals(
            200,
            afterInsertResults.size(),
            'updatedAccounts should have 5 accounts'
        );
        for (Account acct : afterInsertResults) {
            System.assert(
                acct.ShippingStreet.containsIgnoreCase('before update trigger'),
                'Expected to see the shipping address updated'
            );
        }
    }

    @IsTest
    static void testBeforeUpdateWithAddErrorNegative() {
        Boolean didCatchProperException = false;
        Test.startTest();
        try {
            TestFactory.createSObjectList(
                new Account(
                    ShippingStreet = '123 sesame st.',
                    ShippingState = 'BAD STATE CODE'
                ),
                20,
                true
            );
        } catch (DmlException dmle) {
            if (
                dmle.getMessage()
                    .containsIgnoreCase(
                        'shipping state length exceeds maximum allowed'
                    )
            ) {
                didCatchProperException = true;
            }
        }

        Test.stopTest();
        System.assert(
            didCatchProperException,
            'Expected to have caught a DML exception thrown by addError'
        );
    }

    @IsTest
    static void afterUpdateTestPositive() {
        Account[] testData = (Account[]) TestFactory.createSObjectList(
            new Account(ShippingStreet = '123 sesame st.'),
            200,
            true
        );

        for (Account acct : testData) {
            acct.ShippingStreet = '';
        }
        Test.startTest();
        update testData;
        Test.stopTest();

        Task[] tasks = [
            SELECT Id, Subject
            FROM Task
            WHERE
                WhatId IN :testData
                AND Subject LIKE 'account was updated, please verify'
        ];
        System.assertEquals(
            400, // this is 400 because our trigger calls the AccountServiceLayer method in addition to this update.
            tasks.size(),
            'Expect 400 tasks to be created'
        );
        for (Task tsk : tasks) {
            System.assert(
                tsk.Subject.containsIgnoreCase('Account was Updated'),
                'Expected task subject to be: "Account was Updated"'
            );
        }
    }

    @IsTest
    static void afterUpdateTestNegativeDMLException() {
        Account[] testData = (Account[]) TestFactory.createSObjectList(
            new Account(ShippingStreet = '123 sesame st.'),
            5,
            true
        );
        Boolean didCatchProperException = false;
        for (Account acct : testData) {
            acct.ShippingStreet = '';
        }
        ARTR_DAO_TaskInserter.circuitBreaker = new DmlException();
        Test.startTest();
        try {
            update testData;
        } catch (DmlException dmle) {
            /**
             * This is a bit of a counter-intuitive test. Our code in the trigger
             * handler is aweare a DML exception may occur. It catches that DML error
             * and, as this test shows throws an AccountTriggerHandlerException. However
             * because that code is executed in the context of a trigger any exception
             * thrown by the accountTriggerHandler is wrapped in a second DMLException.
             * Therefore, our Catch block caches a DMLException, but we test for the
             * langauge used by the AccountTriggerHandlerException.
             */
            if (dmle.getMessage().containsIgnoreCase('failed to insert')) {
                didCatchProperException = true;
            }
        }
        Test.stopTest();

        System.assert(
            didCatchProperException,
            'Expected to have caught a DMLE esception and thrown an AccountTriggerHandlerException'
        );
    }

    @IsTest
    static void beforeDeleteTestPositive() {
        Account acct = (Account) TestFactory.createSObject(
            new Account(Name = 'TheBestAccount'),
            true
        );
        Id accountId = acct.Id;

        Test.startTest();
        delete new List<Account>{ acct };
        Test.stopTest();

        Account acctCheck = [
            SELECT Id, IsDeleted
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
            ALL ROWS
        ];
        System.assert(acctCheck.IsDeleted, 'expected to see the account');

        List<Account> acctCloneCheck = [SELECT Id FROM Account];
        System.assertEquals(
            1,
            acctCloneCheck.size(),
            'Expected to find a single clone after delete'
        );
    }

    @IsTest
    static void afterDeleteTestPositive() {
        Account[] testData = (Account[]) TestFactory.createSObjectList(
            new Account(ShippingStreet = '123 sesame st.'),
            200,
            true
        );

        Test.startTest();
        delete testData;
        Test.stopTest();

        Task[] tasks = [
            SELECT Id, Subject
            FROM Task
            WHERE Subject LIKE 'account was deleted, please verify'
        ];
        System.assertEquals(
            200, // this is 400 because our trigger calls the AccountServiceLayer method in addition to this update.
            tasks.size(),
            'Expected 200 tasks to be created'
        );
        for (Task tsk : tasks) {
            System.assert(
                tsk.Subject.containsIgnoreCase('Account was deleted'),
                'Expected task Subject to be: "Account was deleted"'
            );
        }
    }
}
