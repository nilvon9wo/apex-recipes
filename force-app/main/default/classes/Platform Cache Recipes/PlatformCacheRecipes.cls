public inherited sharing class PlatformCacheRecipes {
    private static final String DEFAULT_PARTITION = 'local.default';

    public static void storeValueInSessionCache(String key, String toStore) {
        PlatformCacheRecipes.storeValueInSessionCache(key, toStore, 3600);
    }

    public static void storeValueInSessionCache(String key, String toStore, Integer ttl) {
        getDefaultPartition(PartitionType.SESSION).put(key, toStore, ttl);
    }

    public static String getValueFromSessionCache(String key) {
        Cache.Partition defaultPartition = getDefaultPartition(PartitionType.SESSION);
        return (defaultPartition.contains(key))
                ? (String) defaultPartition.get(key)
                : 'Cache Miss';
    }

    public static void removeKeyFromSessionCache(String key) {
        Cache.Partition defPartition = getDefaultPartition(
                PartitionType.SESSION
        );
        if (defPartition.contains(key)) {
            defPartition.remove(key);
        }
        else {
            throw new CacheException('key not found');
        }
    }

    public static void storeValueInOrgCache(String key, String toStore) {
        storeValueInOrgCache(key, toStore, 3600);
    }

    public static void storeValueInOrgCache(
            String key,
            String toStore,
            Integer ttl
    ) {
        getDefaultPartition(PartitionType.ORG).put(key, toStore, ttl);
    }

    public static String getValuefromOrgCache(String key) {
        Cache.Partition defPartition = getDefaultPartition(PartitionType.ORG);
        if (defPartition.contains(key)) {
            return (String) defPartition.get(key);
        }
        return 'Cache Miss';
    }

    public static void removeKeyFromOrgCache(String key) {
        Cache.Partition defPartition = getDefaultPartition(PartitionType.ORG);
        if (defPartition.contains(key)) {
            defPartition.remove(key);
        }
        else {
            throw new CacheException('key not found');
        }
    }

    public static Cache.Partition getDefaultPartition(PartitionType type) {
        switch on type {
            when SESSION {
                return (Cache.Partition) Cache.Session.getPartition(
                        DEFAULT_PARTITION
                );
            }
        }
        return (Cache.Partition) Cache.Org.getPartition(DEFAULT_PARTITION);
    }
}
