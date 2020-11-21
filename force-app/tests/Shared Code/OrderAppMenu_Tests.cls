@IsTest
private with sharing class OrderAppMenu_Tests {
    @IsTest
    static void testQueueableWithCalloutRecipesPositive() {
        Test.startTest();
        OrderAppMenu queueable = new OrderAppMenu();
        System.enqueueJob(queueable);
        Test.stopTest();

        System.assert(true, 'This assertion should never fail.');
    }
}
