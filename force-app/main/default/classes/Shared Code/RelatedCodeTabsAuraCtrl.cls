public inherited sharing class RelatedCodeTabsAuraCtrl {
    private ApexClassUtilities classUtilities;
    private DAO_ApexClassSelector apexClassSelector;

    private RelatedCodeTabsAuraCtrl(ApexClassUtilities classUtilities, DAO_ApexClassSelector apexClassSelector) {
        this.classUtilities = classUtilities;
        this.apexClassSelector = apexClassSelector;
    }

    public RelatedCodeTabsAuraCtrl() {
        this(new ApexClassUtilities(), DAO_ApexClassSelector.getInstance());
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @AuraEnabled(Cacheable=true)
    public static List<String> getRelatedClasses(String mainClassName) {
        return new RelatedCodeTabsAuraCtrl()
            .selectClasses(mainClassName);
    }

    private List<String> selectClasses(String mainClassName) {
        if (String.isNotBlank(mainClassName)) {
            List<ApexClass> apexClassList = this.apexClassSelector.selectByName(new Set<String>{mainClassName});
            ApexClass klass = (!apexClassList.isEmpty())
                    ? apexClassList[0]
                    : null;

            if (klass == null) {
                throw new QueryException('no rows for assignment');
            }

            if (klass.Body.contains('@see')) {
                return this.selectClasses(klass);
            }
        }

        return new List<String>();
    }

    private List<String> selectClasses(ApexClass klass) {
        String[] relatedClassNameList = this.classUtilities.getRelatedClassesFromClassBody(klass)
                .split(',');

        return this.trimNames(relatedClassNameList);
    }

    private List<String> trimNames(String[] untrimmedNameList) {
        List<String> trimmedNameList = new List<String>();
        for (String untrimmedName : untrimmedNameList) {
            trimmedNameList.add(untrimmedName.trim());
        }
        return trimmedNameList;
    }
}
