/*
*********************************************************
Apex Class Name    : HttpCalloutHandler
Created Date       : August 21, 2024
@description       : This class is used to make an http callout 
					 to an external service 
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                 Modification
1.0   21-08-2024   Cornelia Smit         Initial Version
*********************************************************
*/
public with sharing class HttpCalloutHandler {
    public static HttpResponse makeCallout(String endpoint, String method) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);

        HttpResponse response;
        System.debug('Endpoint: ' + endpoint);
        System.debug('Method: ' + method);

        try {
            response = http.send(request);
        } catch (Exception e) {
            throw new CalloutException('Callout failed: ' + e.getMessage());
        }
        return response;
    }
    public class CalloutException extends Exception {}
}