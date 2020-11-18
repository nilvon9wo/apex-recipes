trigger PlatformEventRecipesTrigger on Event_Recipes_Demo__e(after insert) {
    System.debug('######### BEGIN PlatformEventRecipesTrigger');
    XAP_TRG_TriggerHandler.execute();
    System.debug('######### END PlatformEventRecipesTrigger');
}
