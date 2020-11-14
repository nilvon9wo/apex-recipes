public virtual class RestClient {
    @TestVisible
    private static Map<String, String> defaultHeaders = new Map<String, String>{
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
    };

    @TestVisible
    protected String namedCredentialName { get; set; }

    public enum HttpVerb {
        GET,
        POST,
        PATCH,
        PUT,
        HEAD,
        DEL
    }

    public RestClient(String namedCredential) {
        this.namedCredentialName = namedCredential;
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected RestClient() {
    }

    @TestVisible
    @SuppressWarnings('PMD.ExcessiveParameterList')
    protected HttpResponse makeApiCall(
            HttpVerb method,
            String path,
            String query,
            String body,
            Map<String, String> headers
    ) {
        path = ensureStringEndsInSlash(path);
        String encodedQuery = EncodingUtil.urlEncode(query, 'UTF-8');
        if (method == HttpVerb.PATCH) {
            method = HttpVerb.POST;
            encodedQuery += '?_HttpMethod=PATCH';
        }
        HttpRequest apiRequest = new HttpRequest();
        if (method == HttpVerb.DEL) {
            apiRequest.setMethod('DELETE');
        }
        else {
            apiRequest.setMethod(String.valueOf(method));
        }
        Map<String, String> functionalHeaders = (headers != null)
                ? headers
                : RestClient.defaultHeaders;
        for (String header : functionalHeaders.keySet()) {
            apiRequest.setHeader(header, functionalHeaders.get(header));
        }
        if (
                String.isNotBlank(body) &&
                        (method == HttpVerb.POST ||
                                method == HttpVerb.PUT ||
                                method == HttpVerb.PATCH)
                ) {
            apiRequest.setBody(body);
        }
        apiRequest.setEndpoint(
                'callout:' +
                        this.namedCredentialName +
                        path +
                        encodedQuery
        );
        Http http = new Http();
        HttpResponse toReturn = http.send(apiRequest);
        return toReturn;
    }

    @TestVisible
    @SuppressWarnings('PMD.ExcessiveParameterList')
    protected HttpResponse makeApiCall(
            HttpVerb method,
            String path,
            String query,
            String body
    ) {
        return this.makeApiCall(
                method,
                path,
                query,
                body,
                RestClient.defaultHeaders
        );
    }

    @TestVisible
    protected HttpResponse makeApiCall(
            HttpVerb method,
            String path,
            String query
    ) {
        return this.makeApiCall(
                method,
                path,
                query,
                '',
                RestClient.defaultHeaders
        );
    }

    @TestVisible
    protected HttpResponse makeApiCall(HttpVerb method, String path) {
        return this.makeApiCall(
                method,
                path,
                '',
                '',
                RestClient.defaultHeaders
        );
    }

    @TestVisible
    protected HttpResponse get(String path) {
        return this.makeApiCall(HttpVerb.GET, path);
    }

    @TestVisible
    protected HttpResponse get(String path, String query) {
        return this.makeApiCall(HttpVerb.GET, path, query);
    }

    @TestVisible
    protected HttpResponse del(String path) {
        return this.makeApiCall(HttpVerb.DEL, path);
    }

    @TestVisible
    protected HttpResponse del(String path, String query) {
        return this.makeApiCall(HttpVerb.DEL, path, query);
    }

    @TestVisible
    protected HttpResponse post(String path, String body) {
        return this.makeApiCall(HttpVerb.POST, path, '', body);
    }

    @TestVisible
    protected HttpResponse post(String path, String query, String body) {
        return this.makeApiCall(HttpVerb.POST, path, query, body);
    }

    @TestVisible
    protected HttpResponse put(String path, String body) {
        return this.makeApiCall(HttpVerb.PUT, path, '', body);
    }

    @TestVisible
    protected HttpResponse put(String path, String query, String body) {
        return this.makeApiCall(HttpVerb.PUT, path, query, body);
    }

    @TestVisible
    protected HttpResponse patch(String path, String body) {
        return this.makeApiCall(HttpVerb.PATCH, path, '', body);
    }

    @TestVisible
    protected HttpResponse patch(String path, String query, String body) {
        return this.makeApiCall(HttpVerb.PATCH, path, query, body);
    }

    @TestVisible
    protected String ensureStringEndsInSlash(String resource) {
        if (resource.endsWith('/')) {
            return resource;
        }
        return resource + '/';
    }

    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static HttpResponse makeApiCall(
            String namedCredential,
            HttpVerb method,
            String path,
            String query,
            String body,
            Map<String, String> headers
    ) {
        return new RestClient(namedCredential)
                .makeApiCall(method, path, query, body, headers);
    }

    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static HttpResponse makeApiCall(
            String namedCredential,
            HttpVerb method,
            String path,
            String query
    ) {
        return new RestClient(namedCredential)
                .makeApiCall(method, path, query, '', RestClient.defaultHeaders);
    }

    public static HttpResponse makeApiCall(
            String namedCredential,
            HttpVerb method,
            String path
    ) {
        return new RestClient(namedCredential)
                .makeApiCall(method, path, '', '', RestClient.defaultHeaders);
    }
}
