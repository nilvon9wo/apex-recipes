public with sharing virtual class DAO_AccountSelector {
    protected DAO_AccountSelector() {
    }

    private static DAO_AccountSelector instance;
    public static DAO_AccountSelector getInstance() {
        if (instance == null) {
            instance = new DAO_AccountSelector();
        }
        return instance;
    }

    public virtual Database.QueryLocator getQueryLocatorForAll() {
        return Database.getQueryLocator([SELECT Id, Name FROM Account]);
    }


}