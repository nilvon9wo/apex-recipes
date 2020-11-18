public with sharing virtual class XAP_TRG_SObjectTypeOperationConvertor {
	@TestVisible
	private XAP_TRG_SObjectTypeOperationConvertor(){
	}

	private static XAP_TRG_SObjectTypeOperationConvertor instance;
	public static XAP_TRG_SObjectTypeOperationConvertor getInstance() {
		if (instance == null) {
			instance = new XAP_TRG_SObjectTypeOperationConvertor();
		}
		return instance;
	}

	public virtual List<XAP_TRG_TriggerSObjectTypeOperation> convert(List<XAP_TRG_TriggerContext> triggerPropertiesList) {
		List<XAP_TRG_TriggerSObjectTypeOperation> operationList = new List<XAP_TRG_TriggerSObjectTypeOperation>();
		for (XAP_TRG_TriggerContext triggerProperties : triggerPropertiesList) {
			operationList.add(new XAP_TRG_TriggerSObjectTypeOperation(triggerProperties));
		}
		return operationList;
	}
}