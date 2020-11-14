@IsTest
public class XAP_DAO_DML_GenericDmlMock extends XAP_DAO_DML_InheritedSharingDml {
	// These need to be lists in case there are multiple DML operations during your test.
	// Otherwise, only the last operation would be verifiable.
	public List<List<SObject>> insertedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> insertWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<List<SObject>> updatedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> updateWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<List<SObject>> upsertedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> upsertWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<List<SObject>> deletedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> deleteWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<List<SObject>> undeletedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> undeleteWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<XAP_DAO_DML_ResultListWrapperIntf> dmlResultListWrapperList;
	private Integer returnedResult = 0;

	public Exception thrownException;
	public Integer resultToThrowExceptionOn;

	public override XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.insertedSObjectListList.add(sObjectList);
		}
		this.insertWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_SaveResultListWrapper) this.getNextResultList();
	}

	public override XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.updatedSObjectListList.add(sObjectList);
		}
		this.updateWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_SaveResultListWrapper) this.getNextResultList();
	}

	public override XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.upsertedSObjectListList.add(sObjectList);
			for (SObject sObj : sObjectList) {
				if (sObj.Id == null) {
					XFTY_IdMocker.addId(sObj);
				}
			}
		}
		this.upsertWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_UpsertResultListWrapper) this.getNextResultList();
	}

	public override XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.deletedSObjectListList.add(sObjectList);
		}
		this.deleteWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_DeleteResultListWrapper) this.getNextResultList();
	}

	public override XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.undeletedSObjectListList.add(sObjectList);
		}
		this.undeleteWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_UndeleteResultListWrapper) this.getNextResultList();
	}

	private XAP_DAO_DML_ResultListWrapperIntf getNextResultList() {
		if (thrownException != null && returnedResult == resultToThrowExceptionOn) {
			throw  thrownException;
		}

		return (dmlResultListWrapperList != null)
				? dmlResultListWrapperList[returnedResult++]
				: null;
	}
}