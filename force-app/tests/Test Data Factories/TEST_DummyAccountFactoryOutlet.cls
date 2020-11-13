@IsTest
public class TEST_DummyAccountFactoryOutlet implements XFTY_DummySobjectFactoryOutletIntf {
	private static final SObjectField PRIMARY_TARGET_FIELD = Account.Id;
	public static final String COMPANY_ACCOUNT = 'Company_Account';

	private static final XFTY_DummySObjectMasterTemplate COMPANY_TEMPLATE = new XFTY_DummySObjectMasterTemplate(PRIMARY_TARGET_FIELD)
			.put(Account.Name, new XFTY_DummyDefaultValueIncrementingString(COMPANY_ACCOUNT));

	public SObjectField getPrimaryTargetField() {
		return PRIMARY_TARGET_FIELD;
	}

	public XFTY_DummySObjectMasterTemplate getMasterTemplate() {
		return COMPANY_TEMPLATE;
	}

	// Only first record will be checked; mixed bundles NOT currently supported.
	public XFTY_DummySObjectBundle createBundle(
			List<SObject> templateSObjectList,
			XFTY_InsertModeEnum insertMode,
			XFTY_InsertInclusivityEnum inclusivity
	) {
		return XFTY_DummySObjectFactory.createBundle(COMPANY_TEMPLATE, templateSObjectList, insertMode, inclusivity);
	}
}