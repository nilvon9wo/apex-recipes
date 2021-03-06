/**
 * Inspired by and derived from FinancialForce.com's Apex Commons.
 * @see: https://github.com/financialforcedev/fflib-apex-common/blob/master/fflib/src/classes/fflib_QueryFactoryTest.cls
 */
@IsTest
private class XAP_DAO_SOQL_QueryFactoryTest {
	private static final XAP_DAO_SOQL_WHERE_ClauseIntf TEST_WHERE_EQUALS_CLAUSE
			= new XAP_DAO_SOQL_WHERE_StringCompareClause(
					'name', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS, '\'test\''
			);

	private static final XAP_DAO_SOQL_WHERE_ClauseIntf TEST_WHERE_LIKE_CLAUSE
			= new XAP_DAO_SOQL_WHERE_StringCompareClause(
					'name', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.IS_LIKE, '\'%test%\''
			);
	private static final XAP_DAO_SOQL_WHERE_StringCompareClause TEST_WHERE_NOT_DELETED_CLAUSE
			= new XAP_DAO_SOQL_WHERE_StringCompareClause(
					'IsDeleted', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS, 'false'
			);
	private static final XAP_DAO_SOQL_WHERE_StringCompareClause TEST_WHERE_ID_CLAUSE_1
			= new XAP_DAO_SOQL_WHERE_StringCompareClause(
					'id', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS, '12345'
			);
	private static final XAP_DAO_SOQL_WHERE_StringCompareClause TEST_WHERE_ID_CLAUSE_2
			= new XAP_DAO_SOQL_WHERE_StringCompareClause(
					'id', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS, '54321'
			);

