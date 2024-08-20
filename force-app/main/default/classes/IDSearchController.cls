/*
*********************************************************
Apex Class Name    : IDSearchController
Created Date       : August 20, 2024
@description       : This class is used to search for and create 
					 ID Number records in Salesforce and retrieve 
					 holidays from an external service
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                        Modification
1.0   20-08-2024   Cornelia Smit                Initial Version
*********************************************************
*/
public class IDSearchController {
    @AuraEnabled
    public static String getHolidaysForID(String idNumber){
        String result = '';
        return result;
    }
    
    private static void retrieveIdentityInformation(String idNumber){

    }
    
    private static void createIdentityInformation(String idNumber){

    }
    
    private static void incrementSearchCount(String idNumber){

    }
    
    private static void retrieveHolidaysViaAPI(String idNumber){

    }

}