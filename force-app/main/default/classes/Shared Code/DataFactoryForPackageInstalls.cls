public inherited sharing class DataFactoryForPackageInstalls {
    private CanTheUser canUser;
    private XAP_DAO_DML_InheritedSharingDml dml;

    private DataFactoryForPackageInstalls(CanTheUser canUser, XAP_DAO_DML_InheritedSharingDml dml) {
        this.canUser = canUser;
        this.dml = dml;
    }

    public DataFactoryForPackageInstalls() {
        this(CanTheUser.getInstance(), XAP_DAO_DML_InheritedSharingDml.getInstance());
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public static void generateData() {
        new DataFactoryForPackageInstalls()
                .createData();
    }

    public void createData() {
        List<Junction_Demo_1__c> junction1 = this.createSObjects(Junction_Demo_1__c.SObjectType);
        List<Junction_Demo_2__c> junction2 = this.createSObjects(Junction_Demo_2__c.SObjectType);
        this.doInsert(junction1, junction2);

        List<Junction__c> junctionList = this.createJunctionList(junction1, junction2);
        if (this.canUser.create(junctionList[0])) {
            this.dml.doInsert(junctionList);
        }
    }

    private List<SObject> createSObjects(SObjectType sObjectType) {
        List<SObject> sObjectList = new List<SObject>();
        for (Integer i = 0; i < 50; i++) {
            sObjectList.add(sObjectType.newSObject());
        }
        return sObjectList;
    }

    private XAP_DAO_DML_ResultListWrapperIntf doInsert(
            List<Junction_Demo_1__c> junction1,
            List<Junction_Demo_2__c> junction2
    ) {
        List<SObject> insertList = new List<SObject>();
        insertList.addAll(junction1);
        insertList.addAll(junction2);
        if (
                this.canUser.create(junction1[0])
                        && this.canUser.create(junction2[0])
                ) {
            return this.dml.doInsert(insertList);
        }
        return null;
    }

    private List<Junction__c> createJunctionList(
            List<Junction_Demo_1__c> junction1,
            List<Junction_Demo_2__c> junction2
    ) {
        List<Junction__c> junctionList = new List<Junction__c>();
        for (Integer i = 0; i < 50; i++) {
            junctionList.add(
                    new Junction__c(
                            parent1__c = junction1.get(i).Id,
                            Parent2__c = junction2.get(i).Id
                    )
            );
        }
        return junctionList;
    }
}
