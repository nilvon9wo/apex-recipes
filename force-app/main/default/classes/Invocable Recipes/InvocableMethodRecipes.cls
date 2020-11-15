public inherited sharing class InvocableMethodRecipes {
    private DAO_ContactSelector contactSelector;

    private InvocableMethodRecipes(DAO_ContactSelector contactSelector) {
        this.contactSelector = contactSelector;
    }

    public InvocableMethodRecipes() {
        this(DAO_ContactSelector.getInstance());
    }

    @InvocableMethod(
            Label='Example Invocable Method'
            Description='Example Invocable Method'
    )
    public static List<ContactSearchResult> findRelatedContacts(
            List<ContactSearchRequest> inputParameterList
    ) {
        return new InvocableMethodRecipes()
                .selectRelatedContacts(inputParameterList);
    }

    public List<ContactSearchResult> selectRelatedContacts(
            List<ContactSearchRequest> inputParameterList
    ) {
        SObject input = inputParameterList[0].inputs[0];
        String firstRecordId = input.Id;
        String sObjectType = input.Id.getSobjectType()
                .getDescribe()
                .getName()
                .toLowerCase();

        List<Contact> contactList;
        switch on sObjectType {
            when 'account' {
                contactList = this.contactSelector.secureSelectByAccountId(new Set<Id>{firstRecordId});
            }
            when 'task' {
                contactList = this.contactSelector.secureSelectById(new Set<Id>{((Task) input).WhoId});
            }
            when else {
                throw new InvocableMethodRecipesException(
                        'Unknown object type passed. This method only supports Account and Task.'
                );
            }
        }
        return new List<ContactSearchResult>{
                new ContactSearchResult(contactList[0])
        };
    }
}
