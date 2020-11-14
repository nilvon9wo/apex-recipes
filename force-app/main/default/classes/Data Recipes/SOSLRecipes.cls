public inherited sharing class SOSLRecipes {
    private DAO_AccountAndContactFinder accountAndContactFinder;

    private SOSLRecipes(DAO_AccountAndContactFinder accountAndContactFinder) {
        this.accountAndContactFinder = accountAndContactFinder;
    }

    public SOSLRecipes() {
        this(DAO_AccountAndContactFinder.getInstance());
    }

    public List<List<SObject>> basicSOSLSearch() {
        return this.accountAndContactFinder.findAnywhere('Kan*');
    }

    public List<List<SObject>> nameFieldSearch() {
        return this.accountAndContactFinder.findInName('Alaska');
    }
}
