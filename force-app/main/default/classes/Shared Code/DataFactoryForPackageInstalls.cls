public inherited sharing class DataFactoryForPackageInstalls {
    private CanTheUser canUser;

    private DataFactoryForPackageInstalls(CanTheUser canUser) {
        this.canUser = canUser;
    }

    public DataFactoryForPackageInstalls() {
        this(CanTheUser.getInstance());
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public static void generateData() {
        new DataFactoryForPackageInstalls()
                .createData();
    }

    public void createData() {
        List<Junction_Demo_1__c> junction1 = new List<Junction_Demo_1__c>();
        List<Junction_Demo_2__c> junction2 = new List<Junction_Demo_2__c>();
        List<Junction__c> juctionObjs = new List<Junction__c>();

        for (Integer i = 0; i < 50; i++) {
            junction1.add(new Junction_Demo_1__c());
            junction2.add(new Junction_Demo_2__c());
        }
        SObject[] toInsert = new List<SObject>{};
        toInsert.addAll(junction1);
        toInsert.addAll(junction2);
        if (
                this.canUser.create(junction1[0]) && this.canUser.create(junction2[0])
        ) {
            insert toInsert;
        }

        for (Integer i = 0; i < 50; i++) {
            juctionObjs.add(
                new Junction__c(
                    parent1__c = junction1.get(i).Id,
                    Parent2__c = junction2.get(i).Id
                )
            );
        }
        if (this.canUser.create(juctionObjs[0])) {
            insert juctionObjs;
        }
    }
}
