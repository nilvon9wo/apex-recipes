@IsTest
@SuppressWarnings('PMD.CyclomaticComplexity')
public class DMLRecipes_Tests {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final DMLRecipes RECIPES_UNDER_TEST = new DMLRecipes();
    @IsTest
    static void testInsertPositive() {
        Test.startTest();
        System.runAs(TEST_USER) {
            RECIPES_UNDER_TEST.insertAccountViaInsertKeyword('mumbledore');
        }
        Test.stopTest();

        List<Account> acct = [SELECT Id FROM Account WHERE Name = 'mumbledore'];
        System.assertEquals(
                1,
                acct.size(),
                'We should have found the account we just created'
        );
    }

    @IsTest
    static void testInsertNegative() {
        Test.startTest();
        Boolean didCatchTheRightException = false;
        try {
            RECIPES_UNDER_TEST.insertAccountViaInsertKeyword('');
        }
        catch (CustomDMLException theException) {
            if (theException.getMessage().contains('Failed')) {
                didCatchTheRightException = true;
            }
        }
        Test.stopTest();

        System.assert(
                didCatchTheRightException,
                'Should have caught the exception'
        );
    }

    @IsTest
    static void testDatabaseMethodInsertPositive() {
        Test.startTest();
        RECIPES_UNDER_TEST.insertAccountsViaDatabaseMethod('Texas', XAP_DAO_DML_OperationModeEnum.BEST_EFFORT);
        Test.stopTest();

        List<Account> acct = [
                SELECT Id, Name
                FROM Account
                WHERE Name = 'Texas'
        ];

        System.assert(
                acct.size() == 1,
                'Expected the list of accounts to have a single account'
        );
        System.assert(
                acct[0].Name == 'Texas',
                'Expected the account name to be Texas'
        );
    }

    @IsTest
    static void testDatabaseMethodInsertNegative() {
        Test.startTest();
        Boolean didCatchTheRightException = false;
        try {
            RECIPES_UNDER_TEST.insertAccountsViaDatabaseMethod('Texas', XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
        }
        catch (CustomDMLException theException) {
            if (theException.getMessage().contains('Failed')) {
                didCatchTheRightException = true;
            }
        }
        Test.stopTest();

        System.assert(
                didCatchTheRightException,
                'Should have caught the exception'
        );
    }

    @IsTest
    static void testUpsertAccountViaUpsertKeywordTestPositive() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'IR');

        Test.startTest();
        RECIPES_UNDER_TEST.upsertAccountViaUpsertKeyword(acct);
        Test.stopTest();

