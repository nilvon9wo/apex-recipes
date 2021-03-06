public virtual inherited sharing class XAP_DAO_DML_InheritedSharingDml implements XAP_DAO_DML_GenericDmlIntf {
	XAP_DAO_DML_OperationModeHelper operationModeHelper;

	@TestVisible
	private XAP_DAO_DML_InheritedSharingDml(XAP_DAO_DML_OperationModeHelper operationModeHelper) {
		this.operationModeHelper = operationModeHelper;
	}

	protected XAP_DAO_DML_InheritedSharingDml() {
		this(XAP_DAO_DML_OperationModeHelper.getInstance());
	}

	// Not a singleton so inheritance can be different from different classes.
	public static XAP_DAO_DML_InheritedSharingDml getInstance() {
		return new XAP_DAO_DML_InheritedSharingDml();
	}

	// Insert Methods -----------------------------------------------------------------------------------------

	public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, Database.DMLOptions dmlOptions) {
		return new XAP_DAO_DML_SaveResultListWrapper(Database.insert(sObjectList, dmlOptions));
	}

	public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return new XAP_DAO_DML_SaveResultListWrapper(Database.insert(sObjectList, this.convert(operationMode)));
	}

	public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList) {
		return this.doInsert(sObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	// Publish Methods -----------------------------------------------------------------------------------------

	public virtual XAP_DAO_DML_SaveResultListWrapper doPublish(List<SObject> sObjectList) {
		return new XAP_DAO_DML_SaveResultListWrapper(EventBus.publish(sObjectList));
	}

	// Update Methods -----------------------------------------------------------------------------------------

	public virtual XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return new XAP_DAO_DML_SaveResultListWrapper(Database.update(sObjectList, this.convert(operationMode)));
	}

	public virtual XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList) {
		return this.doUpdate(sObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	// Upsert Methods -----------------------------------------------------------------------------------------

	public XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList, SObjectField foreignKeyField, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (homogeneousSObjectList == null || homogeneousSObjectList.isEmpty()) {
			return null;
		}

		// @see: https://salesforce.stackexchange.com/questions/215514/how-can-i-upsert-a-homogeneous-listsobject-in-a-good-way/215518#215518
		String listType = 'List<' + homogeneousSObjectList[0].getSObjectType() + '>';
		List<SObject> concreteSObjectList = (List<SObject>) Type.forName(listType).newInstance();
		concreteSObjectList.addAll(homogeneousSObjectList);

		return (foreignKeyField != null)
				? new XAP_DAO_DML_UpsertResultListWrapper(Database.upsert(homogeneousSObjectList, foreignKeyField, this.convert(operationMode)))
				:new XAP_DAO_DML_UpsertResultListWrapper(Database.upsert(homogeneousSObjectList, this.convert(operationMode)));
	}

	public virtual XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return this.doUpsert(homogeneousSObjectList, null, operationMode);
	}

	public virtual XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList) {
		return this.doUpsert(homogeneousSObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	// Delete Methods -----------------------------------------------------------------------------------------

	public virtual XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return new XAP_DAO_DML_DeleteResultListWrapper(Database.delete(sObjectList, this.convert(operationMode)));
	}

	public virtual XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList) {
		return this.doDelete(sObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	// Undelete Methods -----------------------------------------------------------------------------------------

	public virtual XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return new XAP_DAO_DML_UndeleteResultListWrapper(Database.undelete(sObjectList, this.convert(operationMode)));
	}

	public virtual XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList) {
		return this.doUndelete(sObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}
	// Helper Methods -----------------------------------------------------------------------------------------

	private Boolean convert(XAP_DAO_DML_OperationModeEnum operationMode) {
		return this.operationModeHelper.toBoolean(operationMode);
	}

}