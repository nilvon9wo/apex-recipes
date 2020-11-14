@IsTest
private inherited sharing class ScheduledApexRecipes_Tests {
    @IsTest
    static void scheduledExecutionTimeIsCorrectPositive() {
        Test.startTest();
        String scheduledJobId = System.schedule(
            'ScheduledApexRecipes-Test',
            ScheduledApexRecipes.TEST_CRON_STATEMENT,
            new ScheduledApexRecipes()
        );
        Test.stopTest();

        CronTrigger checkCronTrigger = [
            SELECT CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE Id = :scheduledJobId
            LIMIT 1
        ];
        System.assertEquals(
            checkCronTrigger.CronExpression,
            ScheduledApexRecipes.TEST_CRON_STATEMENT,
            'These two cron statements should be equal'
        );

        System.assertEquals(
            checkCronTrigger.TimesTriggered,
            0,
            'Expected this cron trigger to never have been fired'
        );

        System.assertEquals(
            String.valueOf(checkCronTrigger.NextFireTime),
            '2099-05-28 00:00:00',
            'Expected the next fire time to be set to 5/28/2099 at midnight'
        );
    }
}
