trigger PlatformEventRecipesTrigger on Event_Recipes_Demo__e(after insert) {
    XAP_TRG_TriggerHandler.execute();
}
