public inherited sharing class AccountServiceLayer {
    private XAP_DAO_DML_SecureDml dml;

    private AccountServiceLayer(XAP_DAO_DML_SecureDml dml) {
        this.dml = dml;
    }

    private AccountServiceLayer() {
        this(XAP_DAO_DML_SecureDml.getInstance());
    }

    private static AccountServiceLayer instance;
    public static AccountServiceLayer getInstance() {
        if (instance == null) {
            instance = new AccountServiceLayer();
        }
        return instance;
    }

    @TestVisible
    private static String didExecuteMethod;

    public void justWriteALogStatement(String toLog) {
        AccountServiceLayer.didExecuteMethod = toLog;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public void changeShippingStreet(List<Account> accounts) {
        this.changeShipStreet(accounts);
    }

    private void changeShipStreet(List<Account> accountList) {
        List<Account> updatedAccountList = new List<Account>();
        for (Account account : accountList) {
            Account updatedAccount = account.clone(true);
            updatedAccount.ShippingStreet = '229b Baker st.';
            updatedAccountList.add(updatedAccount);
        }

        try {
            this.dml.doUpdate(updatedAccountList);
        }
        catch (XAP_DAO_DML_CrudException crudException) {
            throw new CanTheUserException(
                    'User has no permission to edit accountList'
            );
        }

    }

    public List<Account> incrementCounterInDescription(List<Account> incomingAccountList, Boolean save) {
        for (Account incomingAccount : incomingAccountList) {
            Integer counter = 0;
            try {
                if (incomingAccount.Description != null) {
                    counter = Integer.valueOf(incomingAccount.Description);
                }
            }
            catch (System.TypeException typeException) {
                System.debug(LoggingLevel.WARN, 'failed safely to 0 during init');
            }
            counter++;
            incomingAccount.Description = String.valueOf(counter);
        }
        if (save) {
            this.safelySave(incomingAccountList);
        }
        return incomingAccountList;
    }

    @TestVisible
    private void safelySave(List<Account> accountList) {
        try {
            System.SObjectAccessDecision decision
                    = Security.stripInaccessible(AccessType.UPDATABLE, accountList);
            this.dml.doUpdate(decision.getRecords());
        }
        catch (DmlException dmlException) {
            System.debug(LoggingLevel.ERROR, 'Hey, a DML error occurred while updating.');
            throw new ASLException(dmlException.getMessage());
        }
        catch (System.NoAccessException noAccessException) {
            throw new ASLException(noAccessException.getMessage());
        }
    }
}
