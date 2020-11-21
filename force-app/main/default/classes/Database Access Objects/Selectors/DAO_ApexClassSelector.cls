public with sharing virtual class DAO_ApexClassSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_ApexClassSelector() {
    }

    private static DAO_ApexClassSelector instance;
    public static DAO_ApexClassSelector getInstance() {
        if (instance == null) {
            instance = new DAO_ApexClassSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return ApexClass.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                ApexClass.ApiVersion,
                ApexClass.Body,
                ApexClass.Id,
                ApexClass.LengthWithoutComments,
                ApexClass.Name
        };
    }

    public virtual List<ApexClass> selectByName(Set<String> nameSet) {
        return this.createQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(ApexClass.Name, nameSet))
                .query();
    }

    public virtual List<List<SObject>> findByTag(String tag) {
        return [
                FIND :tag
                IN ALL FIELDS
                        RETURNING ApexClass(Name, Body)
        ];
    }

}