public with sharing class XAP_TRG_TriggerSequenceChecker {
    private XAP_TRG_SObjectTypeOperationConvertor sObjectTypeOperationHelper;
    private XAP_TRG_TriggerOperationCoordinator operationCoordinator;

    @TestVisible
    private XAP_TRG_TriggerSequenceChecker(
            XAP_TRG_SObjectTypeOperationConvertor sObjectTypeOperationHelper,
            XAP_TRG_TriggerOperationCoordinator operationCoordinator
    ) {
        this.sObjectTypeOperationHelper = sObjectTypeOperationHelper;
        this.operationCoordinator = operationCoordinator;
    }

    private XAP_TRG_TriggerSequenceChecker() {
        this(XAP_TRG_SObjectTypeOperationConvertor.getInstance(), XAP_TRG_TriggerOperationCoordinator.getInstance());
    }

    private static XAP_TRG_TriggerSequenceChecker instance;
    public static XAP_TRG_TriggerSequenceChecker getInstance() {
        if (instance == null) {
            instance = new XAP_TRG_TriggerSequenceChecker();
        }
        return instance;
    }

    public XAP_COLL_ListComparison compare(List<XAP_TRG_TriggerSObjectTypeOperation> needleSObjectTypeOperationList) {
		List<XAP_TRG_TriggerSObjectTypeOperation> inProgressSObjectTypeOperationList
				= sObjectTypeOperationHelper.convert(this.operationCoordinator.getTriggerProgressList());

		return new XAP_COLL_ListComparison(inProgressSObjectTypeOperationList, needleSObjectTypeOperationList);
	}
}