public inherited sharing class StripInaccessibleRecipes {
    private DAO_AccountSelector accountSelector;
    private DAO_CampaignSelector campaignSelector;
    private XAP_DAO_DML_SecureDml dml;

    private StripInaccessibleRecipes(
            DAO_AccountSelector accountSelector,
            DAO_CampaignSelector campaignSelector,
            XAP_DAO_DML_SecureDml dml
    ) {
        this.accountSelector = accountSelector;
        this.campaignSelector = campaignSelector;
        this.dml = dml;
    }

    public StripInaccessibleRecipes() {
        this(DAO_AccountSelector.getInstance(), DAO_CampaignSelector.getInstance(), XAP_DAO_DML_SecureDml.getInstance());
    }

    public List<Campaign> stripInaccessibleFromQuery() {
        List<Campaign> campaignList = ((DAO_CampaignSelector) this.campaignSelector.turnCrudEnforcementOff())
                .selectAll();
        SObjectAccessDecision securityDecision
                = Security.stripInaccessible(AccessType.READABLE, campaignList);
        return (List<Campaign>) securityDecision.getRecords();
    }

    public List<Account> stripInaccessibleFromSubquery() {
        List<Account> accountList = this.accountSelector.secureSelectAllWithContactsWithoutCrudEnforcement();
        SObjectAccessDecision securityDecision
                = Security.stripInaccessible(AccessType.READABLE, accountList);
        return (List<Account>) securityDecision.getRecords();
    }

    public void stripInaccessibleBeforeDML(List<Contact> contacts) {
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, contacts);
        this.dml.doInsert(securityDecision.getRecords());
    }

    public void stripInaccessibleFromUntrustedData(String jsonText) {
        List<Account> accounts = (List<Account>) JSON.deserialize(jsonText, List<Account>.class);
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPDATABLE, accounts);
        this.dml.doUpdate(securityDecision.getRecords());
    }
}
