public with sharing virtual class DAO_FieldPermissionsSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_FieldPermissionsSelector() {
        super.orderBy = 'SobjectType';
    }

    private static DAO_FieldPermissionsSelector instance;
    public static DAO_FieldPermissionsSelector getInstance() {
        if (instance == null) {
            instance = new DAO_FieldPermissionsSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return FieldPermissions.getSObjectType();
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                FieldPermissions.Field,
                FieldPermissions.Id,
                FieldPermissions.PermissionsEdit,
                FieldPermissions.PermissionsRead,
                FieldPermissions.SobjectType
        };
    }

    public virtual List<FieldPermissions> selectBySObjectType(Set<String> sObjectTypeSet) {
        return this.createQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(FieldPermissions.SobjectType, sObjectTypeSet))
                .query();
    }
}