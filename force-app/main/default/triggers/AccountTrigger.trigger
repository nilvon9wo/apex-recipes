trigger AccountTrigger on Account(
    before insert,
    after insert,
    before update,
    after update,
    before delete,
    after delete,
    after undelete
) {
    XAP_TRG_TriggerHandler.execute();
}
