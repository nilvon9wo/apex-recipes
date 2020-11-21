@IsTest
private inherited sharing class AuraEnabledRecipesAuraCtrl_Tests {
    @IsTest
    static void testUpdateAccountNamePositive() {
        Account acct = (Account) TestFactory.createSObject(
            new Account(Name = 'Original Name'),
            true
        );

        Test.startTest();
        AuraEnabledRecipesAuraCtrl.updateAccountName(acct.Id, 'New Name');
        Test.stopTest();

        Account updatedAcct = [SELECT Name FROM Account WHERE Id = :acct.Id];
        System.assertEquals(
            updatedAcct.Name,
            'New Name',
            'Expected the account name to be updated.'
        );
    }

    @IsTest
    static void testUpdateAccountNameNegativeInvalidName() {
        Account acct = (Account) TestFactory.createSObject(
            new Account(Name = 'Original'),
            true
        );

        Boolean didCatchTheRightException = false; // this defaults to a null, but non true or false state;

        Test.startTest();
        try {
            AuraEnabledRecipesAuraCtrl.updateAccountName(acct.Id, '');
        } catch (System.AuraHandledException ahe) {
            if (
                ahe.getMessage().containsIgnoreCase('Script-thrown exception')
            ) {
                didCatchTheRightException = true;
            }
        }
        Test.stopTest();

        System.assert(
            didCatchTheRightException,
            'Expected to have recieved an Aura Handled Exception'
        );
    }

    @IsTest
    static void testUpdateAccountNameNegativeMinAccessProfile() {
        Account acct = (Account) TestFactory.createSObject(
            new Account(Name = 'Original Name'),
            true
        );
        Boolean didCatchTheRightException = false;

        User u = TestFactory.createMinAccessUser(true);
        System.runAs(u) {
            try {
                AuraEnabledRecipesAuraCtrl.updateAccountName(acct.Id, 'newValue');
            } catch (System.AuraHandledException ahe) {
                if (
                    ahe.getMessage()
                        .containsIgnoreCase('Script-thrown exception')
                ) {
                    didCatchTheRightException = true;
                }
            }
        }
        System.assert(
            didCatchTheRightException,
            'Expected a user with min access profile to not be able to execute the DML update.'
        );
    }

    @IsTest
    static void testGetFieldValue() {
        System.assert(
            AuraEnabledRecipesAuraCtrl.getFieldValue().equalsIgnoreCase('hello world'),
            'Expected to receive hello world'
        );
    }
}
