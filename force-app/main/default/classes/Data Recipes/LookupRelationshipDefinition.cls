public class LookupRelationshipDefinition {
    public String looksUpTo { get; set; }
    public String developerName { get; set; }
    public String relationshipName { get; set; }
    public String dataType { get; set; }

    public LookupRelationshipDefinition(FieldDefinition fieldDefinition) {
        this.looksUpTo = String.valueOf(fieldDefinition.EntityDefinition.DeveloperName);
        this.developerName = String.valueOf(fieldDefinition.DeveloperName);
        this.relationshipName = String.valueOf(fieldDefinition.RelationshipName);
        this.dataType = String.valueOf(fieldDefinition.DataType);
    }
}