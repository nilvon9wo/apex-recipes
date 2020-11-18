public with sharing class ARTR_ACT_AccountUpdateTaskFactory implements XAP_TRG_TriggerSteppable {
    private CanTheUser canUser;

    private ARTR_ACT_AccountUpdateTaskFactory(CanTheUser canUser) {
        this.canUser = canUser;
    }

    public ARTR_ACT_AccountUpdateTaskFactory() {
        this(CanTheUser.getInstance());
    }

    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Account> newAccountList = context.newSObjectList;

        List<Task> newTaskList = new List<Task>();
        if (this.canUser.create(new Task()) && this.canUser.read(new Task())) {
            for (Account newAccount : newAccountList) {
                newTaskList.add(new Task(
                        WhatId = newAccount.Id,
                        Subject = 'Account was updated, please verify'
                ));
            }
        }

        return new XAP_TRG_TriggerStepSuccess(context.set(ARTR_TriggerStepKeys.NEW_TASK_LIST, newTaskList));
    }
}