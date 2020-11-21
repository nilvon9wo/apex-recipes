/*
 * @see Foo, Bar
 */
@IsTest
private class RecipeTreeViewController_Tests {
    @IsTest
    static void testGenerateTreeDataPositive() {
        Map<Id, ApexClass> fakeResults = new Map<Id, ApexClass>(
            [
                SELECT Name, Body
                FROM ApexClass
                WHERE
                    Name LIKE 'RecipeTreeViewController'
                    OR Name LIKE 'SOQLRecipes'
            ]
        );
        Test.setFixedSearchResults(new List<Id>(fakeResults.keySet()));
        Test.startTest();
        List<RecipeTreeData> tree = RecipeTreeViewController.generateTreeData();
        Test.stopTest();

        System.assertEquals(2, tree.size(), 'Expected to find two sub trees');
        System.assert(
            tree[0].name == 'Recipes',
            'Expected Recipes to be the first element'
        );
        System.assert(
            tree[0].items.size() > 0,
            'expected for recipes to have sub-groups'
        );
    }
}
