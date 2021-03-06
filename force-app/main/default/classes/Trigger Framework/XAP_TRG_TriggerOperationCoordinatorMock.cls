@IsTest
public with sharing class XAP_TRG_TriggerOperationCoordinatorMock extends XAP_TRG_TriggerOperationCoordinator {
	public XAP_TRG_TriggerContext receivedTriggerProperties;
	public Boolean returnIsExecutable;
	public override Boolean isExecutable(XAP_TRG_TriggerContext triggerProperties) {
		this.receivedTriggerProperties = triggerProperties;
		return this.returnIsExecutable;
	}

	public Set<SObjectType> receivedDisabledObjectTypeSet;
	public Map<SObjectType, Boolean> returnedEnabledBySObjectTypeAfterDisableMap;
	public override Map<SObjectType, Boolean> dynamicDisable(Set<SObjectType> sObjectTypeSet) {
		this.receivedDisabledObjectTypeSet = sObjectTypeSet;
		return this.returnedEnabledBySObjectTypeAfterDisableMap;
	}

	public Set<SObjectType> receivedEnabledObjectTypeSet;
	public Map<SObjectType, Boolean> returnedEnabledBySObjectTypeAfterEnableMap;
	public override Map<SObjectType, Boolean> dynamicEnable(Set<SObjectType> sObjectTypeSet) {
		this.receivedEnabledObjectTypeSet = sObjectTypeSet;
		return this.returnedEnabledBySObjectTypeAfterEnableMap;
	}

	public Boolean wasGetTriggerProgressListCalled = false;
	public List<XAP_TRG_TriggerContext> returnedTriggerProgressList;
	public override List<XAP_TRG_TriggerContext> getTriggerProgressList() {
		this.wasGetTriggerProgressListCalled = true;
		return this.returnedTriggerProgressList;
	}
}