public inherited sharing class RelatedCodeTabsController {
    private ApexClassUtilities classUtilities;
    private DAO_ApexClassSelector apexClassSelector;

    private RelatedCodeTabsController(ApexClassUtilities classUtilities, DAO_ApexClassSelector apexClassSelector) {
        this.classUtilities = classUtilities;
        this.apexClassSelector = apexClassSelector;
    }

    public RelatedCodeTabsController() {
        this(new ApexClassUtilities(), DAO_ApexClassSelector.getInstance());
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    @AuraEnabled(Cacheable=true)
    public static List<String> getRelatedClasses(String mainClassName) {
        return new RelatedCodeTabsController()
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
        String[] untrimmed = this.classUtilities.getRelatedClassesFromClassBody(klass)
                .split(',');

        return this.selectClasses(untrimmed);
    }

    private List<String> selectClasses(String[] untrimmed) {
        List<String> relatedClasses = new List<String>();
        for (String toTrim : untrimmed) {
            relatedClasses.add(toTrim.trim());
        }
        return relatedClasses;
    }
}
