public with sharing virtual class DAO_JunctionDemo2Selector  extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_JunctionDemo2Selector() {
    }

    private static DAO_JunctionDemo2Selector instance;
    public static DAO_JunctionDemo2Selector getInstance() {
        if (instance == null) {
            instance = new DAO_JunctionDemo2Selector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return Junction_Demo_2__c.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Junction_Demo_2__c.Name
        };
    }

}