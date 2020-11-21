@IsTest
private class DataFactoryForPackageInstalls_Tests {
    @IsTest
    static void testGenerateDataPositive() {
        Test.startTest();
        DataFactoryForPackageInstalls.generateData();
        Test.stopTest();

        Junction__c[] junctionObjs = [SELECT Id FROM Junction__c];
        System.assertEquals(
            50,
            junctionObjs.size(),
            'Expected to find 50 junction objects'
        );
    }
}
