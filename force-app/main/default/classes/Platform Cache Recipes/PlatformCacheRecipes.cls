public inherited sharing class PlatformCacheRecipes {
    private static final String DEFAULT_PARTITION = 'local.default';

    public void storeValueInSessionCache(String key, String toStore) {
        this.storeValueInSessionCache(key, toStore, 3600);
    }

    public void storeValueInSessionCache(String key, String toStore, Integer timeToLive) {
        this.getDefaultPartition(PartitionType.SESSION)
                .put(key, toStore, timeToLive);
    }

    public String getValueFromSessionCache(String key) {
        Cache.Partition defaultPartition = this.getDefaultPartition(PartitionType.SESSION);
        return (defaultPartition.contains(key))
                ? (String) defaultPartition.get(key)
                : 'Cache Miss';
    }

    public void removeKeyFromSessionCache(String key) {
        Cache.Partition defPartition = this.getDefaultPartition(PartitionType.SESSION);
        if (defPartition.contains(key)) {
            defPartition.remove(key);
        }
        else {
            throw new CacheException('key not found');
        }
    }

    public void storeValueInOrgCache(String key, String toStore) {
        this.storeValueInOrgCache(key, toStore, 3600);
    }

    public void storeValueInOrgCache(String key, String toStore, Integer timeToLive) {
        getDefaultPartition(PartitionType.ORG)
                .put(key, toStore, timeToLive);
    }

    public String getValuefromOrgCache(String key) {
        Cache.Partition defPartition = this.getDefaultPartition(PartitionType.ORG);
        return (defPartition.contains(key))
                ? (String) defPartition.get(key)
                : 'Cache Miss';
    }

    public void removeKeyFromOrgCache(String key) {
        Cache.Partition defPartition = this.getDefaultPartition(PartitionType.ORG);
        if (defPartition.contains(key)) {
            defPartition.remove(key);
        }
        else {
            throw new CacheException('key not found');
        }
    }

    public Cache.Partition getDefaultPartition(PartitionType type) {
        return (type == PartitionType.SESSION)
                ? (Cache.Partition) Cache.Session.getPartition(DEFAULT_PARTITION)
                : (Cache.Partition) Cache.Org.getPartition(DEFAULT_PARTITION);
    }
}
