public with sharing class ARTR_DAO_TaskInserter implements XAP_TRG_TriggerSteppable {
    private XAP_DAO_DML_InheritedSharingDml dml;

    private ARTR_DAO_TaskInserter(XAP_DAO_DML_InheritedSharingDml dml) {
        this.dml = dml;
    }

    public ARTR_DAO_TaskInserter() {
        this(XAP_DAO_DML_InheritedSharingDml.getInstance());
    }

    @TestVisible
    private static Exception circuitBreaker;

    public XAP_TRG_TriggerStepResultable execute(XAP_TRG_TriggerContext context) {
        List<Task> newTaskList = (List<Task>) context.get(ARTR_TriggerStepKeys.NEW_TASK_LIST);

        try {
            if (Test.isRunningTest() && circuitBreaker != null) {
                throw circuitBreaker;
            }
            this.dml.doInsert(newTaskList);
        }
        catch (DmlException dmlException) {
            this.logException(context, dmlException);
            throw new AccountTriggerHandlerException('Failed to insert tasks:');
        }

        return new XAP_TRG_TriggerStepSuccess(context);
    }

    private void logException(XAP_TRG_TriggerContext context, DmlException dmlException) {
        String adjective;
        switch on context.operationType {
            when AFTER_INSERT {
                adjective = 'inserted';
            }
            when AFTER_UPDATE {
                adjective = 'updated';
            }
            when AFTER_DELETE {
                adjective = 'deleted';
            }
            when AFTER_UNDELETE {
                adjective = 'restored';
            }
        }
        System.debug(LoggingLevel.ERROR,
                'Inserting Tasks for newly ' + adjective + ' accounts failed with a DML exception. Details: ' +
                        dmlException.getMessage()
        );
    }
}