@IsTest
private class SOSLRecipes_Tests {
    private static final SOSLRecipes RECIPES_UNDER_TEST = new SOSLRecipes();

    @TestSetup
    static void makeData() {
        Account a1 = new Account(Name = 'KS');
        Account a2 = new Account(Name = 'bob', ShippingState = 'KS');
        Account a3 = new Account(Name = 'oz');

        insert new List<Account>{ a1, a2, a3 };

        Contact c1 = new Contact(AccountId = a1.Id, LastName = 'Kansas');
        Contact c2 = new Contact(AccountId = a2.Id, LastName = 'Alaska');
        Contact c3 = new Contact(AccountId = a3.Id, LastName = 'Ted');

        insert new List<Contact>{ c1, c2, c3 };
    }

    @IsTest
    static void basicSOSLSearch() {
        Map<Id, Account> fakeResults = new Map<Id, Account>(
            [SELECT Id FROM Account WHERE Name = 'KS']
        );
        Test.setFixedSearchResults(new List<Id>(fakeResults.keySet()));
        Test.startTest();
        List<List<SObject>> results = RECIPES_UNDER_TEST.basicSOSLSearch();
        Test.stopTest();

        System.assertEquals(
            1,
            results[0].size(),
            'Expected to get one account with KS'
        );
    }

    @IsTest
    static void inNameFieldsTest() {
        Map<Id, Contact> fakeResults = new Map<Id, Contact>(
            [SELECT Id FROM Contact WHERE LastName = 'Alaska']
        );
        List<Id> ids = new List<Id>(fakeResults.keySet());
        System.assertEquals(1, ids.size(), 'Expected to find a single contact');
        Test.setFixedSearchResults(ids);

        Test.startTest();
        List<List<SObject>> results = RECIPES_UNDER_TEST.nameFieldSearch();
        Test.stopTest();
        System.assertEquals(
            1,
            results[1].size(),
            'Expected to get one contact with Alaska'
        );
    }
}
