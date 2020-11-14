@IsTest
public class ApiServiceRecipesDataModel_Tests {
    public static String testJSONBad =
        '[' +
        '  {\"exampleArray\": [' +
        '    1,' +
        '    2,' +
        '    3' +
        '  ],' +
        '  \"exampleBoolean\": true,' +
        '  \"exampleColor\": \"Green\",' +
        '  \"exampleCouldBeNull\": null,' +
        '  \"exampleNumber\": 8675309,' +
        '  \"exampleObject\": {';

    public static String testJSON =
        '[' +
        '  {\"exampleArray\": [' +
        '    1,' +
        '    2,' +
        '    3' +
        '  ],' +
        '  \"exampleBoolean\": true,' +
        '  \"exampleColor\": \"Green\",' +
        '  \"exampleCouldBeNull\": null,' +
        '  \"exampleNumber\": 8675309,' +
        '  \"exampleObject\": {' +
        '    \"a\": \"b\",' +
        '    \"c\": \"d\"' +
        '  },' +
        '  \"exampleString\": \"Hello World\"},' +
        '  {\"exampleArray\": [' +
        '    1,' +
        '    2,' +
        '    3' +
        '  ],' +
        '  \"exampleBoolean\": true,' +
        '  \"exampleColor\": \"Blue\",' +
        '  \"exampleCouldBeNull\": \"Not null this time\",' +
        '  \"exampleNumber\": 123,' +
        '  \"exampleObject\": {' +
        '    \"a\": \"b\",' +
        '    \"c\": \"d\"' +
        '  },' +
        '  \"exampleString\": \"Hello World\"}]';
    @IsTest
    static void testParse() {
        List<ApiServiceRecipesDataModel> obj = new ApiServiceRecipesDataParser()
                .parse(ApiServiceRecipesDataModel_Tests.testJSON);
        System.assert(
            obj != null,
            'Expected the example data to properly parse'
        );
    }
}
