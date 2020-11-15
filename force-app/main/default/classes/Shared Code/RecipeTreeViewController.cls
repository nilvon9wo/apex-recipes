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

    private static Map<String, List<String>> groupToListOfNames;

    private static final String APEXRECIPESIDENTIFICATIONTAG = '* @group';

    public class RecipeTreeData implements Comparable {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Boolean expanded = false;
        @AuraEnabled
        public RecipeTreeData[] items;

        public Integer compareTo(Object compareTo) {
            RecipeTreeData compare = (RecipeTreeData) compareTo;
            if (name == compare.name) {
                return 0;
            }
            if (name > compare.name) {
                return 1;
            }
            return -1;
        }
    }

    @AuraEnabled(Cacheable=true)
    public static List<RecipeTreeData> generateTreeData() {
        return new RecipeTreeViewController()
            .createTreeData();
    }

    public List<RecipeTreeData> createTreeData() {
        List<RecipeTreeData> treeData = new List<RecipeTreeData>();
        RecipeTreeData recipes = new RecipeTreeData();
        recipes.label = 'Recipes';
        recipes.name = 'Recipes';
        recipes.expanded = true;
        recipes.items = new List<RecipeTreeData>();
        RecipeTreeData sharedCode = new RecipeTreeData();
        groupToListOfNames = generateMapOfGroupToListOfNames();
        List<String> sortedGroupNames = new List<String>();
        sortedGroupNames.addAll(groupToListOfNames.keySet());
        sortedGroupNames.sort();
        for (String groupName : sortedGroupNames) {
            groupName = groupName.trim();
            RecipeTreeData groupLevel = new RecipeTreeData();
            groupLevel.label = groupName;
            groupLevel.name = groupName;
            groupLevel.items = new List<RecipeTreeData>();
            for (String className : groupToListOfNames.get(groupName)) {
                className = className.trim();
                RecipeTreeData classLevel = new RecipeTreeData();
                classLevel.label = className;
                classLevel.name = className;
                classLevel.items = new List<RecipeTreeData>();
                groupLevel.items.add(classLevel);
                groupLevel.items.sort();
            }
            if (groupName.equalsIgnoreCase('shared code')) {
                sharedCode = groupLevel;
            } else {
                recipes.items.add(groupLevel);
                recipes.items.sort();
            }
        }
        treeData.add(recipes);
        treeData.add(sharedCode);

        return treeData;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    private Map<String, List<String>> generateMapOfGroupToListOfNames() {
        Map<String, List<String>> returnMap = new Map<String, List<String>>();
        List<List<SObject>> searchResults = [
            FIND :APEXRECIPESIDENTIFICATIONTAG
            IN ALL FIELDS
            RETURNING ApexClass(Name, Body)
        ];
        ApexClass[] classes = searchResults[0];

        for (ApexClass klass : classes) {
            String groupName = this.classUtilities.getGroupFromClassBody(klass);
            if (returnMap.keySet().contains(groupName)) {
                returnMap.get(groupName).add(klass.Name);
            } else {
                returnMap.put(groupName, new List<String>{ klass.Name });
            }
        }
        return returnMap;
    }
}
