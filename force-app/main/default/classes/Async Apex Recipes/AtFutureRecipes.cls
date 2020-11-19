//@group Async Apex Recipes
public inherited sharing class AtFutureRecipes {
    @TestVisible
    private static Boolean testCircuitBreaker = false;

    @Future
    public static void atFutureMethodWithoutCalloutPrivileges() {
        new AtFutureRecipes()
                .tripCircuitBreaker();
    }

    @Future(Callout=true)
    public static void atFutureMethodWithCalloutPrivileges(String url) {
        new AtFutureRecipes()
                .doCallout(url);
    }

    private AtFutureRecipes doCallout(String url) {
        HttpRequest request = new XAP_REST_RestRequest()
            .setEndPoint('https://' + url)
            .toHttpRequest();
        HttpResponse response = new Http()
                .send(request);

        if (response.getStatusCode() != 200) {
            this.tripCircuitBreaker();
        }
        return this;
    }

    private AtFutureRecipes tripCircuitBreaker() {
        AtFutureRecipes.testCircuitBreaker = true;
        return this;
    }
}
