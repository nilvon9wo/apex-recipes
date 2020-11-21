public inherited sharing class OrderAppMenu implements System.Queueable {
    private DAO_AppMenuItemSelector appMenuItemSelector;

    private OrderAppMenu(DAO_AppMenuItemSelector appMenuItemSelector) {
        this.appMenuItemSelector = appMenuItemSelector;
    }

    public OrderAppMenu() {
        this(DAO_AppMenuItemSelector.getInstance());
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public void execute(QueueableContext qc) {
        List<AppMenuItem> menuItems = this.appMenuItemSelector.selectAll();
        Map<String, AppMenuItem> menuItemByNameMap
                = (Map<String, AppMenuItem>) CollectionUtils.mapLastQualifiedSObjectBySpecifiedStringField(
                        menuItems, AppMenuItem.Name
                );
        List<Id> orderedItems = new List<Id>{
                menuItemByNameMap.remove('Apex_Recipes').ApplicationId
        };
        for (String key : menuItemByNameMap.keySet()) {
            orderedItems.add(menuItemByNameMap.get(key).ApplicationId);
        }
        AppLauncher.AppMenu.setOrgSortOrder(orderedItems);
    }
}
