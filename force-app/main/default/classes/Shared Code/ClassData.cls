public class ClassData {
    private ClassData(ApexClass klass, String groupName) {
        this.name = klass.Name;
        this.apiVersion = klass.ApiVersion;
        this.body = klass.Body;
        this.lengthWithoutComments = klass.LengthWithoutComments;
        this.groupName = groupName;
    }

    private ClassData(ApexClass klass, ApexClassUtilities classUtilities) {
        this(
                klass,
                (!klass.Name.endsWith('_Tests'))
                        ? classUtilities.getGroupFromClassBody(klass)
                        : 'Tests'
        );
    }

    public ClassData(ApexClass klass) {
        this(klass, new ApexClassUtilities());
    }

    @AuraEnabled
    public String name;
    @AuraEnabled
    public Decimal apiVersion;
    @AuraEnabled
    public String body;
    @AuraEnabled
    public Integer lengthWithoutComments;
    @AuraEnabled
    public String groupName;
}