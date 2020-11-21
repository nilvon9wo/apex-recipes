public with sharing virtual class DAO_AppMenuItemSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    protected DAO_AppMenuItemSelector() {
    }

    private static DAO_AppMenuItemSelector instance;
    public static DAO_AppMenuItemSelector getInstance() {
        if (instance == null) {
            instance = new DAO_AppMenuItemSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return AppMenuItem.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                AppMenuItem.ApplicationId,
                AppMenuItem.Name
        };
    }

    public virtual List<AppMenuItem> selectAll() {
        return this.createQueryFactory()
                .query();
    }
}