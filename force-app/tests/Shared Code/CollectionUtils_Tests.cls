@IsTest
private class CollectionUtils_Tests {
    @IsTest
    static void testDemonstrateIdMapFromCollectionByKeyPositiveWithList() {
        List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
            new Account(),
            5,
            true
        );
        List<Contact> contacts = (List<Contact>) TestFactory.createSObjectList(
            new Contact(),
            5,
            true
        );

        Test.startTest();
        Map<Id, Account> checkAccountMap = (Map<Id, Account>) CollectionUtils.mapLastQualifiedSObjectBySpecifiedIdField(
            accounts, Account.Id
        );
        Map<Id, Contact> checkContactMap = (Map<Id, Contact>) CollectionUtils.mapLastQualifiedSObjectBySpecifiedIdField(
            contacts, Contact.Id

        );
        Test.stopTest();

        System.assertEquals(
            checkAccountMap.keySet().size(),
            5,
            'Expected to get 5 accounts back'
        );
        System.assertEquals(
            checkContactMap.keySet().size(),
            5,
            'Expected to get 5 contacts back'
        );

        for (Id accountId : checkAccountMap.keySet()) {
            System.assertEquals(
                checkAccountMap.get(accountId).getSObjectType(),
                Account.getSObjectType(),
                'We expected the map to have accounts'
            );
        }

        for (Id contactId : checkContactMap.keySet()) {
            System.assertEquals(
                checkContactMap.get(contactId).getSObjectType(),
                Contact.getSObjectType(),
                'We expected the map to have Contact'
            );
        }
    }

    @IsTest
    static void testDemonstrateStringMapFromCollectionByKeyPositiveWithList() {
        List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
            new Account(),
            5,
            true
        );
        for (Account acct : accounts) {
            acct.Name = acct.Id;
        }
        update accounts;
        Test.startTest();
        Map<String, Account> checkAccountMap = (Map<String, Account>) CollectionUtils.mapLastQualifiedSObjectBySpecifiedStringField(
                accounts, Account.Name
        );

        Test.stopTest();

        System.assertEquals(
            checkAccountMap.keySet().size(),
            5,
            'Expected to get 5 accounts back'
        );

        for (Id accountId : checkAccountMap.keySet()) {
            System.assertEquals(
                checkAccountMap.get(accountId).getSObjectType(),
                Account.getSObjectType(),
                'We expected the map to have accounts'
            );
        }
    }

    @IsTest
    static void testMapFromCollectionWithListOfValuesPostive() {
        List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
            new Account(),
            5,
            true
        );

        List<Contact> contactList = new List<Contact>();
        for (Account acct : accounts) {
            contactList.addAll(
                (List<Contact>) TestFactory.createSObjectList(
                    new Contact(AccountId = acct.Id),
                    5,
                    false
                )
            );
        }
        insert contactList;

        Test.startTest();
        Map<Id, List<Contact>> checkResults = (Map<Id, List<Contact>>) CollectionUtils.mapBySpecifiedIdField(
            contactList, Contact.AccountId
        );
        Test.stopTest();

        System.assertEquals(
            5,
            checkResults.keySet().size(),
            'Expected to find 5 accountIds'
        );

        for (Id accountId : checkResults.keySet()) {
            System.assertEquals(
                accountId.getSobjectType(),
                Account.getSObjectType(),
                'Expected keys to be accounts'
            );
            System.assertEquals(
                5,
                checkResults.get(accountId).size(),
                'Expected to find 5 entries in the list '
            );
            for (Contact contact : checkResults.get(accountId)) {
                System.assertEquals(
                    contact.getSObjectType(),
                    contact.getSObjectType(),
                    'Expected to find contacts'
                );
            }
        }
    }
}
