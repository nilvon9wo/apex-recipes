@IsTest
private inherited sharing class CanTheUser_Tests {
    private static final CanTheUser CAN_UNDER_TEST = new CanTheUser();
    @IsTest
    static void canCrudAccountCreatePositive() {
        System.assert(
                CAN_UNDER_TEST.crud(new Account(), CrudType.CREATE),
                'Unless scratch org defaults have been changed by the user, this test should pass - asserting that users can create accounts'
        );
    }

    @IsTest
    static void canCrudCreateAccountPositive() {
        System.assert(
                CAN_UNDER_TEST.create(new Account()),
                'Unless scratch org defaults have been changed by the user, this test should pass - asserting that users can create accounts'
        );
    }

    @IsTest
    static void canCrudAccountReadPositive() {
        System.assert(
                CAN_UNDER_TEST.crud(new Account(), CrudType.READ),
                'Expected to be able to read accounts'
        );
    }

    @IsTest
    static void canCrudReadAccountPositive() {
        System.assert(
                CAN_UNDER_TEST.read(new Account()),
                'Expected to be able to read accounts'
        );
    }

    @IsTest
    static void canCrudAccountUpdatePositive() {
        System.assert(
                CAN_UNDER_TEST.crud(new Account(), CrudType.EDIT),
                'Expected to be able to update accounts'
        );
    }

    @IsTest
    static void canCrudEditAccountPositive() {
        System.assert(
                CAN_UNDER_TEST.edit(new Account()),
                'Expected to be able to update accounts'
        );
    }

    @IsTest
    static void canCrudAccountDeletePositive() {
        System.assert(
                CAN_UNDER_TEST.crud(new Account(), CrudType.DEL),
                'Expected to be able to delete accounts'
        );
    }

    @IsTest
    static void canCrudDestroyAccountPositive() {
        System.assert(
                CAN_UNDER_TEST.destroy(new Account()),
                'Expected to be able to delete accounts'
        );
    }

    @IsTest
    static void getFLSofAccountNamePositive() {
        System.assert(
                CAN_UNDER_TEST.flsAccessible('Account', 'Name'),
                'Expected the name field to be accesible on Account'
        );
    }

    @IsTest
    static void getFLSofAccountIDNegative() {
        System.assert(
                CAN_UNDER_TEST.flsUpdatable('Account', 'id') == false,
                'Expected that the ID of an object cannot be updated.'
        );
    }

    @IsTest
    static void getBulkFLSAccessibleWithAccountPositive() {
        Set<String> fields = new Set<String>{'name', 'id'};
        Map<String, Boolean> bulkCheck = CAN_UNDER_TEST.bulkFLSAccessible(
                'Account',
                fields
        );
        for (String field : bulkCheck.keySet()) {
            System.assert(
                    bulkCheck.get(field),
                    'Expected the field to be accesible on Account'
            );
        }
    }

    @IsTest
    static void getBulkFLSAccessibleWithAccountPositiveWithNegativeResults() {
        Set<String> fields = new Set<String>{'name', 'nonExistingField__c'};
        Map<String, Boolean> bulkCheck = CAN_UNDER_TEST.bulkFLSAccessible(
                'Account',
                fields
        );

        System.assert(
                bulkCheck.get('name'),
                'Expected the name ' + 'field to be accesible on Account'
        );

        System.assert(
                !bulkCheck.get('nonExistingField__c'),
                'Expected the name ' + 'field to be accesible on Account'
        );
    }

    @IsTest
    static void getBulkFLSUpdatableWithAccountPositive() {
        Set<String> fields = new Set<String>{'name', 'ShippingStreet'};
        Map<String, Boolean> bulkCheck = CAN_UNDER_TEST.bulkFLSUpdatable(
                'Account',
                fields
        );
        for (String field : bulkCheck.keySet()) {
            System.assert(
                    bulkCheck.get(field),
                    'Expected the field to be accesible on Account'
            );
        }
    }

    @IsTest
    static void getBulkFLSUpdatableWithAccountPositiveWithNegativeResults() {
        Set<String> fields = new Set<String>{'name', 'nonExistingField__c'};
        Map<String, Boolean> bulkCheck = CAN_UNDER_TEST.bulkFLSUpdatable(
                'Account',
                fields
        );

        System.assert(
                bulkCheck.get('name'),
                'Expected the name ' + 'field to be accesible on Account'
        );

        System.assert(
                !bulkCheck.get('nonExistingField__c'),
                'Expected the name ' + 'field to be accesible on Account'
        );
    }

    @IsTest
    static void memoizedFLSMDCcomparesAccesibleToUpdatable() {
        Test.startTest();
        CAN_UNDER_TEST.memoizeFLSMDC('Account', FLSType.UPDATABLE);
        Test.stopTest();

        System.assertNotEquals(
                CanTheUser.accessibleFieldsByObject.get('Account'),
                CanTheUser.updatableFieldsByObject.get('Account'),
                'Expected that the two sets would be different'
        );
    }
}
