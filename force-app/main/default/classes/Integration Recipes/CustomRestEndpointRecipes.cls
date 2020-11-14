@SuppressWarnings('PMD.CyclomaticComplexity')
@RestResource(UrlMapping='/IntegrationService/*')
global inherited sharing class CustomRestEndpointRecipes {
    private DAO_AccountSelector accountSelector;
    private DAO_ContactSelector contactSelector;
    private XAP_DAO_DML_SecureDml dml;
    private XAP_DAO_DML_SecurityUtils securityUtils;

    public CustomRestEndpointRecipes(
            DAO_AccountSelector accountSelector,
            DAO_ContactSelector contactSelector,
            XAP_DAO_DML_SecureDml dml,
            XAP_DAO_DML_SecurityUtils securityUtils
    ) {
        this.accountSelector = accountSelector;
        this.contactSelector = contactSelector;
        this.dml = dml;
        this.securityUtils = securityUtils;
    }

    public CustomRestEndpointRecipes() {
        this(
                DAO_AccountSelector.getInstance(),
                DAO_ContactSelector.getInstance(),
                XAP_DAO_DML_SecureDml.getInstance(),
                XAP_DAO_DML_SecurityUtils.getInstance()
        );
    }

    @TestVisible
    private static Exception circuitBreaker;

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @HttpGet
    global static String getRecordsToReturn() {
        return new CustomRestEndpointRecipes()
                .selectAccounts(RestContext.response);
    }

    private String selectAccounts(RestResponse response) {
        List<Account> accounts;
        try {
            if (Test.isRunningTest() && CustomRestEndpointRecipes.circuitBreaker != null) {
                throw CustomRestEndpointRecipes.circuitBreaker;
            }
            accounts = this.accountSelector.secureSelectAll();
        }
        catch (QueryException queryException) {
            return this.respond(response, 400, queryException);
        }

        return this.respond(response, 200, JSON.serialize(accounts));
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @HttpDelete
    global static String deleteSingleContact() {
        return new CustomRestEndpointRecipes()
                .deleteContact(RestContext.request, RestContext.response);
    }

    private String deleteContact(RestRequest request, RestResponse response) {
        try {
            this.securityUtils.checkSObjectIsDeletable(Contact.SObjectType);
        }
        catch (XAP_DAO_DML_CrudException ex) {
            return this.respond(response, 500, 'User does not have permission to delete contacts');
        }

        Id contactId;
        try {
            contactId = request.requestURI.substring(
                    request.requestURI.lastIndexOf('/') + 1
            );
        }
        catch (StringException ex) {
            return this.respond(response, 400, 'Attempt to de-reference a null object');
        }

        try {
            if (Test.isRunningTest() && CustomRestEndpointRecipes.circuitBreaker != null) {
                throw CustomRestEndpointRecipes.circuitBreaker;
            }
            this.doDelete(contactId);
        }
        catch (QueryException queryException) {
            return this.respond(response, 400, queryException);
        }
        catch (DmlException dmlException) {
            return this.respond(response, 400, dmlException);
        }

        return this.respond(response, 200, 'Successful Delete');
    }

    private void doDelete(Id contactId) {
        List<Contact> contactList = this.contactSelector.secureSelectById(new Set<Id>{contactId});
        this.dml.doDelete(contactList);
    }


    @SuppressWarnings('PMD.ApexCRUDViolation')
    @HttpPost
    global static String parseAndCreateNewContacts() {
        return new CustomRestEndpointRecipes()
                .createContact(RestContext.request, RestContext.response);
    }

    private String createContact(RestRequest request, RestResponse response){
        try {
            if (Test.isRunningTest() && CustomRestEndpointRecipes.circuitBreaker != null) {
                throw CustomRestEndpointRecipes.circuitBreaker;
            }
            if (request.requestBody == null || String.isBlank(request.requestBody.toString())) {
                return this.respond(response, 400, 'Argument cannot be null.');
            }
            List<Contact> contactList
                    = (List<Contact>) JSON.deserialize(request.requestBody.toString(), List<Contact>.class);
            try {
                this.dml.doInsert(contactList);
            }
            catch (XAP_DAO_DML_CrudException crudException) {
                return this.respond(response, 500, 'User does not have permission to create Contacts');
            }
        }
        catch (JSONException jsonException) {
            return this.respond(response, 400, jsonException);
        }
        catch (DmlException dmlException) {
            return this.respond(response, 400, dmlException);
        }

        return this.respond(response, 200, 'Successful Insert');
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @HttpPut
    global static String upsertContactRecords() {
        return new CustomRestEndpointRecipes()
                .upsertContact(RestContext.request, RestContext.response);
    }

    private String upsertContact(RestRequest request, RestResponse response) {
        try {
            if (Test.isRunningTest() && CustomRestEndpointRecipes.circuitBreaker != null) {
                throw CustomRestEndpointRecipes.circuitBreaker;
            }
            if (request.requestBody == null || String.isBlank(request.requestBody.toString())) {
                return this.respond(response, 400, 'Argument cannot be null.');
            }
            List<Contact> contactList
                    = (List<Contact>) JSON.deserialize(request.requestBody.toString(), List<Contact>.class);

            try {
                this.dml.doUpsert(contactList, Contact.ExternalSalesforceId__c, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
            }
            catch (XAP_DAO_DML_CrudException crudException) {
                return this.respond(response, 500, 'User does not have create or edit permissions');
            }
        }
        catch (JSONException jsonException) {
            return this.respond(response, 400, jsonException);
        }
        catch (DmlException dmlException) {
            return this.respond(response, 400, dmlException);
        }

        return this.respond(response, 200, 'Successful Upsert');
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @HttpPatch
    global static String updateAccountRecords() {
        return new CustomRestEndpointRecipes()
                .updateAccount(RestContext.request, RestContext.response);
    }

    private String updateAccount(RestRequest request, RestResponse response) {
        try {
            if (Test.isRunningTest() && CustomRestEndpointRecipes.circuitBreaker != null) {
                throw CustomRestEndpointRecipes.circuitBreaker;
            }

            if (request.requestBody == null || String.isBlank(request.requestBody.toString())) {
                return this.respond(response, 400, 'Argument cannot be null.');
            }
            List<Account> accountList
                    = (List<Account>) JSON.deserialize(request.requestBody.toString(), List<Account>.class);

            for (Account account : accountList) {
                account.Id = account.ExternalSalesforceId__c;
                account.Name = account.Name;
                account.Website = account.Website;
            }

            try {
                this.dml.doUpdate(accountList);
            }
            catch (XAP_DAO_DML_CrudException crudException) {
                return this.respond(response, 500, 'User has no edit access to Accounts');
            }
        }
        catch (JSONException jsonException) {
            return this.respond(response, 400, jsonException);
        }
        catch (DmlException dmlException) {
            return this.respond(response, 400, dmlException);
        }

        return this.respond(response, 200, 'Successful Update');

    }

    private String respond(RestResponse response, Integer statusCode, Exception ex) {
        return this.respond(response, statusCode, ex.getMessage());
    }

    private String respond(RestResponse response, Integer statusCode, String message) {
        System.debug(LoggingLevel.ERROR, 'Failure: ' + message);
        response.statusCode = statusCode;
        return message;
    }

}
