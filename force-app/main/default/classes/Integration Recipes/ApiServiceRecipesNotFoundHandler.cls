public with sharing class ApiServiceRecipesNotFoundHandler implements ApiServiceRecipesHttpResponseConsumer {
    public List<ApiServiceRecipesDataModel> handle(HttpResponse httpResponse) {
        throw new ApiException('404 error!');
    }
}