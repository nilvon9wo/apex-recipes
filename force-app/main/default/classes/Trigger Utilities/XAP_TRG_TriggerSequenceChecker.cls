public with sharing class XAP_TRG_TriggerSequenceChecker {
    private XAP_TRIG_SObjectTypeOperationConvertor sObjectTypeOperationHelper;

    private XAP_TRG_TriggerSequenceChecker(XAP_TRIG_SObjectTypeOperationConvertor sObjectTypeOperationHelper) {
        this.sObjectTypeOperationHelper = sObjectTypeOperationHelper;
    }

    private XAP_TRG_TriggerSequenceChecker() {
        this(new XAP_TRIG_SObjectTypeOperationConvertor());
    }

    private static XAP_TRG_TriggerSequenceChecker instance;
    public static XAP_TRG_TriggerSequenceChecker getInstance() {
        if (instance == null) {
            instance = new XAP_TRG_TriggerSequenceChecker();
        }
        return instance;
    }

    public XAP_COLL_ListComparison compare(
            List<XAP_TRG_TriggerContext> triggerInProgressList,
            List<XAP_TRIG_TriggerSObjectTypeOperation> needleSObjectTypeOperationList
    ) {
		List<XAP_TRIG_TriggerSObjectTypeOperation> inProgressSObjectTypeOperationList
				= sObjectTypeOperationHelper.convert(triggerInProgressList);

		return new XAP_COLL_ListComparison(inProgressSObjectTypeOperationList, needleSObjectTypeOperationList);
	}
}