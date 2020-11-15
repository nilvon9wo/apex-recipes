public inherited sharing class PlatformCacheBuilderRecipes implements Cache.CacheBuilder {
    private DAO_AccountSelector accountSelector;

    private PlatformCacheBuilderRecipes(DAO_AccountSelector accountSelector) {
        this.accountSelector = accountSelector;
    }

    public PlatformCacheBuilderRecipes() {
        this(DAO_AccountSelector.getInstance());
    }

    public Object doLoad(String key) {
        return this.accountSelector.secureSelectAll();
    }
}
