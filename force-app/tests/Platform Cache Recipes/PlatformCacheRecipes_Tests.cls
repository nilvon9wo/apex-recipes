@IsTest
private class PlatformCacheRecipes_Tests {
    private static final PlatformCacheRecipes RECIPES_UNDER_TEST = new PlatformCacheRecipes();
    
    @IsTest
    static void testStoreValueInSessionCachePositive() {
        Test.startTest();
        RECIPES_UNDER_TEST.storeValueInSessionCache(
            'Account',
            'This is a test'
        );
        Test.stopTest();

        System.assert(
            RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.SESSION
                )
                .getKeys()
                .contains('Account'),
            'Expected to see Account as a key'
        );
        System.assertEquals(
            'This is a test',
            RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.SESSION
                )
                .get('Account'),
            'expected Account key to hold \'this is a test\''
        );
    }

    @IsTest
    static void testStoreValueInSessionCacheWithTTLPositive() {
        Test.startTest();
        RECIPES_UNDER_TEST.storeValueInSessionCache(
            'Account',
            'This is a test',
            4800
        );
        Test.stopTest();

        System.assert(
            RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.SESSION
                )
                .getKeys()
                .contains('Account'),
            'Expected to see Account as a key'
        );
        System.assertEquals(
            'This is a test',
            RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.SESSION
                )
                .get('Account'),
            'expected Account key to hold \'this is a test\''
        );
    }

    @IsTest
    static void testGetValueFromSessionCachePositive() {
        RECIPES_UNDER_TEST.storeValueInSessionCache(
            'Account',
            'This is a test'
        );
        Test.startTest();
        String results = RECIPES_UNDER_TEST.getValueFromSessionCache(
            'Account'
        );
        Test.stopTest();
        System.assertEquals(
            'This is a test',
            results,
            'Expect retrieval of cache item to result in the cached string being returned'
        );
    }

    @IsTest
    static void testGetValueFromSessionCacheNegativeNoValueForKey() {
        Test.startTest();
        String results = RECIPES_UNDER_TEST.getValueFromSessionCache(
            'Account'
        );
        Test.stopTest();
        System.assertEquals(
            'Cache Miss',
            results,
            'Expect retrieval of non-existant cache key to result in a \'Cache Miss\' result '
        );
    }

    @IsTest
    static void testRemoveKeyFromSessionCachePositive() {
        RECIPES_UNDER_TEST.storeValueInSessionCache(
            'Account',
            'This is a test'
        );
        Test.startTest();
        RECIPES_UNDER_TEST.removeKeyFromSessionCache('Account');
        Test.stopTest();
        System.assert(
            !RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.SESSION
                )
                .getKeys()
                .contains('Account'),
            'Expected the session cache keyset to not include Account'
        );
    }

    @IsTest
    static void testRemoveKeyFromSessionCacheNegativeNoKey() {
        Boolean didCatchProperException = false;
        Test.startTest();
        try {
            RECIPES_UNDER_TEST.removeKeyFromSessionCache('fakekey');
        } catch ( CacheException ce) {
            if (ce.getMessage().containsIgnoreCase('key not found')) {
                didCatchProperException = true;
            }
        }
        Test.stopTest();
        System.assert(
            didCatchProperException,
            'Expected to have caught a cacheException'
        );
    }

    // ORG partition
    @IsTest
    static void testStoreValueInOrgCachePositive() {
        Test.startTest();
        RECIPES_UNDER_TEST.storeValueInOrgCache('Account', 'This is a test');
        Test.stopTest();

        System.assert(
            RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.ORG
                )
                .getKeys()
                .contains('Account'),
            'Expected to see Account as a key'
        );
        System.assertEquals(
            'This is a test',
            RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.ORG
                )
                .get('Account'),
            'expected Account key to hold \'this is a test\''
        );
    }

    @IsTest
    static void testStoreValueInOrgCacheWithTTLPositive() {
        Test.startTest();
        RECIPES_UNDER_TEST.storeValueInOrgCache(
            'Account',
            'This is a test',
            4800
        );
        Test.stopTest();

        System.assert(
            RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.ORG
                )
                .getKeys()
                .contains('Account'),
            'Expected to see Account as a key'
        );
        System.assertEquals(
            'This is a test',
            RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.ORG
                )
                .get('Account'),
            'expected Account key to hold \'this is a test\''
        );
    }

    @IsTest
    static void testGetValueFromOrgCachePositive() {
        RECIPES_UNDER_TEST.storeValueInOrgCache('Contact', 'This is a test');
        Test.startTest();
        String results = RECIPES_UNDER_TEST.getValuefromOrgCache('Contact');
        Test.stopTest();
        System.assertEquals(
            'This is a test',
            results,
            'Expect retrieval of cache item to result in the cached string being returned'
        );
    }

    @IsTest
    static void testGetValueFromOrgCacheNegativeNoValueForKey() {
        Test.startTest();
        String results = RECIPES_UNDER_TEST.getValuefromOrgCache('Account');
        Test.stopTest();
        System.assertEquals(
            'Cache Miss',
            results,
            'Expect retrieval of non-existant cache key to result in a \'Cache Miss\' result '
        );
    }

    @IsTest
    static void testRemoveKeyFromOrgCachePositive() {
        RECIPES_UNDER_TEST.storeValueInOrgCache('Account', 'This is a test');
        Test.startTest();
        RECIPES_UNDER_TEST.removeKeyFromOrgCache('Account');
        Test.stopTest();
        System.assert(
            !RECIPES_UNDER_TEST.getDefaultPartition(
                    PartitionType.ORG
                )
                .getKeys()
                .contains('Account'),
            'Expected the Org cache keyset to not include Account'
        );
    }

    @IsTest
    static void testRemoveKeyFromOrgCacheNegativeNoKey() {
        Boolean didCatchProperException = false;
        Test.startTest();
        try {
            RECIPES_UNDER_TEST.removeKeyFromOrgCache('fakekey');
        } catch ( CacheException ce) {
            if (ce.getMessage().containsIgnoreCase('key not found')) {
                didCatchProperException = true;
            }
        }
        Test.stopTest();
        System.assert(
            didCatchProperException,
            'Expected to have caught a cacheException'
        );
    }
}
