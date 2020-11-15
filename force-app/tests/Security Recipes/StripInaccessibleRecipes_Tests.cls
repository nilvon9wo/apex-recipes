@IsTest
private inherited sharing class StripInaccessibleRecipes_Tests {
    private static final StripInaccessibleRecipes RECIPES_UNDER_TEST = new StripInaccessibleRecipes();

    @TestSetup
    static void createCampaigns() {
        TestFactory.createSObjectList(
            new Campaign(BudgetedCost = 200, ActualCost = 299),
            150,
            true
        );

        List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
            new Account(),
            150,
            true
        );
        List<Contact> contacts = new List<Contact>();
        for (Account acct : accounts) {
            contacts.addAll(
                (List<Contact>) TestFactory.createSObjectList(
                    new Contact(AccountId = acct.Id),
                    10
                )
            );
        }
        insert contacts;
    }

    @IsTest
    static void testStripInaccessibleFromQueryPositive() {
        Test.startTest();
        List<Campaign> results = RECIPES_UNDER_TEST.stripInaccessibleFromQuery();
        Test.stopTest();

        System.assertNotEquals(
            0,
            results.size(),
            'Results should not have a size of 0'
        );

        for (Campaign cmp : results) {
            System.assertNotEquals(
                null,
                cmp.BudgetedCost,
                'Expected the system profile to be able to see the budgeted cost'
            );
            System.assertNotEquals(
                null,
                cmp.ActualCost,
                'Expected the system profile to be able to see the actual cost'
            );
        }
    }

    @IsTest
    static void testStripInaccessibleFromQueryNegative() {
        User minAccess = TestFactory.createMinAccessUser(true);
        Boolean didCatchTheRightException = false;

        System.runAs(minAccess) {
            Test.startTest();
            try {
                RECIPES_UNDER_TEST.stripInaccessibleFromQuery();
            } catch (NoAccessException nae) {
                if (
                    nae.getMessage().containsIgnoreCase('no access to entity')
                ) {
                    didCatchTheRightException = true;
                }
            }
            Test.stopTest();
        }

        System.assert(
            didCatchTheRightException,
            'Expected to recieve a no Access Exception'
        );
    }

    @IsTest
    static void testStripInaccessibleFromQueryMinAccessWithPermsetPositive() {
        User minAccessWithPermset = TestFactory.createMinAccessUser(true);
        TestFactory.assignPermSetToUser(
            minAccessWithPermset,
            'provides_access_to_actual_cost_field_on_campaign'
        );

        List<Campaign> results;
        Test.startTest();
        System.runAs(minAccessWithPermset) {
            results = RECIPES_UNDER_TEST.stripInaccessibleFromQuery();
        }
        Test.stopTest();
        System.assertNotEquals(
            0,
            results.size(),
            'Results should be greater than 0 in size'
        );
        for (Campaign cmp : results) {
            System.assertEquals(
                299,
                cmp.ActualCost,
                'Expected the user with the permset to be able to see the actual cost'
            );
        }
    }

    @IsTest
    static void testStripInaccessibleFromQueryMinAccessWithPermsetNegative() {
        User minAccessWithPermset = TestFactory.createMinAccessUser(true);
        TestFactory.assignPermSetToUser(
            minAccessWithPermset,
            'provides_access_to_actual_cost_field_on_campaign'
        );

        List<Campaign> results;
        Test.startTest();
        System.runAs(minAccessWithPermset) {
            results = RECIPES_UNDER_TEST.stripInaccessibleFromQuery();
        }
        Test.stopTest();

        Map<Id, Boolean> assertionChecks = new Map<Id, Boolean>();

        for (Campaign cmp : results) {
            assertionChecks.put(cmp.Id, false);
            try {
                System.debug(System.LoggingLevel.NONE, cmp.BudgetedCost);
            } catch (SObjectException soe) {
                if (
                    soe.getMessage()
                        .containsIgnoreCase(
                            'row was retrieved via SOQL without querying the requested field'
                        )
                ) {
                    assertionChecks.put(cmp.Id, true);
                }
            }
        }

        for (Boolean boolCheck : assertionChecks.values()) {
            System.assert(
                boolCheck,
                'Expected every row to throw exception on budged cost'
            );
        }
    }

    @IsTest
    static void testStripInaccessibleFromSubQueryMinAccessWithpermsetPositive() {
        User minAccess = TestFactory.createMinAccessUser(true);
        TestFactory.assignPermSetToUser(
            minAccess,
            'Provides_Read_Only_Access_to_Account_and_all_fields'
        );
        TestFactory.assignPermSetToUser(
            minAccess,
            'Provides_Read_Access_to_Contact_and_Contact_Name_field'
        );
        Map<Id, Boolean> assertionChecks = new Map<Id, Boolean>();
        List<Account> results;
        Test.startTest();
        System.runAs(minAccess) {
            results = RECIPES_UNDER_TEST.stripInaccessibleFromSubquery();
        }
        Test.stopTest();
        for (Account acct : results) {
            assertionChecks.put(acct.Id, false);
            List<Contact> contacts = acct.getSObjects('Contacts');
            if (contacts.size() != 0) {
                assertionChecks.put(acct.Id, true);
            }
        }
        System.assertNotEquals(
            0,
            assertionChecks.values().size(),
            'assertionChecks should be greater than 0 in size'
        );
        for (Boolean boolCheck : assertionChecks.values()) {
            System.assert(
                boolCheck,
                'Expected every row to throw exception on attempt to access Contacts'
            );
        }
    }

    @IsTest
    static void testStripInaccessibleFromSubQueryMinAccessWithPermsetNegative() {
        User minAccess = TestFactory.createMinAccessUser(true);
        TestFactory.assignPermSetToUser(
            minAccess,
            'Provides_Read_Only_Access_to_Account_and_all_fields'
        );
        Map<Id, Boolean> assertionChecks = new Map<Id, Boolean>();

        List<Account> results;
        Test.startTest();
        System.runAs(minAccess) {
            results = RECIPES_UNDER_TEST.stripInaccessibleFromSubquery();
        }
        Test.stopTest();

        for (Account acct : results) {
            assertionChecks.put(acct.Id, false);
            try {
                List<Contact> contacts = acct.getSObjects('Contacts');
                if (contacts == null) {
                    assertionChecks.put(acct.Id, true);
                }
            } catch (SObjectException soe) {
                System.debug(
                    LoggingLevel.INFO,
                    '%%%% Caught SObject Exception'
                );
                if (
                    soe.getMessage()
                        .containsIgnoreCase(
                            'row was retrieved via SOQL without querying the requested field'
                        )
                ) {
                    assertionChecks.put(acct.Id, true);
                }
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, '!!!!!! ' + e.getMessage());
            }
        }
        System.assertNotEquals(
            0,
            assertionChecks.values().size(),
            'assertionChecks should be greater than 0 in size'
        );
        for (Boolean boolCheck : assertionChecks.values()) {
            System.assert(
                boolCheck,
                'Expected every row to throw exception on attempt to access Contacts'
            );
        }
    }

    @IsTest
    static void testStripInaccessibleBeforeDMLMinAccessWithPermSetPositive() {
        User minAccessWithPermSet = TestFactory.createMinAccessUser(true);
        TestFactory.assignPermSetToUser(
            minAccessWithPermSet,
            'Provides_create_access_to_Contact_and_contact_email_field'
        );
        List<Contact> contacts = (List<Contact>) TestFactory.createSObjectList(
            new Contact(Email = 'foo@bar.com', Title = 'Awesome'),
            150
        );

        Test.startTest();
        System.runAs(minAccessWithPermSet) {
            RECIPES_UNDER_TEST.stripInaccessibleBeforeDML(contacts);
        }
        Test.stopTest();

        // Our @TestSetup method creates 1500 contacts, so this query specifically limits to the known email adddress
        List<Contact> checkContacts = [
            SELECT Email, Title
            FROM Contact
            WHERE Email = 'foo@bar.com'
        ];
        System.assertEquals(
            150,
            checkContacts.size(),
            'Expected to find 150 contacts'
        );
        for (Contact cnt : checkContacts) {
            System.assertNotEquals(
                'Awesome',
                cnt.Title,
                'Expected stripInaccessible to strip out the title field'
            );
        }
    }

    @IsTest
    static void testStripInaccessibleBeforeDMLMinAccessProfileNegative() {
        User minAccess = TestFactory.createMinAccessUser(true);
        List<Contact> contacts = (List<Contact>) TestFactory.createSObjectList(
            new Contact(),
            150
        );
        Boolean didCatchRightException = false;
        Test.startTest();
        System.runAs(minAccess) {
            try {
                RECIPES_UNDER_TEST.stripInaccessibleBeforeDML(contacts);
            } catch (NoAccessException nae) {
                if (
                    nae.getMessage().containsIgnoreCase('no access to entity')
                ) {
                    didCatchRightException = true;
                }
            }
        }
        Test.stopTest();

        System.assert(
            didCatchRightException,
            'Expected to have caught a no access exception when run as the minimum access user'
        );
    }

    @IsTest
    static void testStripInaccessibleFromUntrustedDataMinAccessWithPermSetPositive() {
        User minAccessWithPermSet = TestFactory.createMinAccessUser(true);
        TestFactory.assignPermSetToUser(
            minAccessWithPermSet,
            'Provides_edit_access_to_Accounts_except_shippingStreet'
        );
        List<Account> accounts = [SELECT Name FROM Account];
        for (Account acct : accounts) {
            acct.ShippingStreet = '123 main st.';
        }

        Test.startTest();
        System.runAs(minAccessWithPermSet) {
            RECIPES_UNDER_TEST.stripInaccessibleFromUntrustedData(
                JSON.serialize(accounts)
            );
        }
        Test.stopTest();

        List<Account> checkAccounts = [
            SELECT Name, ShippingStreet
            FROM Account
        ];
        System.assertEquals(
            150,
            checkAccounts.size(),
            'Expected to find 150 accounts'
        );

        for (Account acct : checkAccounts) {
            System.assert(
                acct.ShippingStreet.containsIgnoreCase('123 main st.'),
                'Expected that a user with this perm set assigned should be able to update the shipping street'
            );
        }
    }

    @IsTest
    static void testStripInaccessibleFromUntrustedDataNegative() {
        User minAccess = TestFactory.createMinAccessUser(true);
        List<Account> acct = (List<Account>) TestFactory.createSObjectList(
            new Account(Name = 'secure'),
            1,
            true
        );
        acct[0].ShippingStreet = '123 main st.';
        Boolean didCatchRightException = false;

        Test.startTest();
        System.runAs(minAccess) {
            try {
                RECIPES_UNDER_TEST.stripInaccessibleFromUntrustedData(
                    JSON.serialize(acct)
                );
            } catch (NoAccessException nae) {
                if (
                    nae.getMessage().containsIgnoreCase('no access to entity')
                ) {
                    didCatchRightException = true;
                }
            }
        }
        Test.stopTest();
        System.assert(
            didCatchRightException,
            'Expected to have caught a NoAccessException'
        );
    }
}
