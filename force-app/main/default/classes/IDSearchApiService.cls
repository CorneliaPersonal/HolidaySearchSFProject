/*
*********************************************************
Apex Class Name    : IDSearchApiService
Created Date       : August 21, 2024
@description       : This class is used to retrieve a list
                     of holidays from the Calendarific API
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                Modification
1.0   21-08-2024   Cornelia Smit        Initial Version
*********************************************************
*/
public with sharing class IDSearchApiService {
    public static String executeCallout(String year, String countryCode, String holidayType) {
        String endpointPath = '/holidays?country=' + countryCode + '&year=' + year + '&type=' + holidayType;
        String endpoint = 'callout:CalendarificCredential' + endpointPath;
        String httpMethod = 'GET';
        try {
            HttpResponse response = HttpCalloutHandler.makeCallout(endpoint, httpMethod);
            String responseString = HttpResponseHandler.handleResponse(response);
            return responseString;
        } catch (Exception e) {
            throw new CustomException(e.getMessage());
        }
    }
    public class CustomException extends Exception {}
}