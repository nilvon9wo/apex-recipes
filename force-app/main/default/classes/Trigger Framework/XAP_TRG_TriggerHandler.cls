public with sharing class XAP_TRG_TriggerHandler {
    private XAP_TRG_TriggerStepCache stepLookup;

    private XAP_TRG_TriggerHandler(XAP_TRG_TriggerStepCache stepLookup) {
        this.stepLookup = stepLookup;
    }

    private XAP_TRG_TriggerHandler(){
        this(XAP_TRG_TriggerStepCache.getInstance());
    }

    private static XAP_TRG_TriggerHandler instance;
    public static XAP_TRG_TriggerHandler getInstance() {
        if (instance == null) {
            instance = new XAP_TRG_TriggerHandler();
        }
        return instance;
    }

    public XAP_TRG_TriggerHandler execute() {
        return this.execute(new XAP_TRG_TriggerContext());
    }

    public XAP_TRG_TriggerHandler execute(XAP_TRG_TriggerContext context) {
        XAP_TRG_Trigger_Step__mdt previousStepRecord = new XAP_TRG_Trigger_Step__mdt();

        List<XAP_TRG_Trigger_Step__mdt> stepRecordList = this.stepLookup.get(context);
        for (XAP_TRG_Trigger_Step__mdt currentStepRecord : stepRecordList) {
            if (currentStepRecord.Is_Active__c) {
                this.checkSortOrderUniqueness(currentStepRecord, previousStepRecord)
                        .execute(currentStepRecord, context);

                previousStepRecord = currentStepRecord;
            }
            else {
                System.debug(LoggingLevel.WARN, 'Inactive step: ' + currentStepRecord.DeveloperName);
            }
        }
        return this;
    }

    private XAP_TRG_TriggerHandler execute(XAP_TRG_Trigger_Step__mdt currentStepRecord, XAP_TRG_TriggerContext context) {
        XAP_TRG_TriggerSteppable stepInstance = this.stepLookup.get(currentStepRecord);
        if (stepInstance != null) {
            execute(currentStepRecord, context, stepInstance);
        }
        return this;
    }

    private XAP_TRG_TriggerHandler execute(
            XAP_TRG_Trigger_Step__mdt currentStepRecord,
            XAP_TRG_TriggerContext context,
            XAP_TRG_TriggerSteppable stepInstance
    ) {
        XAP_TRG_TriggerStepResultable result = stepInstance.execute(context);
        if (result instanceof XAP_TRG_TriggerStepFailure) {
            throw new XAP_TRG_TriggerException((XAP_TRG_TriggerStepFailure) result, currentStepRecord);
        }
        return this;
    }

    private XAP_TRG_TriggerHandler checkSortOrderUniqueness(
            XAP_TRG_Trigger_Step__mdt currentStepRecord,
            XAP_TRG_Trigger_Step__mdt previousStepRecord
    ) {
        if (currentStepRecord.Sort_Order__c == previousStepRecord.Sort_Order__c) {
            throw new XAP_TRG_TriggerException(
                    'Ambiguous sort value in ' + currentStepRecord.DeveloperName + '.  '
                            + 'Each sort value can only be user once '
                            + 'per combination of SObject Type, Operation Timing, and Operation Type.'
            );
        }
        return this;
    }
}
