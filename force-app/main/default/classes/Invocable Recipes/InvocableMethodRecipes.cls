public inherited sharing class InvocableMethodRecipes {
    private DAO_ContactSelector contactSelector;
    private XAP_COLL_SObjectValueSetExtractor setExtractor;

    private InvocableMethodRecipes(DAO_ContactSelector contactSelector, XAP_COLL_SObjectValueSetExtractor setExtractor) {
        this.contactSelector = contactSelector;
        this.setExtractor = setExtractor;
    }

    public InvocableMethodRecipes() {
        this(DAO_ContactSelector.getInstance(), XAP_COLL_SObjectValueSetExtractor.getInstance());
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
        List<SObject> sObjectList = new List<SObject>();
        for (ContactSearchRequest request : inputParameterList) {
            for(SObject sObj : request.inputs) {
                sObjectList.add(sObj);
            }
        }

        List<ContactSearchResult> resultList = new List<ContactSearchResult>();
        for (Contact contact : this.selectContactList(sObjectList)) {
            resultList.add(new ContactSearchResult(contact));
        }
        return resultList;
    }

    private List<Contact> selectContactList(List<SObject> sObjectList) {
        try {
            return this.contactSelector.selectFrom(sObjectList);
        }
        catch (DAO_UnsupportedSObjectException unsupportedSObjectException) {
            throw new InvocableMethodRecipesException(
                    unsupportedSObjectException.getMessage()
            );
        }
    }
}
