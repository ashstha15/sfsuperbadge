public class RewardsCalloutService{

    public static Integer submitUsersForRewardCallout(String jsonBody) {
        //Set Endpoint from Named Credential
        String endpoint = 'callout:IntegrationSB__BalancedLiving/rewards'; 
        
        
        //Make HTTP Callout
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonBody);
        HttpResponse response = new Http().send(request);
        
        
        //Update to return response status code
        return response.getStatusCode();
    }
}