        List<Account> resultingAccounts = [
                SELECT Name
                FROM Account
                WHERE Name = :acct.Name
        ];
        System.assertEquals(
                1,
                resultingAccounts.size(),
                'We expect to find a single account with that name'
        );
    }

    @IsTest
    static void testUpsertAccountViaUpsertKeywordPositive() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'IR');
        insert acct; // Gives us the ID property.
        List<Account> accounts = [SELECT Name FROM Account WHERE Id = :acct.Id];

        System.assertEquals(
                1,
                accounts.size(),
                'We expect to find one account'
        );

        Test.startTest();
        acct.Name = 'flufflernutter';
        RECIPES_UNDER_TEST.upsertAccountViaUpsertKeyword(acct);
        Test.stopTest();

        List<Account> testAccounts = [SELECT Name FROM Account];

        System.assertEquals(
                1,
                testAccounts.size(),
                'There should be only one account'
        );
    }

    @IsTest
    static void testUpsertAccountViaUpsertKeywordNegative() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'Ca');
        // Note: this is an intentionally invalid ID, used to trigger the failure case.
        acct.Id = '0019A000008GTAYQA4'; //NOPMD

        Boolean didCatchTheRightException = false;
        try {
            RECIPES_UNDER_TEST.upsertAccountViaUpsertKeyword(acct);
        }
        catch (DmlException dmlexception) {
            if (dmlexception.getDmlMessage(0) == 'invalid cross reference id') {
                didCatchTheRightException = true;
            }
        }
        System.assert(
                didCatchTheRightException,
                'Expected to get an Invalid Cross Reference Id exception'
        );
    }

    @IsTest
    static void testUpsertAccountViaDatabaseMethodNegative() {
        Account badAcct = TestDataHelpers.genAccountWithOptions(true, 'Ca');
        // Note: this is an intentionally invalid ID, used to trigger the failure case.
        badAcct.Id = '0019A000008GTAYQA4'; //NOPMD
        XAP_DAO_DML_UpsertResultListWrapper result;
        Boolean didCatchTheRightException = false;
        try {
            result = RECIPES_UNDER_TEST.upsertAccountViaDatabaseMethod(badAcct, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
        }
        catch (DmlException dmlexception) {
            if (dmlexception.getDmlMessage(0) == 'invalid cross reference id') {
                didCatchTheRightException = true;
            }
        }
        System.assert(
                didCatchTheRightException,
                'Expected to get an Invalid Cross Reference Id exception'
        );
    }

    @IsTest
    static void testUpdateAcccountViaKeywordPositive() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'It');
        insert acct;

        Test.startTest();
        acct.Name += ' + Updated';
        RECIPES_UNDER_TEST.updateAcccountViaKeyword(new List<Account>{acct});
        Test.stopTest();

        String checkAcct = [SELECT Name FROM Account WHERE Id = :acct.Id].Name;
        System.assert(
                checkAcct.containsIgnoreCase('updated'),
                'Expected to find the keyword updated in the account name'
        );
    }

    @IsTest
    static void testUpdateAcccountViaKeywordNegative() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'It');
        insert acct;
        Boolean didCatchTheRightException = false;
        Test.startTest();
        try {
            // Note: this is an intentionally invalid id used for triggering an error state
            acct.Id = '0019A000008GTAYQA4'; //NOPMD
            RECIPES_UNDER_TEST.updateAcccountViaKeyword(new List<Account>{acct});
        }
        catch (CustomDMLException theException) {
            if (theException.getMessage().contains('Failed')) {
                didCatchTheRightException = true;
            }
        }
        Test.stopTest();

        System.assert(
                didCatchTheRightException,
                'Expected to receive a CustomDMLException with message Failed'
        );
    }

    @IsTest
    static void testUpdateAcccountViaDatabaseMethodPositive() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'It');
        insert acct;

        Test.startTest();
        acct.Name += ' + Updated';
        RECIPES_UNDER_TEST.updateAccountViaDatabaseMethod(new List<Account>{acct});
        Test.stopTest();

        String checkAcct = [SELECT Name FROM Account WHERE Id = :acct.Id].Name;
        System.assert(
                checkAcct.containsIgnoreCase('updated'),
                'Expected to find the keyword updated in the account name'
        );
    }

    @IsTest
    static void testUpdateAcccountViaDatabaseMethodNegative() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'It');
        insert acct;
        Boolean didCatchTheRightException = false;
        Test.startTest();
        try {
            // Note: This is an intentionally invalid ID used for triggering an error state
            acct.Id = '0019A000008GTAYQA4'; //NOPMD
            RECIPES_UNDER_TEST.updateAccountViaDatabaseMethod(
                    new List<Account>{acct}
            );
        }
        catch (CustomDMLException theException) {
            if (theException.getMessage().contains('Failed')) {
                didCatchTheRightException = true;
            }
        }
        Test.stopTest();

        System.assert(
                didCatchTheRightException,
                'Expected to recieve a CustomDMLException with message Failed'
        );
    }

    @IsTest
    static void testDeleteAccountViaKeywordPositive() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'It');
        insert acct;

        Test.startTest();
        RECIPES_UNDER_TEST.deleteAccountViaKeyword(new List<Account>{acct});
        Test.stopTest();
        try {
            String checkAcct = [SELECT Name FROM Account WHERE Id = :acct.Id]
                    .Name; //NOPMD
        }
        catch (QueryException qe) {
            if (
                    qe.getMessage()
                            .containsIgnoreCase('list has no rows for assignment')
                    ) {
                System.assert(
                        true,
                        'Expected to get query exception as record was deleted'
                );
            }
        }
    }

    @IsTest
    static void testDeleteAccountViaKeywordNegative() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'It');
        insert acct;
        delete acct;

        Test.startTest();
        try {
            RECIPES_UNDER_TEST.deleteAccountViaKeyword(new List<Account>{acct});
        }
        catch (CustomDMLException cde) {
            if (cde.getMessage().containsIgnoreCase('failed')) {
                System.assert(
                        true,
                        'Expected to get query exception as record was deleted'
                );
            }
        }
        Test.stopTest();
    }

    @IsTest
    static void testDeleteAccountViaDatabaseMethodPositive() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'It');
        insert acct;

        Test.startTest();
        RECIPES_UNDER_TEST.deleteAccountViaDatabaseMethod(new List<Account>{acct});
        Test.stopTest();
        try {
            String checkAcct = [SELECT Name FROM Account WHERE Id = :acct.Id]
                    .Name; //NOPMD
        }
        catch (QueryException qe) {
            if (
                    qe.getMessage()
                            .containsIgnoreCase('list has no rows for assignment')
                    ) {
                System.assert(
                        true,
                        'Expected to get query exception as record was deleted'
                );
            }
        }
    }

    @IsTest
    static void testDeleteAccountViaDatabaseMethodNegative() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'It');
        insert acct;
        delete acct;

        Test.startTest();
        try {
            RECIPES_UNDER_TEST.deleteAccountViaDatabaseMethod(
                    new List<Account>{acct}
            );
        }
        catch (CustomDMLException cde) {
            if (cde.getMessage().containsIgnoreCase('failed')) {
                System.assert(
                        true,
                        'Expected to get query exception as record was deleted'
                );
            }
        }
        Test.stopTest();
    }

    @IsTest
    static void testUndeleteAccountViaKeywordPositive() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'IR');
        insert acct;
        delete acct;
        Test.startTest();
        RECIPES_UNDER_TEST.undeleteAccountViaKeyword(new List<Account>{acct});
        Test.stopTest();
        List<Account> checkAcct = [
                SELECT Name
                FROM Account
                WHERE Id = :acct.Id
        ];
        System.assert(
                checkAcct.size() == 1,
                'Expected to find a single account'
        );
    }

    @IsTest
    static void testUndeleteAccountViaKeywordNegative() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'IR');
        insert acct;
        Boolean didCatchTheRightException = false;
        Test.startTest();
        try {
            RECIPES_UNDER_TEST.undeleteAccountViaKeyword(new List<Account>{acct});
        }
        catch (CustomDMLException theException) {
            if (theException.getMessage().contains('Failed')) {
                didCatchTheRightException = true;
            }
        }
        Test.stopTest();
        System.assert(
                didCatchTheRightException,
                'Expected to find a single account'
        );
    }

    @IsTest
    static void testUndeleteAccountViaDatabaseMethodPositive() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'IR');
        insert acct;
        delete acct;
        Test.startTest();
        RECIPES_UNDER_TEST.undeleteAccountViaDatabaseMethod(new List<Account>{acct});
        Test.stopTest();
        List<Account> checkAcct = [
                SELECT Name
                FROM Account
                WHERE Id = :acct.Id
        ];
        System.assert(
                checkAcct.size() == 1,
                'Expected to find a single account'
        );
    }

    @IsTest
    static void testUndeleteAccountViaDatabaseMethodNegative() {
        Account acct = TestDataHelpers.genAccountWithOptions(true, 'IR');
        insert acct;
        Boolean didCatchTheRightException = false;
        Test.startTest();
        try {
            RECIPES_UNDER_TEST.undeleteAccountViaDatabaseMethod(
                    new List<Account>{acct}
            );
        }
        catch (CustomDMLException theException) {
            if (theException.getMessage().contains('Failed')) {
                didCatchTheRightException = true;
            }
        }
        Test.stopTest();
        System.assert(
                didCatchTheRightException,
                'Expected to find a single account'
        );
    }
}
