public inherited sharing class OrderAppMenu implements System.Queueable {
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public void execute(QueueableContext qc) {
        AppMenuItem[] menuItems = [SELECT ApplicationId, Name FROM AppMenuItem];
        Map<String, AppMenuItem> menuItemMap = (Map<String, AppMenuItem>) CollectionUtils.mapLastQualifiedSObjectBySpecifiedStringField(
                menuItems, AppMenuItem.Name
        );
        Id[] orderedItems = new List<Id>{};
        orderedItems.add(menuItemMap.remove('Apex_Recipes').ApplicationId);
        for (String key : menuItemMap.keySet()) {
            orderedItems.add(menuItemMap.get(key).ApplicationId);
        }
        AppLauncher.AppMenu.setOrgSortOrder(orderedItems);
    }
}
