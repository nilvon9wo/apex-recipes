@IsTest
private inherited sharing class PlatformEventRecipes_Tests {
    private static final PlatformEventRecipes RECIPES_UNDER_TEST = new PlatformEventRecipes();

    @IsTest
    static void testEventPublishPositive() {
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
        XAP_DAO_DML_SaveResultListWrapper publishResult = RECIPES_UNDER_TEST.publishEvent(
                event
        );
        Test.stopTest();

        System.assert(
                publishResult.getResultWrapperList()[0].isSuccess(),
                'Expected the publish event to succeed'
        );
    }

    @IsTest
    static void testEventPublishNegativeInvalidFields() {
        Event_Recipes_Demo__e event = new Event_Recipes_Demo__e(
                url__c = 'https://google.com',
                title__c = 'demo.jpg'
        );

        Test.startTest();
        XAP_DAO_DML_SaveResultListWrapper publishResult = RECIPES_UNDER_TEST.publishEvent(
                event
        );
        Test.stopTest();

        System.assert(
                !publishResult.getResultWrapperList()[0].isSuccess(),
                'Expected the publish event to fail'
        );
    }

    @IsTest
    static void testEventPublishNegativeMinAccessUser() {
        Event_Recipes_Demo__e event = new Event_Recipes_Demo__e(
                url__c = 'https://google.com',
                title__c = 'demo.jpg'
        );
        Boolean didCatchCorrectException = false;
        User testUser = TestFactory.createMinAccessUser(true);

        Test.startTest();
        System.runAs(testUser) {
            try {
                RECIPES_UNDER_TEST.publishEvent(event);
            }
            catch (PlatformEventRecipesException pere) {
                if (
                        pere.getMessage()
                                .containsIgnoreCase(
                                'User has no permission to publish event'
                        )
                        ) {
                    didCatchCorrectException = true;
                }
            }
        }
        Test.stopTest();

        System.assert(
                didCatchCorrectException,
                'Expected to have received a PlatformEventRecipesException when a min-access user tries to publish an event'
        );
    }
}
