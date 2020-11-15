public class PermissionCache implements Cache.CacheBuilder {
    public Object doLoad(String sObjectType) {
        Map<String, Map<FLSType, Boolean>> results = new Map<String, Map<FLSType, Boolean>>();
        for (SObjectField field : getsObjectFields(sObjectType)) {
            DescribeFieldResult fieldDetails = field.getDescribe();

            String fieldKey = String.valueOf(field)
                    .toLowerCase();
            results.put(fieldKey, new Map<FLSType, Boolean>{
                    FLSType.ACCESSIBLE => fieldDetails.isAccessible(),
                    FLSType.UPDATABLE => fieldDetails.isUpdateable()
            });
        }
        return results;
    }

    private List<SObjectField> getsObjectFields(String sObjectType) {
        return Schema.describeSObjects(new List<String>{sObjectType})[0]
                .fields.getMap()
                .values();
    }
}