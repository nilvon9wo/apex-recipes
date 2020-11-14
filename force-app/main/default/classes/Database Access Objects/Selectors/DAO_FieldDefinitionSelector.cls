public with sharing virtual class DAO_FieldDefinitionSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_FieldDefinitionSelector() {
        super.orderBy = 'DeveloperName';
    }

    private static DAO_FieldDefinitionSelector instance;
    public static DAO_FieldDefinitionSelector getInstance() {
        if (instance == null) {
            instance = new DAO_FieldDefinitionSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return FieldDefinition.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                FieldDefinition.DeveloperName,
                FieldDefinition.DataType,
                FieldDefinition.RelationshipName
        };
    }

    public List<FieldDefinition> selectByRelationshipNameAndEntityDeveloperName(
            String relationshipName,
            String entityDeveloperName
    ) {
        // We can't use the selector pattern here because of a defect in how Salesforce composed
        // the relationship between EntityDefinition and FieldDefinition.
        // @see: https://github.com/apex-enterprise-patterns/fflib-apex-common/issues/240
        return [
                SELECT DataType, DeveloperName, EntityDefinition.DeveloperName,
                        RelationshipName
                FROM FieldDefinition
                WHERE RelationshipName = :relationshipName
                        AND EntityDefinition.DeveloperName = :entityDeveloperName
        ];
    }
}