public inherited sharing class PlatformEventRecipes {
    private XAP_DAO_DML_SecureDml dml;

    public PlatformEventRecipes(XAP_DAO_DML_SecureDml dml) {
        this.dml = dml;
    }

    public PlatformEventRecipes() {
        this(XAP_DAO_DML_SecureDml.getInstance());
    }

    public XAP_DAO_DML_SaveResultListWrapper publishEvent(Event_Recipes_Demo__e event) {
        try {
            return this.dml.doPublish(new List<Event_Recipes_Demo__e>{event});
        }
        catch (XAP_DAO_DML_CrudException ex){
            throw new PlatformEventRecipesException('User has no permission to publish event');
        }
    }
}
