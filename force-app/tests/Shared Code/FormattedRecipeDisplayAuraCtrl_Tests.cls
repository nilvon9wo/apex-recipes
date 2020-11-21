/*
 * @group Foo
 */
@IsTest
private class FormattedRecipeDisplayAuraCtrl_Tests {
    @IsTest
    static void testGetRecipeCodePositive() {
        String[] classes = new List<String>{
            'FormattedRecipeDisplayAuraCtrl_Tests'
        };

        Test.startTest();
        for (String klass : classes) {
            ClassData result = FormattedRecipeDisplayAuraCtrl.getRecipeCode(
                klass
            );
            System.assertEquals(
                klass,
                result.name,
                'Expected the name to equal the input'
            );
            System.assert(
                result.apiVersion >= 50.0,
                'Expected the apiVersion to be no earlier than 50.0'
            );
            System.assertNotEquals(
                null,
                result.body,
                'Expected the body to not be null'
            );
            System.assert(
                result.lengthWithoutComments > 0,
                'Expected the length to be greater than 0'
            );
            if (klass.endsWith('_Tests')) {
                System.assert(
                    result.groupName.equalsIgnoreCase('Tests'),
                    'Expected to have received the string Tests'
                );
            } else {
                System.assert(
                    result.groupName.equalsIgnoreCase('Foo'),
                    'Expected to have received the string Shared Code'
                );
            }
        }
        Test.stopTest();
    }
}
