public inherited sharing class MetadataCatalogRecipes {
    private DAO_EntityDefinitionSelector entityDefinitionSelector;
    private DAO_FieldDefinitionSelector fieldDefinitionSelector;

    private MetadataCatalogRecipes(
            DAO_EntityDefinitionSelector entityDefinitionSelector,
            DAO_FieldDefinitionSelector fieldDefinitionSelector
    ) {
        this.entityDefinitionSelector = entityDefinitionSelector;
        this.fieldDefinitionSelector = fieldDefinitionSelector;
    }

    public MetadataCatalogRecipes() {
        this(DAO_EntityDefinitionSelector.getInstance(), DAO_FieldDefinitionSelector.getInstance());
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public Map<String, Map<String, String>> findAllFormulaFields() {
        List<EntityDefinition> entityDefinitionList = this.entityDefinitionSelector.selectCalculatedWithFields();
        return this.buildDataTypeByFormulaFieldByEntityDefinitionMap(entityDefinitionList);
    }

    private Map<String, Map<String, String>> buildDataTypeByFormulaFieldByEntityDefinitionMap(
            List<EntityDefinition> entityDefinitionList
    ) {
        Map<String, Map<String, String>> dataTypeByFormulaFieldByEntityDefinitionMap = new Map<String, Map<String, String>>();
        for (EntityDefinition entityDefinition : entityDefinitionList) {
            String qualifiedApiName = String.valueOf(entityDefinition.QualifiedApiName);
            Map<String, String> dataTypeByFormulaFieldMap = this.buildDataTypeByFormulaFieldMap(entityDefinition);
            dataTypeByFormulaFieldByEntityDefinitionMap.put(qualifiedApiName, dataTypeByFormulaFieldMap);
        }
        return dataTypeByFormulaFieldByEntityDefinitionMap;
    }

    private Map<String, String> buildDataTypeByFormulaFieldMap(EntityDefinition entityDefinition) {
        Map<String, String> dataTypeByFormulaFieldMap = new Map<String, String> ();
        for (FieldDefinition fieldDefinition : entityDefinition.getSObjects('Fields')) {
            dataTypeByFormulaFieldMap.put(fieldDefinition.DeveloperName, fieldDefinition.DataType);
        }
        return dataTypeByFormulaFieldMap;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public List<LookupRelationshipDefinition> findAllContactFieldsThatLookupToAccount() {
        List<FieldDefinition> looksUpFieldsToAccount
                = this.fieldDefinitionSelector.selectByRelationshipNameAndEntityDeveloperName('Account', 'Contact');

        return this.findAllContactFieldsThatLookupToAccount(looksUpFieldsToAccount);
    }

    private List<LookupRelationshipDefinition> findAllContactFieldsThatLookupToAccount(
            List<FieldDefinition> looksUpFieldsToAccount
    ) {
        List<LookupRelationshipDefinition> relationshipList = new List<LookupRelationshipDefinition>();
        for (FieldDefinition fieldDefinition : looksUpFieldsToAccount) {
            relationshipList.add(new LookupRelationshipDefinition(fieldDefinition));
        }
        return relationshipList;
    }
}
