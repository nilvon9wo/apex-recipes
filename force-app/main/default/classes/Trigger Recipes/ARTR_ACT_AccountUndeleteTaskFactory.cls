public with sharing class ARTR_ACT_AccountUndeleteTaskFactory implements XAP_TRG_TriggerSteppable {
    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Account> newAccountList = context.newSObjectList;

        List<Task> newTaskList = new List<Task>();
        for (Account newAccount : newAccountList) {
            newTaskList.add(new Task(
                    WhatId = newAccount.Id,
                    Subject = 'Previously deleted account restored. Please verify'
            ));
        }

        return new XAP_TRG_TriggerStepSuccess(context.set(ARTR_TriggerStepKeys.NEW_TASK_LIST, newTaskList));
    }
}