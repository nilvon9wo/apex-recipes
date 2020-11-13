@IsTest
public class XFTY_DummySObjectFactoryOutletLookup {
	private static final Map<SObjectType, Type> OUTLET_TYPE_BY_SOBJECT_TYPE
			= new Map<SObjectType, Type>{
					Account.SObjectType => TEST_DummyAccountFactoryOutlet.class,
//					Account_Update__e.SObjectType => TEST_DummyAccountUpdateFactoryOutlet.class,
//					ApexEmailNotification.SObjectType => TEST_DummyApexEmailNotificationFtyOutlet.class,
//					Appointment__c.SObjectType => TEST_DummyAppointmentFtyOutlet.class,
//					BankData__c.SObjectType => TEST_DummyBankDataFactoryOutlet.class,
					Contact.SObjectType => TEST_DummyContactFactoryOutlet.class,
//					Contract.SObjectType => TEST_DummyContractFactoryOutlet.class,
//					Event.SObjectType => TEST_DummyEventFactoryOutlet.class,
//					Feature_Flags__c.SObjectType => TEST_DummyFeatureFlagsFactoryOutlet.class,
//					FeedItem.SObjectType => TEST_DummyFeedItemFactoryOutlet.class,
//					Group.SObjectType => TEST_DummyGroupFactoryOutlet.class,
//					Lead.SObjectType => TEST_DummyLeadFactoryOutlet.class,
//					Lead_to_Queue_Configuration__c.SObjectType => TEST_DummyLeadToQueueConfigFactoryOutlet.class,
//					Microsoft_Azure_Settings__c.SObjectType => TEST_DummyMicrosoftAzureSettingsFtyOutlt.class,
//					OperatingHours.SObjectType => TEST_DummyOperatingHoursFactoryOutlet.class,
//					Opportunity.SObjectType => TEST_DummyOpportunityFactoryOutlet.class,
//					OpportunityLineItem.SObjectType => TEST_DummyOpportunityLineItemFtyOutlet.class,
//					Opportunity_Settings__c.SObjectType => TEST_DummyOpportunitySettingsFtyOutlet.class,
//					OrgWideEmailAddress.SObjectType => TEST_DummyOrgWideEmailAddressFtyOutlet.class,
//					PricebookEntry.SObjectType => TEST_DummyPricebookEntryFactoryOutlet.class,
//					Pricebook2.SObjectType => TEST_DummyPricebook2FactoryOutlet.class,
//					Product2.SObjectType => TEST_DummyProduct2FactoryOutlet.class,
//					Sandbox_Configuration__mdt.SObjectType => TEST_DummySandboxConfigurationFtyOutlet.class,
//					Service_Provider__c.SObjectType => TEST_DummyServiceProviderFtyOutlet.class,
//					ServiceResource.SObjectType => TEST_DummyServiceResourceFtyOutlet.class,
//					ServiceTerritory.SObjectType => TEST_DummyServiceTerritoryFtyOutlet.class,
//					ServiceTerritoryMember.SObjectType => TEST_DummyServiceTerritoryMbrFtyOutlet.class,
//					SPV__c.SObjectType => TEST_DummySpvFtyOutlet.class,
//					StaticResource.SObjectType => TEST_DummyStaticResourceFactoryOutlet.class,
//					Task.SObjectType => TEST_DummyTaskFactoryOutlet.class,
//					Twilio_Configuration__c.SObjectType => TEST_DummyTwilioConfigurationFtyOutlet.class,
					User.SObjectType => TEST_DummyUserFactoryOutlet.class
//					WorkOrder.SObjectType => TEST_DummyWorkOrderFactoryOutlet.class,
//					WorkType.SObjectType => TEST_DummyWorkTypeFactoryOutlet.class,
//					Work_Type_Line_Item__c.SObjectType => TEST_DummyWorkTypeLineItemTypeFtyOutlet.class,
//					XAP_TRIG_TriggerSetting__c.SObjectType => TEST_DummyXapTriggerSettingFactoryOutlet.class,
//					Zip_code_Area__c.SObjectType => TEST_DummyZipCodeAreaFactoryOutlet.class,
//					Zip_Code_Relation__c.SObjectType => TEST_DummyZipCodeRelationFactoryOutlet.class
			};

	private static final Map<SObjectType, XFTY_DummySobjectFactoryOutletIntf> OUTLET_INSTANCE_BY_SOBJECT_TYPE
			= new Map<SObjectType, XFTY_DummySobjectFactoryOutletIntf>();

	public static XFTY_DummySobjectFactoryOutletIntf get(SObjectType sObjectType) {
		if (!OUTLET_INSTANCE_BY_SOBJECT_TYPE.containsKey(sObjectType)) {
			if (!(OUTLET_TYPE_BY_SOBJECT_TYPE.containsKey(sObjectType))) {
				new LookupException('No factory outlet found for : ' + sObjectType);
			}
			OUTLET_INSTANCE_BY_SOBJECT_TYPE.put(
					sObjectType,
					(XFTY_DummySobjectFactoryOutletIntf) (OUTLET_TYPE_BY_SOBJECT_TYPE.get(sObjectType)).newInstance()
			);
		}
		return OUTLET_INSTANCE_BY_SOBJECT_TYPE.get(sObjectType);
	}

	// --------------------------------------------------------------------------

	public class LookupException extends Exception {
	}
}