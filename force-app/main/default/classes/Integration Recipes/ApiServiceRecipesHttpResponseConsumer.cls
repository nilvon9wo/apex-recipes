public interface ApiServiceRecipesHttpResponseConsumer {
    List<ApiServiceRecipesDataModel> handle(HttpResponse httpResponse);
}