public with sharing virtual class DAO_JunctionDemo1Selector  extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_JunctionDemo1Selector() {
    }

    private static DAO_JunctionDemo1Selector instance;
    public static DAO_JunctionDemo1Selector getInstance() {
        if (instance == null) {
            instance = new DAO_JunctionDemo1Selector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return Junction_Demo_1__c.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Junction_Demo_1__c.Name
        };
    }

}