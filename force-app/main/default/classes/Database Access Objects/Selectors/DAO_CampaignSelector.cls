public with sharing virtual class DAO_CampaignSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_CampaignSelector() {
    }

    private static DAO_CampaignSelector instance;
    public static DAO_CampaignSelector getInstance() {
        if (instance == null) {
            instance = new DAO_CampaignSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return Campaign.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Campaign.ActualCost,
                Campaign.BudgetedCost,
                Campaign.Name
        };
    }

    public virtual List<Campaign> selectAllDisregardingCrud() {
        return this.createQueryFactory()
                .query();
    }
}