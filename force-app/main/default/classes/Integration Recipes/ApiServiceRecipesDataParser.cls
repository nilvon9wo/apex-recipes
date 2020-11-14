public with sharing class ApiServiceRecipesDataParser implements ApiServiceRecipesHttpResponseConsumer {
    public ApiServiceRecipesDataParser(){
    }

    public List<ApiServiceRecipesDataModel> handle(HttpResponse httpResponse) {
        try {
            return this.parse(httpResponse.getBody());
        }
        catch (System.JSONException jsonException) {
            throw new ApiException(jsonException.getMessage());
        }
    }

    public List<ApiServiceRecipesDataModel> parse(String json) {
        return (List<ApiServiceRecipesDataModel>) System.JSON.deserialize(
                json,
                List<ApiServiceRecipesDataModel>.class
        );
    }
}