@IsTest
public with sharing class ARSC_RestRequest_Tests {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

    @IsTest
    static void testConstructorPositive() {
        // Arrange : Nothing to do here

        // Act
        ARSC_RestRequest restRequestUnderTest;
        Test.startTest();
        System.runAs(TEST_USER) {
            restRequestUnderTest = new ARSC_RestRequest().setNamedCredential('dummyNamedCredential');
        }
        Test.stopTest();

        // Assert
        System.assertEquals(
                'dummyNamedCredential',
                restRequestUnderTest.namedCredential,
                'Expected the name credential to match'
        );
    }
}