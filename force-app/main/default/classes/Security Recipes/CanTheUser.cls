public inherited sharing class CanTheUser {
    private DAO_FieldPermissionsSelector fieldPermissionsSelector;
    private PlatformCacheRecipes platformCacheRecipes;

    private CanTheUser(
            DAO_FieldPermissionsSelector fieldPermissionsSelector,
            PlatformCacheRecipes platformCacheRecipes
    ) {
        this.fieldPermissionsSelector = fieldPermissionsSelector;
        this.platformCacheRecipes = platformCacheRecipes;
    }

    public CanTheUser() {
        this(DAO_FieldPermissionsSelector.getInstance(), new PlatformCacheRecipes());
    }

    @TestVisible
    private static Map<String, Set<String>> accessibleFieldsByObject = new Map<String, Set<String>>();
    @TestVisible
    private static Map<String, Set<String>> updatableFieldsByObject = new Map<String, Set<String>>();

    public Boolean crud(SObject obj, CrudType permission) {
        DescribeSObjectResult describeSObjectResult = obj.getSObjectType()
                .getDescribe();
        return this.crud(describeSObjectResult, permission);
    }

    private Boolean crud(DescribeSObjectResult describeSObjectResult, CrudType permission) {
        switch on permission {
            when CREATE {
                return describeSObjectResult.isCreateable();
            }
            when READ {
                return describeSObjectResult.isAccessible();
            }
            when EDIT {
                return describeSObjectResult.isUpdateable();
            }
            when DEL {
                return describeSObjectResult.isDeletable();
            }
        }
        return false;
    }

    public Boolean create(SObject obj) {
        return this.crud(obj, CrudType.CREATE);
    }

    public Boolean read(SObject obj) {
        return this.crud(obj, CrudType.READ);
    }

    public Boolean edit(SObject obj) {
        return this.crud(obj, CrudType.EDIT);
    }

    public Boolean destroy(SObject obj) {
        return this.crud(obj, CrudType.DEL);
    }

    public Boolean flsAccessible(String obj, String field) {
        return this.getFLSForFieldOnObject(obj, field, FLSType.ACCESSIBLE);
    }

    public Map<String, Boolean> bulkFLSAccessible(String obj, Set<String> fields) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String field : fields) {
            results.put(field, this.flsAccessible(obj, field));
        }
        return results;
    }

    public Boolean flsUpdatable(String obj, String field) {
        return this.getFLSForFieldOnObject(obj, field, FLSType.UPDATABLE);
    }

    public Map<String, Boolean> bulkFLSUpdatable(
            String obj,
            Set<String> fields
    ) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String field : fields) {
            results.put(field, this.flsUpdatable(obj, field));
        }
        return results;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @TestVisible
    private Set<String> memoizeFLSMDC(String sobjectType, FLSType action) {
        if (!accessibleFieldsByObject.containsKey(sobjectType)) {
            this.memoizeFieldPermissions(sobjectType);
        }

        return (action == FLSType.ACCESSIBLE)
                ? accessibleFieldsByObject.get(sobjectType)
                : updatableFieldsByObject.get(sobjectType);
    }

    private void memoizeFieldPermissions(String sobjectType) {
        List<FieldPermissions> fieldPermissionList
                = this.fieldPermissionsSelector.selectBySObjectType(new Set<String>{sobjectType});

        this.memoizeFieldPermissions(sobjectType, fieldPermissionList);
    }

    private void memoizeFieldPermissions(String sobjectType, List<FieldPermissions> fieldPermissionList) {
        Set<String> accessibleFieldSet = new Set<String>();
        Set<String> updatableFieldSet = new Set<String>();

        for (FieldPermissions field : fieldPermissionList) {
            String fieldSecondPart = field.Field.split('\\.')[1]
                    .toLowerCase();
            if (field.PermissionsRead) {
                accessibleFieldSet.add(fieldSecondPart);
            }
            if (field.PermissionsEdit) {
                updatableFieldSet.add(fieldSecondPart);
            }
        }

        accessibleFieldsByObject.put(sobjectType, accessibleFieldSet);
        updatableFieldsByObject.put(sobjectType, updatableFieldSet);
    }

    private Boolean getFLSForFieldOnObject(String obj, String field, FLSType checkType) {
        Map<String, Map<FLSType, Boolean>> objResults = (Map<String, Map<FLSType, Boolean>>) this.platformCacheRecipes
                .getDefaultPartition(PartitionType.SESSION)
                .get(PermissionCache.class, obj);
        Boolean results = objResults.get(field.toLowerCase())
                ?.get(checkType);
        return (results != null && results);
    }
}
