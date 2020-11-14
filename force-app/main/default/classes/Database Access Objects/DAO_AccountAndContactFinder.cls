public with sharing virtual class DAO_AccountAndContactFinder {
    protected DAO_AccountAndContactFinder() {
    }

    private static DAO_AccountAndContactFinder instance;
    public static DAO_AccountAndContactFinder getInstance() {
        if (instance == null) {
            instance = new DAO_AccountAndContactFinder();
        }
        return instance;
    }

    public List<List<SObject>> findAnywhere(String keyword) {
        List<List<SObject>> searchResults = [
                FIND :keyword
                IN ALL FIELDS
                        RETURNING account(name), contact(lastname, account.Name)
        ];

        return searchResults;
    }

    public List<List<SObject>> findInName(String keyword) {
        List<List<SObject>> searchResults = [
                FIND :keyword
                IN NAME FIELDS
                        RETURNING account(name), contact(lastname, account.Name)
        ];
        return searchResults;
    }

}