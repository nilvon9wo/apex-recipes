public with sharing class ARSC_RestRequest {
    private static final Set<ARSC_HttpVerb> METHODS_WITH_BODY_SET = new Set<ARSC_HttpVerb>{
            ARSC_HttpVerb.PATCH,
            ARSC_HttpVerb.POST,
            ARSC_HttpVerb.PUT
    };

    @TestVisible
    private static final Map<String, String> DEFAULT_HEADER_VALUE_BY_KEY_MAP = new Map<String, String>{
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
    };

    @TestVisible
    public String namedCredential { get; private set; }
    public ARSC_RestRequest setNamedCredential(String value) {
        this.namedCredential = value;
        return this;
    }

    public ARSC_HttpVerb method {
        get {
            return (method != null)
                    ? this.method
                    : ARSC_HttpVerb.GET;
        }
        private set;
    }
    public ARSC_RestRequest setMethod(ARSC_HttpVerb value) {
        this.method = value;
        return this;
    }

    public String path {
        get {
            return (path != null)
                    ? this.path
                    : '/';
        }
        private set;
    }
    public ARSC_RestRequest setPath(String value) {
        this.path = value;
        return this;
    }

    public String query {
        get {
            return (query != null)
                    ? this.query
                    : '';
        }
        private set;
    }
    public ARSC_RestRequest setQuery(String value) {
        this.query = value;
        return this;
    }

    public String body {
        get {
            return (body != null)
                    ? this.body
                    : '';
        }
        private set;
    }
    public ARSC_RestRequest setBody(String value) {
        this.body = value;
        return this;
    }

    public Map<String, String> headers {
        get {
            return (headers != null)
                    ? this.headers
                    : DEFAULT_HEADER_VALUE_BY_KEY_MAP;
        }
        private set;
    }
    public ARSC_RestRequest setHeaders(Map<String, String> value) {
        this.headers = value;
        return this;
    }

    private HttpRequest httpRequest = new HttpRequest();
    public HttpRequest toHttpRequest() {
        return this.setEndPoint()
                .setRequestHeaders()
                .setMethod()
                .setBody()
                .httpRequest;
    }

    private ARSC_RestRequest setEndPoint() {
        String encodedQuery = EncodingUtil.urlEncode(this.query, 'UTF-8');
        if (this.method == ARSC_HttpVerb.PATCH) {
            encodedQuery += '?_HttpMethod=PATCH';
        }

        this.httpRequest.setEndpoint(
                'callout:' +
                        this.namedCredential +
                        this.ensureStringEndsInSlash(this.path) +
                        encodedQuery
        );
        return this;
    }

    private ARSC_RestRequest setRequestHeaders() {
        for (String header : this.headers.keySet()) {
            this.httpRequest.setHeader(header, this.headers.get(header));
        }
        return this;
    }


    private ARSC_RestRequest setMethod() {
        String verb;
        switch on this.method {
            when DEL {
                verb = 'DELETE';
            }
            when PATCH {
                verb = 'POST';
            }
            when else {
                verb = String.valueOf(this.method);
            }
        }
        this.httpRequest.setMethod(verb);
        return this;
    }

    private ARSC_RestRequest setBody() {
        if (
                String.isNotBlank(this.body)
                        && METHODS_WITH_BODY_SET.contains(this.method)
                ) {
            this.httpRequest.setBody(this.body);
        }
        return this;
    }

    @TestVisible
    private String ensureStringEndsInSlash(String resource) {
        return (resource.endsWith('/'))
                ? resource
                : resource + '/';
    }

}