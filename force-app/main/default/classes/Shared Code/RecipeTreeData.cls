public class RecipeTreeData implements Comparable {
    public RecipeTreeData() {
    }

    public RecipeTreeData(String name){
        String trimmedName = name.trim();
        this.name = trimmedName;
        this.label = trimmedName;
    }

    @AuraEnabled
    public String label;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public Boolean expanded = false;
    @AuraEnabled
    public List<RecipeTreeData> items = new List<RecipeTreeData>();

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