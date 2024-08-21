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
    @AuraEnabled
    public static String executeCallout(String year, String countryCode, String holidayType) {
        try {
            String endpointPath = '/holidays?api_key=' + getSearchIDAPIKey() + '&country=' + countryCode + '&year=' + year + '&type=' + holidayType;
            String endpoint = 'callout:CalendarificCredential' + endpointPath;
            String httpMethod = 'GET';
            HttpResponse response = HttpCalloutHandler.makeCallout(endpoint, httpMethod);
            String responseString = HttpResponseHandler.handleResponse(response);
            return responseString;
        } catch (CustomException ce)  {
            throw new AuraHandledException(ce.getMessage());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static String getSearchIDAPIKey() {
        if (!Schema.sObjectType.API_Key_Settings__mdt.isAccessible()){
            throw new CustomException('API Key Settings object is not readable'); 
        }
        List<API_Key_Settings__mdt> apiSettings = [SELECT API_Key__c 
                                                       FROM API_Key_Settings__mdt
                                                       WHERE DeveloperName = 'Calendarific'
                                                       WITH SECURITY_ENFORCED
                                                       LIMIT 1];
        if (apiSettings.size() == 0) {
            throw new CustomException('No API Key Settings found'); 
        }
        return apiSettings[0].API_Key__c;
    }
    
    public class CustomException extends Exception {}
}