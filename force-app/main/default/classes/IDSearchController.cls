/*
*********************************************************
Apex Class Name    : IDSearchController
Created Date       : August 20, 2024
@description       : This class is used to search for, create 
					 and update ID Number records in Salesforce
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                Modification
1.0   20-08-2024   Cornelia Smit        Initial Version
*********************************************************
*/
public with sharing class IDSearchController {
  @AuraEnabled
  public static String processIDAndExtractYear(String idNumber) {
    try {
      List<Identity_Information__c> idList = retrieveIdentityInformation(
        idNumber
      );
      if (idList.size() == 0) {
        createIdentityInformation(idNumber);
      } else {
        incrementSearchCount(idList[0]);
      }
      String year = extractYearFromID(idNumber);
      return year;
    } catch (CustomException ce) {
      throw new AuraHandledException(ce.getMessage());
    } catch (Exception e) {
      throw new AuraHandledException(
        'Unexpected error occurred: ' + e.getMessage()
      );
    }
  }

  private static List<Identity_Information__c> retrieveIdentityInformation(
    String idNumber
  ) {
    if (!Schema.sObjectType.Identity_Information__c.isAccessible()) {
      throw new CustomException('Identity Information object is not readable');
    }
    List<Identity_Information__c> idList = [
      SELECT Id, ID_Number__c, Search_Count__c
      FROM Identity_Information__c
      WHERE ID_Number__c = :idNumber
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    return idList;
  }

  private static void createIdentityInformation(String idNumber) {
    if (!Schema.sObjectType.Identity_Information__c.isCreateable()) {
      throw new CustomException(
        'Insufficient permissions to create Identity Information record'
      );
    }
    Identity_Information__c newID = new Identity_Information__c();
    newID.ID_Number__c = idNumber;
    try {
      insert newID;
    } catch (Exception e) {
      throw new CustomException(
        'Failed to create Identity Information record: ' + e.getMessage()
      );
    }
  }

  private static void incrementSearchCount(Identity_Information__c idInfo) {
    if (
      !Schema.sObjectType.Identity_Information__c.isUpdateable() ||
      !Schema.sObjectType.Identity_Information__c.fields.Search_Count__c.isUpdateable()
    ) {
      throw new CustomException(
        'Insufficient permissions to update the Search Count on Identity Information'
      );
    }
    idInfo.Search_Count__c = idInfo.Search_Count__c + 1;
    try {
      update idInfo;
    } catch (DmlException e) {
      throw new CustomException(
        'Failed to increment Identity Information record search count: ' +
        e.getMessage()
      );
    }
  }

  private static String extractYearFromID(String idNumber) {
    String yearSubstring = idNumber.substring(0, 2);
    Integer year = Integer.valueOf(yearSubstring);

    return ((year + 2000 <= Date.today().year()) ? '20' : '19') + yearSubstring;
  }

  public class CustomException extends Exception {
  }
}
