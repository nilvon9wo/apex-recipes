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

    public virtual List<Account> selectAll() {
        return [
                SELECT Id, Description, Name
                FROM Account
        ];
    }

    public virtual List<Account> selectSome(Integer quantity) {
        return [
                SELECT Id, Description, Name
                FROM Account
                LIMIT :quantity
        ];
    }

    public virtual Database.QueryLocator getQueryLocatorForAll() {
        return Database.getQueryLocator([
                SELECT Id, Description, Name
                FROM Account
        ]);
    }


}