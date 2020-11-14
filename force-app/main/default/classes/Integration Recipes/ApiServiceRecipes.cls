public inherited sharing class ApiServiceRecipes {
    private ARSC_RestClient restClient;

    private ApiServiceRecipes(ARSC_RestClient restClient) {
        this.restClient = restClient;
    }

    public ApiServiceRecipes() {
        this(ARSC_RestClient.getInstance());
    }

    @TestVisible
    private static final String DEFAULT_NAMED_CREDENTIAL = 'MockBin';
    private static final String GET_BIN_PATH = '4cb453a6-a23b-42ea-a6ba-9be1c1f17050';

    private static final Type DEFAULT_HTTP_HANDLER = ApiServiceRecipesUnknownExceptionHandler.class;

    private static final Map<Integer, Type> RESPONSE_CONSUMER_BY_STATUS_CODE_MAP = new Map<Integer, Type>{
        200 => ApiServiceRecipesDataParser.class,
        404 => ApiServiceRecipesNotFoundHandler.class
    };

    private static final Map<Type, ApiServiceRecipesHttpResponseConsumer> RESPONSE_CONSUMER_BY_TYPE_MAP
            = new Map<Type, ApiServiceRecipesHttpResponseConsumer>();

    public List<ApiServiceRecipesDataModel> getCurrentData() {
        ARSC_RestRequest restRequest = new ARSC_RestRequest()
                .setNamedCredential(DEFAULT_NAMED_CREDENTIAL)
                .setPath(GET_BIN_PATH);

        HttpResponse response = this.restClient.get(restRequest);
        return this.parseDataModels(response);
    }

    private List<ApiServiceRecipesDataModel> parseDataModels(HttpResponse response) {
        Type handlerType = RESPONSE_CONSUMER_BY_STATUS_CODE_MAP.get(response.getStatusCode());
        if (handlerType == null) {
            handlerType = DEFAULT_HTTP_HANDLER;
        }

        ApiServiceRecipesHttpResponseConsumer responseConsumer = RESPONSE_CONSUMER_BY_TYPE_MAP.get(handlerType);
        if (responseConsumer == null) {
            responseConsumer = (ApiServiceRecipesHttpResponseConsumer) handlerType.newInstance();
            RESPONSE_CONSUMER_BY_TYPE_MAP.put(handlerType, responseConsumer);
        }

        return responseConsumer.handle(response);
    }
}