	@IsTest
	static void fieldSelections() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('firstName');
		queryFactory.addField(Contact.SObjectType.fields.LastName);
		queryFactory.addFields(new Set<String>{
				'acCounTId', 'account.name'
		});
		queryFactory.addFields(new List<String>{
				'homePhonE', 'fAX'
		});
		queryFactory.addFields(new List<SObjectField>{
				Contact.Email, Contact.Title
		});
		System.assertEquals(new Set<String>{
				'FirstName',
				'LastName',
				'AccountId',
				'Account.Name',
				'HomePhone',
				'Fax',
				'Email',
				'Title'
		},
				queryFactory.getSelectedFields());
	}

	@IsTest
	static void simpleFieldSelection() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('NAMe').addFields(new Set<String>{
				'naMe', 'email'
		});
		String query = queryFactory.toSOQL();
		System.assert(Pattern.matches('SELECT.*Name.*FROM.*', query), 'Expected Name field in query, got ' + query);
		System.assert(Pattern.matches('SELECT.*Email.*FROM.*', query), 'Expected Name field in query, got ' + query);
		queryFactory.setLimit(100);
		System.assertEquals(100, queryFactory.getLimit());
		System.assert(
				queryFactory.toSOQL()
						.endsWithIgnoreCase('LIMIT ' + queryFactory.getLimit()),
				'Failed to respect limit clause:' + queryFactory.toSOQL()
		);
	}

	@IsTest
	static void simpleFieldCondition() {
		XAP_DAO_SOQL_WHERE_ClauseIntf whereClause = TEST_WHERE_EQUALS_CLAUSE;
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		queryFactory.addField('email');
		queryFactory.setCondition(whereClause);
		System.assertEquals(whereClause, queryFactory.getCondition());
		String query = queryFactory.toSOQL();
		System.assert(
				query.endsWith('WHERE name = \'test\''), 'Query should have ended with a filter on name, got: ' + query
		);
	}

	@IsTest
	static void duplicateFieldSelection() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('NAMe').addFields(new Set<String>{
				'naMe', 'email'
		});
		String query = queryFactory.toSOQL();
		System.assertEquals(1, query.countMatches('Name'), 'Expected one name field in query: ' + query);
	}

	@IsTest
	static void equalityCheck() {
		XAP_DAO_SOQL_QueryFactory queryFactory1 = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		XAP_DAO_SOQL_QueryFactory queryFactory2 = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		System.assertEquals(queryFactory1, queryFactory2);
		queryFactory1.addField('name');
		System.assertNotEquals(queryFactory1, queryFactory2);
		queryFactory2.addField('NAmE');
		System.assertEquals(queryFactory1, queryFactory2);
		queryFactory1.addField('name').addFields(new Set<String>{
				'NAME', 'name'
		}).addFields(new Set<SObjectField>{
				Contact.Name, Contact.Name
		});
		System.assertEquals(queryFactory1, queryFactory2);
	}

	@IsTest
	static void nonReferenceField() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		XAP_DAO_SOQL_NonReferenceFieldException e;
		try {
			queryFactory.addField('name.title');
		}
		catch (XAP_DAO_SOQL_NonReferenceFieldException ex) {
			e = ex;
		}
		System.assertNotEquals(null, e,
				'Cross-object notation on a non-reference field should throw NonReferenceFieldException.'
		);
	}

	@IsTest
	static void invalidCrossObjectField() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		XAP_DAO_SOQL_InvalidFieldException e;
		try {
			queryFactory.addField('account.NOT_A_REAL_FIELD');
		}
		catch (XAP_DAO_SOQL_InvalidFieldException ex) {
			e = ex;
		}
		System.assertNotEquals(null, e,
				'Cross-object notation on a non-reference field should throw NonReferenceFieldException.'
		);
	}

	@IsTest
	static void invalidFieldTests() {
		List<XAP_DAO_SOQL_InvalidFieldException> exceptions = new List<XAP_DAO_SOQL_InvalidFieldException>();
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		try {
			queryFactory.addField('Not_a_field');
		}
		catch (XAP_DAO_SOQL_InvalidFieldException e) {
			exceptions.add(e);
		}
		try {
			queryFactory.addFields(new Set<String>{
					'Not_a_field', 'alsoNotreal'
			});
		}
		catch (XAP_DAO_SOQL_InvalidFieldException e) {
			exceptions.add(e);
		}
		try {
			queryFactory.addFields(new Set<SObjectField>{
					null
			});
		}
		catch (XAP_DAO_SOQL_InvalidFieldException e) {
			exceptions.add(e);
		}
		try {
			queryFactory.addFields(new List<SObjectField>{
					null, Contact.title
			});
		}
		catch (XAP_DAO_SOQL_InvalidFieldException e) {
			exceptions.add(e);
		}
		System.assertEquals(4, exceptions.size());
	}

	@IsTest
	static void ordering() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		queryFactory.addField('email');
		queryFactory.setCondition(TEST_WHERE_EQUALS_CLAUSE);
		queryFactory.addOrdering(new XAP_DAO_SOQL_QuerySortOrdering(
				'Contact',
				'name',
				XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING
		))
				.addOrdering(new XAP_DAO_SOQL_QuerySortOrdering(
				'Contact',
				'CreatedDATE',
				XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING
		));
		String query = queryFactory.toSOQL();

		System.assertEquals(2, queryFactory.getOrderings().size());
		System.assertEquals('Name', queryFactory.getOrderings()[0].getField());
		System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, queryFactory.getOrderings()[1].getDirection());

		System.assert(Pattern.matches('SELECT.*Name.*FROM.*', query), 'Expected Name field in query, got ' + query);
		System.assert(Pattern.matches('SELECT.*Email.*FROM.*', query), 'Expected Name field in query, got ' + query);
	}

	@IsTest
	static void setOrdering_ReplacesPreviousOrderingsWithExpectedOrdering() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		queryFactory.addField('email');
		queryFactory.setCondition(TEST_WHERE_EQUALS_CLAUSE);

		//test base method with ordeting by OwnerId Descending
		queryFactory.setOrdering(
				new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'OwnerId', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING)
		);

		System.assertEquals(1, queryFactory.getOrderings().size(),
				'Unexpected order size - setOrder should replace default Orderings'
		);
		System.assertEquals(Contact.OwnerId.getDescribe().getName(), queryFactory.getOrderings()[0].getField(),
				'Unexpected order field - should have been resolved from the field OwnerId'
		);
		System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, queryFactory.getOrderings()[0].getDirection(),
				'Unexpected order direction.'
		);

		//test method overload with ordering by LastModifiedDate Ascending
		queryFactory.setOrdering('LastModifiedDate', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING, true);

		System.assertEquals(1, queryFactory.getOrderings().size(),
				'Unexpected order size - setOrder should replace previous Orderings'
		);
		System.assertEquals(Contact.LastModifiedDate.getDescribe().getName(), queryFactory.getOrderings()[0].getField(),
				'Unexpected order field - should have been resolved from the field LastModifiedDate'
		);
		System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING, queryFactory.getOrderings()[0].getDirection(),
				'Unexpected order direction.'
		);

		//test method overload with ordering by CreatedDate Descending
		queryFactory.setOrdering(Contact.CreatedDate, XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);

		System.assertEquals(1, queryFactory.getOrderings().size(),
				'Unexpected order size - setOrder should replace previous Orderings'
		);
		System.assertEquals(Contact.CreatedDate.getDescribe().getName(), queryFactory.getOrderings()[0].getField(),
				'Unexpected order field - should have been resolved from the field CreatedDate'
		);
		System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, queryFactory.getOrderings()[0].getDirection(),
				'Unexpected order direction.'
		);

		//test method overload with ordering by CreatedBy.Name Descending
		queryFactory.setOrdering('CreatedBy.Name', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);

		System.assertEquals(1, queryFactory.getOrderings().size(),
				'Unexpected order size - setOrder should replace previous Orderings'
		);
		System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, queryFactory.getOrderings()[0].getDirection(),
				'Unexpected order direction.'
		);

		//test method overload with ordering by Birthdate Ascending
		queryFactory.setOrdering(Contact.Birthdate, XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING);

		System.assertEquals(1, queryFactory.getOrderings().size(),
				'Unexpected order size - setOrder should replace previous Orderings'
		);
		System.assertEquals(Contact.Birthdate.getDescribe().getName(), queryFactory.getOrderings()[0].getField(),
				'Unexpected order field - should have been resolved from the field Birthdate'
		);
		System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING, queryFactory.getOrderings()[0].getDirection(),
				'Unexpected order direction.'
		);
	}

	@IsTest
	static void invalidField_string() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		Exception e;
		try {
			queryFactory.addField('not_a__field');
		}
		catch (XAP_DAO_SOQL_InvalidFieldException ex) {
			e = ex;
		}
		System.assertNotEquals(null, e);
	}

	@IsTest
	static void invalidFields_string() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		Exception e;
		try {
			queryFactory.addFields(new List<String>{
					'not_a__field'
			});
		}
		catch (XAP_DAO_SOQL_InvalidFieldException ex) {
			e = ex;
		}
		System.assertNotEquals(null, e);
	}

	@IsTest
	static void invalidField_nullToken() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		Exception e;
		SObjectField token = null;
		try {
			queryFactory.addField(token);
		}
		catch (XAP_DAO_SOQL_InvalidFieldException ex) {
			e = ex;
		}
		System.assertNotEquals(null, e);
	}

	@IsTest
	static void invalidFields_nullToken() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		Exception e;
		List<SObjectField> token = new List<SObjectField>{
				null
		};
		try {
			queryFactory.addFields(token);
		}
		catch (XAP_DAO_SOQL_InvalidFieldException ex) {
			e = ex;
		}
		System.assertNotEquals(null, e);
	}

	@IsTest
	static void addChildQueriesWithChildRelationship_success() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		Task tsk = new Task();
		tsk.WhoId = cont.Id;
		tsk.Subject = 'test';
		tsk.ActivityDate = System.today();
		insert tsk;

		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name')
				.addField('Id')
				.setCondition(TEST_WHERE_LIKE_CLAUSE)
				.addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
		//explicitly assert object accessibility when creating the subselect
		queryFactory.subselectQuery('Tasks', true)
				.addField('Id')
				.addField('Subject')
				.setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
		List<XAP_DAO_SOQL_QueryFactory> queries = queryFactory.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = queryFactory.query();
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@IsTest
	static void addChildQueriesWithChildRelationshipNoAccessibleCheck_success() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		Task tsk = new Task();
		tsk.WhoId = cont.Id;
		tsk.Subject = 'test';
		tsk.ActivityDate = System.today();
		insert tsk;

		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name')
				.addField('Id')
				.setCondition(TEST_WHERE_LIKE_CLAUSE)
				.addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
		//explicitly assert object accessibility when creating the subselect
		queryFactory.subselectQuery('Tasks')
				.addField('Id')
				.addField('Subject')
				.setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
		List<XAP_DAO_SOQL_QueryFactory> queries = queryFactory.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = queryFactory.query();
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@IsTest
	static void addChildQueriesWithChildRelationshipObjCheckIsAccessible_success() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		Task tsk = new Task();
		tsk.WhoId = cont.Id;
		tsk.Subject = 'test';
		tsk.ActivityDate = System.today();
		insert tsk;

		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory
				.addField('name')
				.addField('Id')
				.setCondition(TEST_WHERE_LIKE_CLAUSE)
				.addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
		DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
		ChildRelationship relationship;
		for (ChildRelationship childRow : descResult.getChildRelationships()) {
			//occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.
			//if there is no relationship name, we cannot query on it, so throw an exception.
			if (childRow.getRelationshipName() == 'Tasks') {
				relationship = childRow;
			}
		}
		//explicitly assert object accessibility when creating the subselect
		queryFactory.subselectQuery(relationship, true)
				.addField('Id')
				.addField('Subject')
				.setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
		List<XAP_DAO_SOQL_QueryFactory> queries = queryFactory.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = queryFactory.query();
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@IsTest
	static void addChildQueriesWithChildRelationshipObj_success() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		Task tsk = new Task();
		tsk.WhoId = cont.Id;
		tsk.Subject = 'test';
		tsk.ActivityDate = System.today();
		insert tsk;

		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory
				.addField('name')
				.addField('Id')
				.setCondition(TEST_WHERE_LIKE_CLAUSE)
				.addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
		DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
		ChildRelationship relationship;
		for (ChildRelationship childRow : descResult.getChildRelationships()) {
			//occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.
			//if there is no relationship name, we cannot query on it, so throw an exception.
			if (childRow.getRelationshipName() == 'Tasks') {
				relationship = childRow;
			}
		}
		//explicitly assert object accessibility when creating the subselect
		queryFactory.subselectQuery(relationship)
				.addField('Id')
				.addField('Subject')
				.setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
		List<XAP_DAO_SOQL_QueryFactory> queries = queryFactory.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = queryFactory.query();
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@IsTest
	static void addChildQueriesWithChildRelationshipNoAccessibleCheck_fail() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		Task tsk = new Task();
		tsk.WhoId = cont.Id;
		tsk.Subject = 'test';
		tsk.ActivityDate = System.today();
		insert tsk;

		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name')
				.addField('Id')
				.setCondition(TEST_WHERE_LIKE_CLAUSE)
				.addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
		//explicitly assert object accessibility when creating the subselect
		//
		Exception e;
		try {
			queryFactory.subselectQuery('Tas')
					.addField('Id')
					.addField('Subject')
					.setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
		}
		catch (XAP_DAO_SOQL_InvalidSubqueryException ex) {
			e = ex;
		}
		System.assertNotEquals(e, null);
	}

	@IsTest
	static void addChildQueries_success() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		Task tsk = new Task();
		tsk.WhoId = cont.Id;
		tsk.Subject = 'test';
		tsk.ActivityDate = System.today();
		insert tsk;

		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name')
				.addField('Id')
				.setCondition(TEST_WHERE_LIKE_CLAUSE)
				.addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
		//explicitly assert object accessibility when creating the subselect
		queryFactory.subselectQuery(Task.SObjectType, true)
				.addField('Id')
				.addField('Subject')
				.setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
		List<XAP_DAO_SOQL_QueryFactory> queries = queryFactory.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = queryFactory.query();
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@IsTest
	static void addChildQuerySameRelationshipAgain_success() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		Task tsk = new Task();
		tsk.WhoId = cont.Id;
		tsk.Subject = 'test';
		tsk.ActivityDate = System.today();
		insert tsk;
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		queryFactory.addField('Id');
		queryFactory.setCondition(TEST_WHERE_LIKE_CLAUSE);
		queryFactory.addOrdering(
				new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
		)
				.addOrdering('CreatedBy.Name', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);
		DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
		ChildRelationship relationship;
		for (ChildRelationship childRow : descResult.getChildRelationships()) {
			if (childRow.getRelationshipName() == 'Tasks') {
				relationship = childRow;
			}
		}
		System.assert(queryFactory.getSubselectQueries() == null);
		XAP_DAO_SOQL_QueryFactory childQf = queryFactory.subselectQuery(Task.SObjectType);
		childQf.assertIsAccessible();
		childQf.setEnforceFLS(true);
		childQf.addField('Id');
		queryFactory.subselectQuery(Task.SObjectType);
		List<XAP_DAO_SOQL_QueryFactory> queries = queryFactory.getSubselectQueries();
		System.assert(queries != null);
		System.assert(queries.size() == 1);
	}

	@IsTest
	static void addChildQueries_invalidChildRelationship() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		queryFactory.addField('email');
		queryFactory.setCondition(TEST_WHERE_LIKE_CLAUSE);
		queryFactory.addOrdering(
				new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
		)
				.addOrdering('CreatedDATE', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);
		Exception e;
		try {
			SObjectType invalidType = null;
			XAP_DAO_SOQL_QueryFactory childQf = queryFactory.subselectQuery(invalidType);
			childQf.addField('Id');
		}
		catch (XAP_DAO_SOQL_InvalidSubqueryException ex) {
			e = ex;
		}
		System.assertNotEquals(e, null);
	}

	@IsTest
	static void addChildQueries_invalidChildRelationshipTooDeep() {
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.addField('name');
		queryFactory.addField('email');
		queryFactory.setCondition(TEST_WHERE_LIKE_CLAUSE);
		queryFactory.addOrdering(
				new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
		)
				.addOrdering('CreatedDATE', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);

		XAP_DAO_SOQL_QueryFactory childQf = queryFactory.subselectQuery(Task.SObjectType);
		childQf.addField('Id');
		childQf.addField('Subject');
		Exception e;
		try {
			childQf.subselectQuery(Task.SObjectType);
		}
		catch (XAP_DAO_SOQL_InvalidSubqueryException ex) {
			e = ex;
		}
		System.assertNotEquals(e, null);
	}

	@IsTest
	static void checkFieldObjectReadSort_success() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.assertIsAccessible()
				.setEnforceFLS(true)
				.addField('createdby.name')
				.addField(Contact.LastModifiedById)
				.addFields(new List<SObjectField>{
				Contact.LastModifiedDate
		})
				.setEnforceFLS(false)
				.addField(Contact.LastName)
				.addFields(new List<SObjectField>{
				Contact.Id
		})
				.setCondition(TEST_WHERE_LIKE_CLAUSE)
				.setEnforceFLS(true)
				.addFields(new Set<SObjectField>{
				Contact.FirstName
		})
				.addOrdering(
				new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
		)
				.addOrdering(Contact.LastModifiedDate, XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING)
				.addOrdering(Contact.CreatedDate, XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
		Set<String> fields = queryFactory.getSelectedFields();
		XAP_DAO_SOQL_QuerySortOrdering ordering
				= new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING);
		System.assertEquals('Name', ordering.getField());

		System.assertEquals(new Set<String>{
				'CreatedBy.Name',
				'LastModifiedById',
				'LastModifiedDate',
				'LastName',
				'Id',
				'FirstName'
		},
				fields);

		System.assert(queryFactory.toSOQL().containsIgnoreCase('NULLS LAST'));
	}

	@IsTest
	static void checkObjectRead_fail() {
		User usr = createTestUser_noAccess();
		if (usr != null) {
			System.runAs(usr) {
				//create a query factory object for Account.
				XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Account.SObjectType);
				Boolean excThrown = false;
				try {
					//check to see if this record is accessible, it isn't.
					queryFactory.assertIsAccessible();
				}
				catch (XAP_DAO_SOQL_SObjectReadException e) {
					excThrown = true;
				}
				System.assert(excThrown);
			}
		}
	}

	@IsTest
	static void checkFieldRead_fail() {
		User usr = createTestUser_noAccess();
		if (usr != null) {
			System.runAs(usr) {
				//create a query factory object for Account.
				XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Account.SObjectType);
				Boolean excThrown = false;
				try {
					//set field to enforce FLS, then try to add a field.
					queryFactory.setEnforceFLS(true);
					queryFactory.addField('Name');
				}
				catch (XAP_DAO_SOQL_FieldLevelSecurityException e) {
					excThrown = true;
				}
				System.assert(excThrown);
			}
		}
	}

	@IsTest
	static void queryWith_noFields() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType);
		queryFactory.assertIsAccessible()
				.setEnforceFLS(true)
				.setCondition(TEST_WHERE_LIKE_CLAUSE)
				.addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);
		String query = queryFactory.toSOQL();
		System.assert(
				query.containsIgnoreCase('SELECT Id FROM Contact'),
				'Expected \'SELECT Id FROM Contact\' in the SOQL, found: ' + query
		);
	}

	@IsTest
	static void deterministic_toSOQL() {
		XAP_DAO_SOQL_QueryFactory queryFactory1 = new XAP_DAO_SOQL_QueryFactory(User.SObjectType);
		XAP_DAO_SOQL_QueryFactory queryFactory2 = new XAP_DAO_SOQL_QueryFactory(User.SObjectType);
		for (XAP_DAO_SOQL_QueryFactory queryFactory : new Set<XAP_DAO_SOQL_QueryFactory>{
				queryFactory1, queryFactory2
		}) {
			queryFactory.addFields(new List<String>{
					'Id',
					'FirstName',
					'LastName',
					'CreatedBy.Name',
					'CreatedBy.Manager',
					'LastModifiedBy.Email'
			});
		}
		String expectedQuery =
				'SELECT CreatedBy.ManagerId, CreatedBy.Name, '
						+ 'FirstName, Id, LastModifiedBy.Email, LastName '
						+ 'FROM User';
		System.assertEquals(queryFactory1.toSOQL(), queryFactory2.toSOQL());
		System.assertEquals(expectedQuery, queryFactory1.toSOQL());
		System.assertEquals(expectedQuery, queryFactory2.toSOQL());
	}

	@IsTest
	static void deepCloneBasicNoChanges() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType)
				.setLimit(10)
				.setCondition(TEST_WHERE_ID_CLAUSE_1)
				.addField('Description')
				.addOrdering(
						new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
				)
				.addOrdering(
						new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'CreatedDATE', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING)
				)
				.setEnforceFLS(true);

		XAP_DAO_SOQL_QueryFactory queryFactory2 = queryFactory.deepClone();

		System.assertEquals(queryFactory2, queryFactory);

		System.assertEquals(queryFactory.getLimit(), queryFactory2.getLimit());
		System.assertEquals(queryFactory.getCondition(), queryFactory2.getCondition());
		System.assertEquals(queryFactory.toSOQL(), queryFactory2.toSOQL());
		System.assertEquals(queryFactory.getOrderings(), queryFactory2.getOrderings());
	}

	@IsTest
	static void deepCloneSubqueryNoChanges() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Account.SObjectType)
				.setLimit(10)
				.setCondition(TEST_WHERE_ID_CLAUSE_1)
				.addField('Description')
				.addOrdering(
						new XAP_DAO_SOQL_QuerySortOrdering('Account', 'Name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
				)
				.addOrdering(
						new XAP_DAO_SOQL_QuerySortOrdering('Account', 'Description', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING)
				)
				.setEnforceFLS(true);

		queryFactory.subselectQuery('Contacts', true);

		XAP_DAO_SOQL_QueryFactory queryFactory2 = queryFactory.deepClone();

		System.assertEquals(queryFactory, queryFactory2);

		System.assertEquals(queryFactory.getLimit(), queryFactory2.getLimit());
		System.assertEquals(queryFactory.getCondition(), queryFactory2.getCondition());
		System.assertEquals(queryFactory.toSOQL(), queryFactory2.toSOQL());
		System.assertEquals(queryFactory.getOrderings(), queryFactory2.getOrderings());
		System.assertEquals(queryFactory.getSubselectQueries(), queryFactory2.getSubselectQueries());
	}

	@IsTest
	static void deepCloneBasic() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Contact.SObjectType)
				.setLimit(10)
				.setCondition(TEST_WHERE_ID_CLAUSE_1)
				.addField('Description')
				.addOrdering(
						new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
				)
				.addOrdering(
						new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'CreatedDATE', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING)
				)
				.setEnforceFLS(true);

		XAP_DAO_SOQL_QueryFactory queryFactory2 = queryFactory.deepClone()
				.setLimit(200)
				.setCondition(TEST_WHERE_ID_CLAUSE_2)
				.addField('Fax')
				.addOrdering(
						new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'Fax', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
				)
				.setEnforceFLS(false);

		queryFactory2.getOrderings().remove(0);

		System.assertEquals(10, queryFactory.getLimit());
		System.assertEquals(200, queryFactory2.getLimit());

		System.assertEquals(TEST_WHERE_ID_CLAUSE_1, queryFactory.getCondition());
		System.assertEquals(TEST_WHERE_ID_CLAUSE_2, queryFactory2.getCondition());

		String query = queryFactory.toSOQL();
		String query2 = queryFactory2.toSOQL();

		System.assert(query.containsIgnoreCase('Fax') == false);
		System.assert(query.containsIgnoreCase('Description'));
		System.assert(query2.containsIgnoreCase('Description'));
		System.assert(query2.containsIgnoreCase('Fax'));

		System.assertEquals(2, queryFactory.getOrderings().size());
		System.assertEquals('Name', queryFactory.getOrderings()[0].getField());
		System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, queryFactory.getOrderings()[1].getDirection());

		System.assertEquals(2, queryFactory2.getOrderings().size());
		System.assertEquals('Fax', queryFactory2.getOrderings()[1].getField());
		System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING, queryFactory2.getOrderings()[1].getDirection());

	}

	@IsTest
	static void deepCloneSubquery() {
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(Account.SObjectType);
		queryFactory.subselectQuery('Contacts', true);

		XAP_DAO_SOQL_QueryFactory queryFactory2 = queryFactory.deepClone();
		queryFactory2.subselectQuery('Opportunities', true);

		List<XAP_DAO_SOQL_QueryFactory> subqueries = queryFactory.getSubselectQueries();
		List<XAP_DAO_SOQL_QueryFactory> subqueries2 = queryFactory2.getSubselectQueries();

		XAP_DAO_SOQL_QueryFactory subquery2_0 = subqueries2.get(0);

		subquery2_0.addOrdering(
				new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'Name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
		);

		System.assert(subqueries.size() == 1);
		System.assert(subqueries2.size() == 2);

		System.assert(queryFactory.getSubselectQueries().get(0).getOrderings().size() == 0);
		System.assert(queryFactory2.getSubselectQueries().get(0).getOrderings().size() == 1);
	}

	@IsTest
	static void testSoql_unsortedSelectFields() {
		//Given
		XAP_DAO_SOQL_QueryFactory queryFactory = new XAP_DAO_SOQL_QueryFactory(User.SObjectType);
		queryFactory.addFields(new List<String>{
				'Id',
				'FirstName',
				'LastName',
				'CreatedBy.Name',
				'CreatedBy.Manager',
				'LastModifiedBy.Email'
		});

		queryFactory.setSortSelectFields(false);

		String orderedQuery =
				'SELECT '
						+ 'FirstName, Id, LastName, ' //less joins come first, alphabetically
						+ 'CreatedBy.ManagerId, CreatedBy.Name, LastModifiedBy.Email ' //alphabetical on the same number of joins'
						+ 'FROM User';

		//When
		String actualSoql = queryFactory.toSOQL();

		//Then
		System.assertNotEquals(orderedQuery, actualSoql);
	}

	public static User createTestUser_noAccess() {
		User usr;
		try {
			//look for a profile that does not have access to the Account object
			PermissionSet ps = [
					SELECT Profile.Id, Profile.Name
					FROM PermissionSet
					WHERE IsOwnedByProfile = TRUE
							AND Profile.UserType = 'Standard'
							AND Id NOT IN (
									SELECT ParentId
									FROM ObjectPermissions
									WHERE SobjectType = 'Account'
											AND PermissionsRead = TRUE
							)
					LIMIT 1
			];

			if (ps != null) {
				//create a user with the profile found that doesn't have access to the Account object
				usr = new User(
						FirstName = 'testUsrF',
						LastName = 'testUsrL',
						Alias = 'tstUsr',
						Email = 'testy.test@test.com',
						Username = 'test' + Math.random().format() + 'user99@test.com',
						EmailEncodingKey = 'ISO-8859-1',
						LanguageLocaleKey = 'en_US',
						TimeZoneSidKey = 'America/Los_Angeles',
						LocaleSidKey = 'en_US',
						ProfileId = ps.Profile.Id,
						IsActive = true
				);
				insert usr;
			}
		}
		catch (Exception e) {
			//do nothing, just return null User because this test case won't work in this org.
			return null;
		}
		return usr;
	}
}