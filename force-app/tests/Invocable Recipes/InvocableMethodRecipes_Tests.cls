@IsTest
public class InvocableMethodRecipes_Tests {
    @IsTest
    static void contactSearchRequestConstructorPositive() {
        Test.startTest();
        ContactSearchRequest request = new ContactSearchRequest();
        request.inputs = new List<Account>{ new Account(Name = 'test') };
        Test.stopTest();

        System.assertEquals(
            request.inputs.size(),
            1,
            'Expected to find one account'
        );
    }

    @IsTest
    static void endToEndInvocableMethodTestAccountPositive() {
        Account account = (Account) TestFactory.createSObject(
            new Account(Name = 'Test'),
            true
        );
        Contact contact = (Contact) TestFactory.createSObject(
            new Contact(LastName = 'Nomical', AccountId = account.Id),
            true
        );
        List<ContactSearchRequest> requests = new List<ContactSearchRequest>();
        ContactSearchRequest request = new ContactSearchRequest();
        request.inputs = new List<SObject>{ account };
        requests.add(request);

        Test.startTest();
        List<ContactSearchResult> results = InvocableMethodRecipes.findRelatedContacts(
            requests
        );
        Test.stopTest();

        System.assert(results.size() == 1, 'Expected to receive one contact');
        System.assert(
            results[0].output.Id == contact.Id,
            'Expected the returned contact to be the one we created'
        );
    }

    @IsTest
    static void endToEndInvocableMethodTestTaskPositive() {
        Account account = (Account) TestFactory.createSObject(
            new Account(Name = 'Test'),
            true
        );
        Contact contact = (Contact) TestFactory.createSObject(
            new Contact(LastName = 'Nomical', AccountId = account.Id),
            true
        );
        Task task = (Task) TestFactory.createSObject(
            new Task(WhoId = contact.Id, Subject = 'test'),
            true
        );
        List<ContactSearchRequest> requests = new List<ContactSearchRequest>();
        ContactSearchRequest request = new ContactSearchRequest();
        request.inputs = new List<SObject>{ task };
        requests.add(request);

        Test.startTest();
        List<ContactSearchResult> results = InvocableMethodRecipes.findRelatedContacts(
            requests
        );
        Test.stopTest();

        System.assert(results.size() == 1, 'Expected to receive one contact');
        System.assert(
            results[0].output.Id == contact.Id,
            'Expected the returned contact to be the one we created'
        );
    }
}
