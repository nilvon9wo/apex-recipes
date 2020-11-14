public with sharing virtual class DAO_OpportunitySelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_OpportunitySelector() {
    }

    private static DAO_OpportunitySelector instance;
    public static DAO_OpportunitySelector getInstance() {
        if (instance == null) {
            instance = new DAO_OpportunitySelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return Opportunity.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
        };
    }

    public Double sumAmountForAccount(Id accountId) {
        List<AggregateResult> groupedResults = [
                SELECT SUM(Amount) total
                FROM Opportunity
                WHERE AccountId = :accountId
                WITH SECURITY_ENFORCED
        ];
        return (Double) groupedResults[0].get('total');
    }
}