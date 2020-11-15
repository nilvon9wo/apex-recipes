public class ContactSearchRequest {
    @InvocableVariable(
            Label='Generic SObject records - Input'
            Description='Input variable for generic SObjects'
            Required=true
    )
    public List<SObject> inputs;
}