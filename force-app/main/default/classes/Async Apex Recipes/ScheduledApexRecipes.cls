//@group Async Apex Recipes
//@see ScheduledApexRecipes
public inherited sharing class ScheduledApexRecipes implements Schedulable {
    private ScheduledApexDemo demo;

    private ScheduledApexRecipes(ScheduledApexDemo demo) {
        this.demo = demo;
    }

    public ScheduledApexRecipes() {
        this(new ScheduledApexDemo());
    }

    @TestVisible // Sets to run at midnight 5/28/2099
    private final static String TEST_CRON_STATEMENT = '0 0 0 28 5 ? 2099';

    public void execute(SchedulableContext context) {
        this.demo.runAtMidnight();
    }
}
