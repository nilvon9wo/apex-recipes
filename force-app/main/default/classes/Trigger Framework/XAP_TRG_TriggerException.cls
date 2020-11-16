public with sharing class XAP_TRG_TriggerException extends Exception {
    XAP_TRG_Trigger_Step__mdt step;
    XAP_TRG_TriggerStepFailure failure;

    public XAP_TRG_TriggerException(TypeException ex, XAP_TRG_Trigger_Step__mdt step){
        this('Failure during creation of ' + step.Class_Name__c, ex);
        this.step = step;
    }

    public XAP_TRG_TriggerException(XAP_TRG_TriggerStepFailure failure, XAP_TRG_Trigger_Step__mdt step){
        this('Failure during execution of ' + step.Class_Name__c, failure.getException());
        this.step = step;
        this.failure = failure;
    }
}