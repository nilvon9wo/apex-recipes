public with sharing virtual class DAO_ContentVersionSelector  extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_ContentVersionSelector() {
    }

    private static DAO_ContentVersionSelector instance;
    public static DAO_ContentVersionSelector getInstance() {
        if (instance == null) {
            instance = new DAO_ContentVersionSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return ContentVersion.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                ContentVersion.Id,
                ContentVersion.Title
        };
    }

    public List<ContentVersion> secureSelectByDocumentId(Set<Id> documentIdSet) {
        return this.createQueryFactory()
                .setSecurityEnforced()
                .setEnforceFLS()
                .setCondition(new XAP_DAO_SOQL_WHERE_AndClause(new List<XAP_DAO_SOQL_WHERE_ClauseIntf>{
                        new XAP_DAO_SOQL_WHERE_InIdSetClause(ContentVersion.ContentDocumentId, documentIdSet),
                        new XAP_DAO_SOQL_WHERE_True(ContentVersion.IsLatest)
                }))
                .query();
    }
}