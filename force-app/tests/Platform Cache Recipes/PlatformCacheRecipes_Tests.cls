@IsTest
private class PlatformCacheRecipes_Tests {
    @IsTest
    static void testStoreValueInSessionCachePositive() {
        Test.startTest();
        PlatformCacheRecipes.storeValueInSessionCache(
            'Account',
            'This is a test'
        );
        Test.stopTest();

        System.assert(
            PlatformCacheRecipes.getDefaultPartition(
                    PartitionType.SESSION
                )
                .getKeys()
                .contains('Account'),
            'Expected to see Account as a key'
        );
        System.assertEquals(
            'This is a test',
            PlatformCacheRecipes.getDefaultPartition(
                    PartitionType.SESSION
                )
                .get('Account'),
            'expected Account key to hold \'this is a test\''
        );
    }

    @IsTest
    static void testStoreValueInSessionCacheWithTTLPositive() {
        Test.startTest();
        PlatformCacheRecipes.storeValueInSessionCache(
            'Account',
            'This is a test',
            4800
        );
        Test.stopTest();

        System.assert(
            PlatformCacheRecipes.getDefaultPartition(
                    PartitionType.SESSION
                )
                .getKeys()
                .contains('Account'),
            'Expected to see Account as a key'
        );
        System.assertEquals(
            'This is a test',
            PlatformCacheRecipes.getDefaultPartition(
                    PartitionType.SESSION
                )
                .get('Account'),
            'expected Account key to hold \'this is a test\''
        );
    }

    @IsTest
    static void testGetValueFromSessionCachePositive() {
        PlatformCacheRecipes.storeValueInSessionCache(
            'Account',
            'This is a test'
        );
        Test.startTest();
        String results = PlatformCacheRecipes.getValueFromSessionCache(
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
        String results = PlatformCacheRecipes.getValueFromSessionCache(
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
        PlatformCacheRecipes.storeValueInSessionCache(
            'Account',
            'This is a test'
        );
        Test.startTest();
        PlatformCacheRecipes.removeKeyFromSessionCache('Account');
        Test.stopTest();
        System.assert(
            !PlatformCacheRecipes.getDefaultPartition(
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
            PlatformCacheRecipes.removeKeyFromSessionCache('fakekey');
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
        PlatformCacheRecipes.storeValueInOrgCache('Account', 'This is a test');
        Test.stopTest();

        System.assert(
            PlatformCacheRecipes.getDefaultPartition(
                    PartitionType.ORG
                )
                .getKeys()
                .contains('Account'),
            'Expected to see Account as a key'
        );
        System.assertEquals(
            'This is a test',
            PlatformCacheRecipes.getDefaultPartition(
                    PartitionType.ORG
                )
                .get('Account'),
            'expected Account key to hold \'this is a test\''
        );
    }

    @IsTest
    static void testStoreValueInOrgCacheWithTTLPositive() {
        Test.startTest();
        PlatformCacheRecipes.storeValueInOrgCache(
            'Account',
            'This is a test',
            4800
        );
        Test.stopTest();

        System.assert(
            PlatformCacheRecipes.getDefaultPartition(
                    PartitionType.ORG
                )
                .getKeys()
                .contains('Account'),
            'Expected to see Account as a key'
        );
        System.assertEquals(
            'This is a test',
            PlatformCacheRecipes.getDefaultPartition(
                    PartitionType.ORG
                )
                .get('Account'),
            'expected Account key to hold \'this is a test\''
        );
    }

    @IsTest
    static void testGetValueFromOrgCachePositive() {
        PlatformCacheRecipes.storeValueInOrgCache('Contact', 'This is a test');
        Test.startTest();
        String results = PlatformCacheRecipes.getValuefromOrgCache('Contact');
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
        String results = PlatformCacheRecipes.getValuefromOrgCache('Account');
        Test.stopTest();
        System.assertEquals(
            'Cache Miss',
            results,
            'Expect retrieval of non-existant cache key to result in a \'Cache Miss\' result '
        );
    }

    @IsTest
    static void testRemoveKeyFromOrgCachePositive() {
        PlatformCacheRecipes.storeValueInOrgCache('Account', 'This is a test');
        Test.startTest();
        PlatformCacheRecipes.removeKeyFromOrgCache('Account');
        Test.stopTest();
        System.assert(
            !PlatformCacheRecipes.getDefaultPartition(
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
            PlatformCacheRecipes.removeKeyFromOrgCache('fakekey');
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
