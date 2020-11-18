@IsTest
private inherited sharing class PlatformEventRecipesTriggerHandler_Tests {
    static {
        TEST_DummyXapTriggerSettingFactoryOutlet.prepareIntegrationTest();
    }

    @IsTest
    static void testPlatformEventRecipesTriggerHandlerPositive() {
        Account acct = (Account) TestFactory.createSObject(
            new Account(Name = 'testEvent'),
            true
        );
        Event_Recipes_Demo__e event = new Event_Recipes_Demo__e(
            url__c = 'https://google.com',
            title__c = 'demo.jpg',
            accountId__c = acct.Id
        );

        Test.startTest();
        EventBus.publish(event);
        Test.stopTest();

        Account checkAccount = [
            SELECT Website
            FROM Account
            WHERE Id = :acct.Id
            LIMIT 1
        ];
        System.assertEquals(
            'https://google.com',
            checkAccount.Website,
            'Expected the website to be set to google.com'
        );
    }
}
