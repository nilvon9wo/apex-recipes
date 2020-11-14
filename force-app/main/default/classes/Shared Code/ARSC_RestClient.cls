public virtual class ARSC_RestClient {
    protected ARSC_RestClient() {
    }

    private static ARSC_RestClient instance;
    public static ARSC_RestClient getInstance() {
        if (instance == null) {
            instance = new ARSC_RestClient();
        }
        return instance;
    }
    public virtual HttpResponse makeApiCall(ARSC_RestRequest restRequest) {
        return new Http()
                .send(restRequest.toHttpRequest());
    }

    public virtual HttpResponse del(ARSC_RestRequest restRequest) {
        restRequest.setMethod(ARSC_HttpVerb.DEL);
        return this.makeApiCall(restRequest);
    }

    public virtual HttpResponse get(ARSC_RestRequest restRequest) {
        restRequest.setMethod(ARSC_HttpVerb.GET);
        return this.makeApiCall(restRequest);
    }

    public virtual HttpResponse patch(ARSC_RestRequest restRequest) {
        restRequest.setMethod(ARSC_HttpVerb.PATCH);
        return this.makeApiCall(restRequest);
    }

    public virtual HttpResponse post(ARSC_RestRequest restRequest) {
        restRequest.setMethod(ARSC_HttpVerb.POST);
        return this.makeApiCall(restRequest);
    }

    public virtual HttpResponse put(ARSC_RestRequest restRequest) {
        restRequest.setMethod(ARSC_HttpVerb.PUT);
        return this.makeApiCall(restRequest);
    }
}
