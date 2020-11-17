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
        List<XAP_TRG_TriggerSteppable> stepList = this.stepLookup.get(context);
        for (XAP_TRG_TriggerSteppable step : stepList) {
            this.execute(step, context);
        }
        return this;
    }

    private XAP_TRG_TriggerHandler execute(XAP_TRG_TriggerSteppable step, XAP_TRG_TriggerContext context) {
        XAP_TRG_TriggerStepResultable result = step.execute(context);
        if (result instanceof XAP_TRG_TriggerStepFailure) {
            throw new XAP_TRG_TriggerException((XAP_TRG_TriggerStepFailure) result, step);
        }
        return this;
    }
}