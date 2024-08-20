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
public with sharing class IDSearchController {
    @AuraEnabled
    public static String getHolidaysForID(String idNumber) {
        List<Identity_Information__c> idList = retrieveIdentityInformation(idNumber);
        String result = (idList.size() == 0) ? createIdentityInformation(idNumber) : incrementSearchCount(idList[0]);

        if(result != 'Success'){
            return result;
        }
        String holidays = 'Holidays';

        return holidays;
    }
    
    private static List<Identity_Information__c> retrieveIdentityInformation(String idNumber) {
        List<Identity_Information__c> idList = [SELECT Id, ID_Number__c, Search_Count__c, Date_of_Birth__c 
                                                FROM Identity_Information__c 
                                                WHERE ID_Number__c = :idNumber 
                                                WITH SECURITY_ENFORCED 
                                                LIMIT 1];
       return idList; 
    }
    
    private static String createIdentityInformation(String idNumber) {
        if(!Schema.sObjectType.Identity_Information__c.isCreateable()){
            return 'Error: Identity Information object is not createable';
        }
        Identity_Information__c newID = new Identity_Information__c();
        newID.ID_Number__c = idNumber;
        try {
            insert newID;
            return 'Success';
        } catch(DmlException e) {
            return 'Error: ' + e;
        }
    }
    
    private static String incrementSearchCount(Identity_Information__c idInfo) {
        if(!Schema.sObjectType.Identity_Information__c.isUpdateable() ||
           !Schema.sObjectType.Identity_Information__c.fields.Search_Count__c.isUpdateable()) {
            return 'Error: Identity Information record is not updateable';
        }
        
        idInfo.Search_Count__c = idInfo.Search_Count__c + 1;
        try {
            update idInfo;
            return 'Success';
        } catch(DmlException e) {
            return 'Error: ' + e;
        }
    }
}