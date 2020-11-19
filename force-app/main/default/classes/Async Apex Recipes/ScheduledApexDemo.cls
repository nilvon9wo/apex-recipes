//@group Async Apex Recipes
//@see ScheduledApexDemo, BatchApexRecipes
public inherited sharing class ScheduledApexDemo {
    @TestVisible
    private Integer counter = 0;

    public void runAtMidnight() {
        System.debug(
            LoggingLevel.INFO,
            'this method doesn\'t do anything. It\'s just here to illustrate ' +
            'how to separate the logic from the schedule'
        );
        this.counter++;
    }
}
