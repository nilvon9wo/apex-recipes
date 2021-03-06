public abstract class XAP_DAO_DML_ResultListWrapperAbs implements XAP_DAO_DML_ResultListWrapperIntf {
	public abstract List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList();

	@TestVisible
	private XAP_DAO_DML_SuccessLevelEnum successLevel {
		get {
			if(this.successLevel == null) {
				this.successLevel = this.calculateSuccessLevel();
			}
			return this.successLevel;
		}
		set;
	}

	public XAP_DAO_DML_SuccessLevelEnum getSuccessLevel() {
		return this.successLevel;
	}

	@TestVisible
	private XAP_DAO_DML_SuccessLevelEnum calculateSuccessLevel() {
		Boolean hasSuccess = false;
		Boolean hasFailure = false;

		for(XAP_DAO_DML_ResultWrapperIntf resultWrapper : this.getResultWrapperList()) {
			Boolean isSuccess = resultWrapper.isSuccess();
			if(isSuccess) {
				hasSuccess = true;
			} else {
				hasFailure = true;
			}
		}

		return (
				this.getResultWrapperList().isEmpty()
						|| hasSuccess && !hasFailure
		)
				? XAP_DAO_DML_SuccessLevelEnum.PERFECT
				: (hasSuccess && hasFailure)
						? XAP_DAO_DML_SuccessLevelEnum.PARTIAL
						: XAP_DAO_DML_SuccessLevelEnum.NONE;

	}

	public Boolean isCompleteSuccess() {
		if(XAP_DAO_DML_SuccessLevelEnum.PERFECT == this.successLevel) {
			return true;
		}
		return false;
	}

	public String getCombinedErrorMessage() {
		List<String> combinedErrorMessageList = new List<String>();
		for (XAP_DAO_DML_ResultWrapperIntf result : this.getResultWrapperList()) {
			if (!result.isSuccess()) {
				combinedErrorMessageList.add(this.getErrorMessage(result));
			}
		}
		return String.join(combinedErrorMessageList, ', ');
	}

	@TestVisible
	private String getErrorMessage(XAP_DAO_DML_ResultWrapperIntf result) {
			List<String> errorMessageList = new List<String>();
			for (XAP_DAO_DML_DatabaseErrorWrapper error : result.getErrorList()) {
				errorMessageList.add(error.message);
			}
		return '{ ' + result.getId() + ' Errors: '
				+ String.join(errorMessageList, ';')
				+ '}';
	}
}