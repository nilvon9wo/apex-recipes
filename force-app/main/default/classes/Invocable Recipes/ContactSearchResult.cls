public class ContactSearchResult {
    @InvocableVariable(
            Label='Generic SObject record - Output'
            Description='Output variable for generic SObject'
            Required=true
    )
    public SObject output;
    public ContactSearchResult(SObject toOutput) {
        this.output = toOutput;
    }
}