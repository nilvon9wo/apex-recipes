public inherited sharing class AccountTriggerHandler extends TriggerHandler {
    private AccountServiceLayer accountServiceLayer;
    private CanTheUser canUser;
    private List<Account> triggerNew;
    private List<Account> triggerOld;
    private Map<Id, Account> triggerMapNew;
    private Map<Id, Account> triggerMapOld;

    public AccountTriggerHandler(AccountServiceLayer accountServiceLayer, CanTheUser canUser) {
        this.accountServiceLayer = accountServiceLayer;
        this.canUser = canUser;
        this.triggerOld = (List<Account>) Trigger.old;
        this.triggerNew = (List<Account>) Trigger.new;
        this.triggerMapNew = (Map<Id, Account>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Account>) Trigger.oldMap;
    }
    
    public AccountTriggerHandler() {
        this(new AccountServiceLayer(), new CanTheUser());
    }

    @TestVisible
    private static Exception circuitBreaker;

    public override void beforeInsert() {
        this.accountServiceLayer.incrementCounterInDescription(
            this.triggerNew,
            false
        );
    }

    public override void afterInsert() {
        this.accountServiceLayer.changeShippingStreet(this.triggerNew);
    }

    public override void beforeUpdate() {
        for (Account acct : this.triggerNew) {
            if (acct.ShippingState != null && acct.ShippingState.length() > 2) {
                acct.addError('Shipping State Length exceeds maximum allowed');
            }
            acct.ShippingStreet += ' before update trigger';
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        List<Task> newTasks = new List<Task>();
        if (this.canUser.create(new Task()) && this.canUser.read(new Task())) {
            for (Account acct : this.triggerNew) {
                Task tsk = new Task(
                    WhatId = acct.Id,
                    Subject = 'Account was updated, please verify'
                );
                newTasks.add(tsk);
            }

            try {
                if (
                    Test.isRunningTest() &&
                    AccountTriggerHandler.circuitBreaker != null
                ) {
                    throw AccountTriggerHandler.circuitBreaker;
                }
                insert newTasks;
            } catch (DmlException dmle) {
                System.debug(
                    LoggingLevel.INFO,
                    'Inserting Tasks for newly updated accounts failed with a DML exception. Details: ' +
                    dmle.getMessage()
                );
                throw new AccountTriggerHandlerException(
                    'Failed to insert tasks'
                );
            }
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        System.debug(LoggingLevel.INFO, 'Deleting an account');
        List<Account> clonedAccounts = new List<Account>();
        for (Account acct : this.triggerOld) {
            clonedAccounts.add(acct.clone());
        }

        try {
            if (this.canUser.create(new Account())) {
                insert clonedAccounts;
            }
        } catch (DmlException dmle) {
            System.debug(
                LoggingLevel.INFO,
                'Inserting cloned accounts failed with DML exception. Details: ' +
                dmle.getMessage()
            );
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        System.debug(LoggingLevel.INFO, 'After Delete Action');
        List<Task> newTasks = new List<Task>();
        for (Account acct : this.triggerOld) {
            Task tsk = new Task(Subject = 'Account was deleted, please verify');
            newTasks.add(tsk);
        }

        try {
            if (this.canUser.create(new Task())) {
                insert newTasks;
            }
        } catch (DmlException dmle) {
            System.debug(
                LoggingLevel.INFO,
                'Inserting Tasks for deleted accounts failed with a DML exception. Details: ' +
                dmle.getMessage()
            );
            throw new AccountTriggerHandlerException(
                'Failed to insert Tasks: ' + dmle.getMessage()
            );
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        System.debug(LoggingLevel.INFO, 'After undelete context method called');
        List<Task> newTasks = new List<Task>();
        for (Account acct : this.triggerNew) {
            Task tsk = new Task(
                WhatId = acct.Id,
                Subject = 'Previously deleted account restored. Please verify'
            );
            newTasks.add(tsk);
        }

        try {
            if (this.canUser.create(new Task())) {
                insert newTasks;
            }
        } catch (DmlException dmle) {
            System.debug(
                LoggingLevel.INFO,
                'Inserting Tasks for restored accounts failed with a DML exception. Details: ' +
                dmle.getMessage()
            );
        }
    }
}
