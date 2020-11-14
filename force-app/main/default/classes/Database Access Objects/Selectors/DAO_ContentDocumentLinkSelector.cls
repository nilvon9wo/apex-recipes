public with sharing virtual class DAO_ContentDocumentLinkSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_ContentDocumentLinkSelector() {
        super.orderBy = 'ContentDocumentId';
    }

    private static DAO_ContentDocumentLinkSelector instance;
    public static DAO_ContentDocumentLinkSelector getInstance() {
        if (instance == null) {
            instance = new DAO_ContentDocumentLinkSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return ContentDocumentLink.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                ContentDocumentLink.ContentDocumentId
        };
    }

    public List<ContentDocumentLink> secureSelectByLinkedEntityAhdFileType(Id linkedEntityId, Set<String> fileTypeSet) {
        List<XAP_DAO_SOQL_WHERE_ClauseIntf> conditionList = new List<XAP_DAO_SOQL_WHERE_ClauseIntf>{
                new XAP_DAO_SOQL_WHERE_InIdSetClause(ContentDocumentLink.LinkedEntityId, new Set<Id>{linkedEntityId})
        };

        if (fileTypeSet != null) {
            conditionList.add(new XAP_DAO_SOQL_WHERE_RawInterpol8ionClause(
                    'ContentDocument.FileType IN :${fileTypeSet}',
                    new Map<String, Object>{'fileTypeSet' => fileTypeSet}
            ));
        }

        return this.createQueryFactory()
                .setSecurityEnforced()
                .setCondition(new XAP_DAO_SOQL_WHERE_AndClause(conditionList))
                .query();
    }
}