public with sharing class ARTR_ACT_AccountDeleteTaskFactory implements XAP_TRG_TriggerSteppable {
    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Account> oldAccountList = context.oldSObjectList;

        List<Task> newTaskList = new List<Task>();
        for (Account oldAccount : oldAccountList) {
            newTaskList.add(new Task(
                    Subject = 'Account was deleted, please verify'
            ));
        }

        return new XAP_TRG_TriggerStepSuccess(context.set(ARTR_TriggerStepKeys.NEW_TASK_LIST, newTaskList));
    }
}