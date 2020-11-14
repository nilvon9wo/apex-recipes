public with sharing virtual class DAO_EntityDefinitionSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_FieldDefinitionSelector fieldDefinitionSelector;

    private DAO_EntityDefinitionSelector(DAO_FieldDefinitionSelector fieldDefinitionSelector) {
        super.orderBy = 'DeveloperName';
        this.fieldDefinitionSelector = fieldDefinitionSelector;
    }

    protected DAO_EntityDefinitionSelector() {
        this(DAO_FieldDefinitionSelector.getInstance());
    }

    private static DAO_EntityDefinitionSelector instance;
    public static DAO_EntityDefinitionSelector getInstance() {
        if (instance == null) {
            instance = new DAO_EntityDefinitionSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return EntityDefinition.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                EntityDefinition.DeveloperName,
                EntityDefinition.QualifiedApiName
        };
    }

    public List<EntityDefinition> selectCalculatedWithFields() {
        XAP_DAO_SOQL_QueryFactory entityDefinitionQueryFactory = this.createQueryFactory();

        this.fieldDefinitionSelector
                .injectParentToSelectChildFields(entityDefinitionQueryFactory, 'Fields')
                .setCondition(new XAP_DAO_SOQL_WHERE_True(FieldDefinition.IsCalculated));

        return entityDefinitionQueryFactory.query();
    }

}