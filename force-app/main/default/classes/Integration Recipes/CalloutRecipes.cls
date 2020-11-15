public inherited sharing class CalloutRecipes {
    String defaultNamedCredential;
    XAP_REST_RestClient restClient;
    XAP_DAO_DML_InheritedSharingDml dml;

    public CalloutRecipes(String namedCredential, XAP_REST_RestClient restClient, XAP_DAO_DML_InheritedSharingDml dml) {
        this.defaultNamedCredential = namedCredential;
        this.restClient = restClient;
        this.dml = dml;
    }

    public CalloutRecipes(String namedCredential) {
        this(namedCredential, XAP_REST_RestClient.getInstance(), XAP_DAO_DML_InheritedSharingDml.getInstance());
    }

    public CalloutRecipes() {
        this((String) null);
    }


    public String rawCallout() {
        XAP_REST_RestRequest restRequest = new XAP_REST_RestRequest()
                .setEndPoint('https://mockbin.org/bin/24d66572-81e6-46bd-986b-610f1b5c4e00/view');

        HttpResponse response = this.restClient.get(restRequest);
        if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
            return response.getBody();
        }

        throw new CalloutRecipesException(response);
    }

    public List<Account> httpGetCalloutToSecondOrg() {
        XAP_REST_RestRequest restRequest = new XAP_REST_RestRequest()
                .setNamedCredential(this.defaultNamedCredential)
                .setPath('services/apexrest/IntegrationService');

        String responseBody = this.restClient.get(restRequest)
                .getBody();
        try {
            List<Account> accountRecords = (List<Account>) JSON.deserialize(
                    responseBody,
                    List<Account>.class
            );
            return accountRecords;
        }
        catch (JSONException e) {
            System.debug(LoggingLevel.ERROR, 'Failed to deserialize the body. Error is: ' + e.getMessage());
        }
        return null;
    }

    public Integer httpDeleteCalloutToSecondOrg(Id contactId) {
        XAP_REST_RestRequest restRequest = new XAP_REST_RestRequest()
                .setNamedCredential(this.defaultNamedCredential)
                .setPath('services/apexrest/IntegrationService/')
                .setQuery('?contactId=' + contactId);

        return this.restClient.del(restRequest)
                .getStatusCode();
    }

    public Integer httpPostCalloutToSecondOrg(List<Contact> contactRecords) {
        try {
            XAP_REST_RestRequest restRequest = new XAP_REST_RestRequest()
                    .setNamedCredential(this.defaultNamedCredential)
                    .setPath('services/apexrest/IntegrationService/')
                    .setBody(JSON.serialize(contactRecords));

            return this.restClient.post(restRequest)
                    .getStatusCode();
        }
        catch (JSONException e) {
            System.debug(LoggingLevel.ERROR, 'Failed to serialize the body. Error is: ' + e.getMessage());
            return null;
        }
    }

    public Integer httpPutCalloutToSecondOrg(List<Contact> contactRecords) {
        try {
            XAP_REST_RestRequest restRequest = new XAP_REST_RestRequest()
                    .setNamedCredential('Second_Org')
                    .setPath('services/apexrest/IntegrationService/')
                    .setBody(JSON.serialize(contactRecords));

            return this.restClient.put(restRequest)
                    .getStatusCode();
        }
        catch (JSONException e) {
            System.debug(LoggingLevel.ERROR, 'Failed to serialize the body. Error is: ' + e.getMessage());
            return null;
        }
    }

    public Integer httpPatchCalloutToSecondOrg(List<Account> accountRecords) {
        try {
            XAP_REST_RestRequest restRequest = new XAP_REST_RestRequest()
                    .setNamedCredential(this.defaultNamedCredential)
                    .setPath('services/apexrest/IntegrationService/')
                    .setBody(JSON.serialize(accountRecords));

            return this.restClient.patch(restRequest)
                    .getStatusCode();
        }
        catch (JSONException e) {
            System.debug(LoggingLevel.ERROR, 'Failed to serialize the body. Error is: ' + e.getMessage());
            return null;
        }
    }

    public Map<String, Object> httpCalloutWithUntypedResponse() {
        XAP_REST_RestRequest restRequest = new XAP_REST_RestRequest()
                .setNamedCredential('ExternalEndpoint')
                .setPath('fakeEndpoint/');

        String responseBody = this.restClient.get(restRequest)
                .getBody();
        try {
            return (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        }
        catch (JSONException e) {
            System.debug(LoggingLevel.ERROR, 'Failed to serialize the body. Error is: ' + e.getMessage());
            return null;
        }
    }

    public void insertAccountAndContactsFromUntypedResponse(String untypedResponse) {
        List<SObject> dataToInsertList = this.buildDataToInsertList((Map<String, Object>) JSON.deserializeUntyped(
                untypedResponse
        ));
        XAP_DAO_DML_SaveResultListWrapper saveResults = this.dml.doInsert(dataToInsertList);
        List<Id> successIdList = new List<Id>();
        List<Id> failureIdList = new List<Id>();
        for (XAP_DAO_DML_ResultWrapperIntf resultWrapper : saveResults.getResultWrapperList()) {
            List<Id> idList = (resultWrapper.isSuccess())
                    ? successIdList
                    : failureIdList;
            idList.add(resultWrapper.getId());
        }
        System.debug(LoggingLevel.ERROR, 'Failures: ' + failureIdList);
    }

    private List<SObject> buildDataToInsertList(Map<String, Object> responseValueByKeyMap) {
        List<SObject> dataToInsertList = new List<SObject>();
        dataToInsertList.add(this.createAccount(responseValueByKeyMap));

        List<Object> contactObjectList = (List<Object>) responseValueByKeyMap.get('Contacts');
        Account referenceAccount = new Account(
                ExternalSalesforceId__c = responseValueByKeyMap.get('Id').toString()
        );
        dataToInsertList.addAll(this.createContactList(contactObjectList, referenceAccount));

        return dataToInsertList;
    }

    private Account createAccount(Map<String, Object> responseValueByKeyMap) {
        return new Account(
                ExternalSalesforceId__c = responseValueByKeyMap.get('Id').toString(),
                Name = responseValueByKeyMap.get('Name').toString(),
                Website = responseValueByKeyMap.get('Website').toString()
        );
    }

    private List<Contact> createContactList(List<Object> contactObjectList, Account referenceAccount) {
        List<Contact> contactList = new List<Contact>();
        for (Object contactObject : contactObjectList) {
            contactList.add(this.createContact((Map<String, Object>) contactObject, referenceAccount));
        }
        return contactList;
    }

    private Contact createContact(Map<String, Object> singleContact, Account referenceAccount) {
        return new Contact(
                FirstName = singleContact.get('FirstName').toString(),
                LastName = singleContact.get('LastName').toString(),
                Email = singleContact.get('Email').toString(),
                Account = referenceAccount
        );
    }
}
