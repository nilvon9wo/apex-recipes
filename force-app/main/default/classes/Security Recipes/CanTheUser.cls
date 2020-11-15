public inherited sharing class CanTheUser {
    @TestVisible
    private static Map<String, Set<String>> accessibleFieldsByObject = new Map<String, Set<String>>();
    @TestVisible
    private static Map<String, Set<String>> updatableFieldsByObject = new Map<String, Set<String>>();

    private class PermissionCache implements Cache.CacheBuilder {
        public Object doLoad(String objType) {
            Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(
                new List<String>{ objType }
            );

            Map<String, Map<FLSType, Boolean>> results = new Map<String, Map<FLSType, Boolean>>();
            for (SObjectField field : descResult[0].fields.getMap().values()) {
                DescribeFieldResult fieldDetails = field.getDescribe();
                String fieldKey = String.valueOf(field).toLowerCase();
                results.put(fieldKey, new Map<FLSType, Boolean>());
                results.get(fieldKey)
                    .put(FLSType.ACCESSIBLE, fieldDetails.isAccessible());
                results.get(fieldKey)
                    .put(FLSType.UPDATABLE, fieldDetails.isUpdateable());
            }
            return results;
        }
    }

    public static Boolean crud(SObject obj, CrudType permission) {
        switch on permission {
            when CREATE {
                return obj.getSObjectType().getDescribe().isCreateable();
            }
            when READ {
                return obj.getSObjectType().getDescribe().isAccessible();
            }
            when EDIT {
                return obj.getSObjectType().getDescribe().isUpdateable();
            }
            when DEL {
                return obj.getSObjectType().getDescribe().isDeletable();
            }
        }
        return false;
    }

    public static Boolean create(SObject obj) {
        return CanTheUser.crud(obj, CrudType.CREATE);
    }

    public static Boolean read(SObject obj) {
        return CanTheUser.crud(obj, CrudType.READ);
    }

    public static Boolean edit(SObject obj) {
        return CanTheUser.crud(obj, CrudType.EDIT);
    }

    public static Boolean destroy(SObject obj) {
        return CanTheUser.crud(obj, CrudType.DEL);
    }

    public static Boolean flsAccessible(String obj, String field) {
        return getFLSForFieldOnObject(obj, field, FLSType.ACCESSIBLE);
    }

    public static Map<String, Boolean> bulkFLSAccessible(
        String obj,
        Set<String> fields
    ) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String field : fields) {
            results.put(field, flsAccessible(obj, field));
        }
        return results;
    }

    public static Boolean flsUpdatable(String obj, String field) {
        return getFLSForFieldOnObject(obj, field, FLSType.UPDATABLE);
    }

    public static Map<String, Boolean> bulkFLSUpdatable(
        String obj,
        Set<String> fields
    ) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String field : fields) {
            results.put(field, flsUpdatable(obj, field));
        }
        return results;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @TestVisible
    private static Set<String> memoizeFLSMDC(String objType, FLSType action) {
        List<FieldPermissions> fields = [
            SELECT Id, Field, PermissionsEdit, PermissionsRead, SobjectType
            FROM FieldPermissions
            WHERE SobjectType = :objType
        ];

        if (!CanTheUser.accessibleFieldsByObject.containsKey(objType)) {
            Set<String> accessibleFields = new Set<String>();
            Set<String> updatableFields = new Set<String>();
            for (FieldPermissions field : fields) {
                String[] parts = field.Field.split('\\.');
                if (field.PermissionsRead) {
                    accessibleFields.add(parts[1].toLowerCase());
                }
                if (field.PermissionsEdit) {
                    updatableFields.add(parts[1].toLowerCase());
                }
            }
            CanTheUser.accessibleFieldsByObject.put(objType, accessibleFields);
            CanTheUser.updatableFieldsByObject.put(objType, updatableFields);
        }

        if (action == FLSType.ACCESSIBLE) {
            return CanTheUser.accessibleFieldsByObject.get(objType);
        } else {
            return CanTheUser.updatableFieldsByObject.get(objType);
        }
    }

    /**
     * @description     Abstracted method for retrieving or calculating
     * (memoization) of the FLS for a given field on a given object.
     * @param obj       String version of object name to check
     * @param field     String version of the field to check
     * @param checkType Enum of Accessible or Updatable.
     * @returns         `Boolean`
     */
    private static Boolean getFLSForFieldOnObject(
        String obj,
        String field,
        FLSType checkType
    ) {
        Cache.Partition defaultSession = new PlatformCacheRecipes().getDefaultPartition(
            PartitionType.SESSION
        );
        Map<String, Map<FLSType, Boolean>> objResults = (Map<String, Map<FLSType, Boolean>>) defaultSession
            .get(PermissionCache.class, obj);
        Boolean results = objResults.get(field.toLowerCase())?.get(checkType);
        return (results != null && results) ? true : false;
    }
}
