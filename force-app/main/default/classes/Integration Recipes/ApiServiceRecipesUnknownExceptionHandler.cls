public with sharing class ApiServiceRecipesUnknownExceptionHandler implements ApiServiceRecipesHttpResponseConsumer {
    public List<ApiServiceRecipesDataModel> handle(HttpResponse httpResponse) {
        throw new ApiException('Unexpected Response code: ' + httpResponse.getStatusCode());
    }
}