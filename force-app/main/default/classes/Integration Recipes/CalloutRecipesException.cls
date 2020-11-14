public class CalloutRecipesException extends Exception {
    public CalloutRecipesException(HttpResponse httpResponse) {
        this(
                'Did not get a success response from the callout. Details, '
                        + ' Status Code: ' + httpResponse.getStatusCode()
                        + ' status message: ' + httpResponse.getStatus()
        );
    }
}