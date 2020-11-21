public inherited sharing class RecipeTreeViewController {
    private ApexClassUtilities classUtilities;
    private DAO_ApexClassSelector apexClassSelector;

    private RecipeTreeViewController(ApexClassUtilities classUtilities, DAO_ApexClassSelector apexClassSelector) {
        this.classUtilities = classUtilities;
        this.apexClassSelector = apexClassSelector;
    }

    public RecipeTreeViewController() {
        this(new ApexClassUtilities(), DAO_ApexClassSelector.getInstance());
    }

    private static final String APEX_RECIPES_IDENTIFICATION_TAG = '* @group';

    private static Map<String, List<String>> classNameListByGroupNameMap {
        get {
            if (classNameListByGroupNameMap == null) {
                classNameListByGroupNameMap = new RecipeTreeViewController()
                        .buildClassNameListByGroupNameMap();
            }
            return classNameListByGroupNameMap;
        }
        private set;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    private Map<String, List<String>> buildClassNameListByGroupNameMap() {
        ApexClass[] classes = this.apexClassSelector.findByTag(APEX_RECIPES_IDENTIFICATION_TAG)[0];

        Map<String, List<String>> classNameListByGroupNameMap = new Map<String, List<String>>();
        for (ApexClass klass : classes) {
            String groupName = this.classUtilities.getGroupFromClassBody(klass);
            List<String> classNameList = classNameListByGroupNameMap.get(groupName);
            if (classNameList == null) {
                classNameList = new List<String>();
                classNameListByGroupNameMap.put(groupName, classNameList);
            }
            classNameList.add(klass.Name);
        }
        return classNameListByGroupNameMap;
    }

    @AuraEnabled(Cacheable=true)
    public static List<RecipeTreeData> generateTreeData() {
        return new RecipeTreeViewController()
            .createTreeData();
    }

    public List<RecipeTreeData> createTreeData() {
        RecipeTreeData recipeTreeData = this.createRootLevelRecipeTree();

        RecipeTreeData sharedCode = new RecipeTreeData();
        List<String> sortedGroupNameList = this.buildSortedGroupNameList();
        for (String groupName : sortedGroupNameList) {
            RecipeTreeData groupLevel = this.createGroupLevelRecipeTree(groupName);

            if (groupName.equalsIgnoreCase('shared code')) {
                sharedCode = groupLevel;
            }
            else {
                recipeTreeData.items.add(groupLevel);
                recipeTreeData.items.sort();
            }
        }

        return new List<RecipeTreeData>{
                recipeTreeData,
                sharedCode
        };
    }

    private RecipeTreeData createRootLevelRecipeTree() {
        RecipeTreeData recipeTreeData = new RecipeTreeData('Recipes');
        recipeTreeData.expanded = true;
        return recipeTreeData;
    }

    private RecipeTreeData createGroupLevelRecipeTree(String groupName) {
        RecipeTreeData groupLevel = new RecipeTreeData(groupName);
        for (String className : classNameListByGroupNameMap.get(groupName)) {
            groupLevel.items.add(this.createClassLevelRecipeTree(className));
            groupLevel.items.sort();
        }
        return groupLevel;
    }

    private RecipeTreeData createClassLevelRecipeTree(String className) {
        return new RecipeTreeData(className);
    }

    private List<String> buildSortedGroupNameList() {
        List<String> sortedGroupNameList = new List<String>(classNameListByGroupNameMap.keySet());
        sortedGroupNameList.sort();
        return sortedGroupNameList;
    }
}
