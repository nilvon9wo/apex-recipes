public inherited sharing class AccountServiceLayer {
    private CanTheUser canUser;

    public AccountServiceLayer(CanTheUser canUser) {
        this.canUser = canUser;
    }

    public AccountServiceLayer() {
        this(new CanTheUser());
    }

    @TestVisible
    private static String didExecuteMethod;

    public static void justWriteALogStatement(String toLog) {
        AccountServiceLayer.didExecuteMethod = toLog;
        System.debug(
            LoggingLevel.INFO,
            'Account id = and log statement = ' + toLog
        );
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public static void changeShippingStreet(List<Account> accounts) {
        new AccountServiceLayer()
                .changeShipStreet(accounts);
    }

    private void changeShipStreet(List<Account> accounts) {
        List<Account> updated = new List<Account>();
        for (Account account : accounts) {
            Account uAcct = account.clone(true);
            uAcct.ShippingStreet = '229b Baker st.';
            updated.add(uAcct);
        }
        if (
                this.canUser.edit(updated[0]) &&
                        this.canUser.flsUpdatable('Account', 'shippingStreet')
                ) {
            update updated;
        } else {
            throw new CanTheUserException(
                    'User has no permission to edit accounts'
            );
        }
    }

    public static List<Account> incrementCounterInDescription(
        List<Account> incomingAccounts,
        Boolean save
    ) {
        for (Account ia : incomingAccounts) {
            Integer counter = 0;
            try {
                if (ia.Description != null) {
                    counter = Integer.valueOf(ia.Description);
                }
            } catch (System.TypeException te) {
                System.debug(
                    LoggingLevel.INFO,
                    'failed safely to 0 during init'
                );
            }
            counter++;
            ia.Description = String.valueOf(counter);
        }
        if (save) {
            safelySave(incomingAccounts);
        }
        return incomingAccounts;
    }

    @TestVisible
    private static void safelySave(List<Account> accounts) {
        try {
            System.SObjectAccessDecision decision = Security.stripInaccessible(
                AccessType.UPDATABLE,
                accounts
            );
            update decision.getRecords();
        } catch (DmlException dmle) {
            System.debug(
                LoggingLevel.INFO,
                'Hey, a DML error occurred while updating.'
            );
            throw new ASLException(dmle.getMessage());
        } catch (System.NoAccessException nae) {
            throw new ASLException(nae.getMessage());
        }
    }
}
