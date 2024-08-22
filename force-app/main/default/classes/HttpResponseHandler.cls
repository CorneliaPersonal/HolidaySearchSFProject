/*
*********************************************************
Apex Class Name    : HttpResponseHandler
Created Date       : August 21, 2024
@description       : This class is used to handle an http response 
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                Modification
1.0   21-08-2024   Cornelia Smit        Initial Version
*********************************************************
*/
public with sharing class HttpResponseHandler {
    private static final Map<Integer, String> RESPONSE_CODE_MAP = new Map<Integer, String>{
        200 => 'Success',
        401 => 'Unauthorized',
        422 => 'Un-processable',
        500 => 'Internal server error',
        503 => 'Service unavailable',
        429 => 'Too many queries'
    };

    public static String handleResponse(HttpResponse response) {
        System.debug(response.getStatusCode());
        Integer statusCode = Integer.valueOf(response.getStatusCode());
        String responseBody = response.getBody();

        if (RESPONSE_CODE_MAP.containsKey(statusCode)) {
            if (statusCode != 200) {
                throw new CustomException(
                    'Invalid response: Status ' + String.valueOf(statusCode) + ' - ' + RESPONSE_CODE_MAP.get(statusCode)
                );
            }
            else {
                return responseBody != null ? responseBody : 'Success';
            }
        }
        else {
            throw new CustomException('Unexpected response: Status ' + String.valueOf(statusCode) + '. Response body: ' + responseBody);
        }
    }
    public class CustomException extends Exception {}
}