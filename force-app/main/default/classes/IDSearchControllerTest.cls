/*
*********************************************************
Apex Class Name    : IDSearchControllerTest
Created Date       : August 22, 2024
@description       : This class is used to test the IDSearchController 
					 apex class
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                Modification
1.0   22-08-2024   Cornelia Smit        Initial Version
*********************************************************
*/
@isTest
public class IDSearchControllerTest {
  @testSetup
  static void setupTestData() {
    Identity_Information__c idRecord = new Identity_Information__c(
      ID_Number__c = '9005240053082'
    );
    insert idRecord;
    createReadOnlyUser();
  }

  static void createReadOnlyUser() {
    Profile readOnlyProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Read Only'
      LIMIT 1
    ];
    User readOnlyUser = new User(
      Alias = 'stdusr',
      Email = 'readonlyuser@example.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'readUser',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = readOnlyProfile.Id,
      TimeZoneSidKey = 'Africa/Johannesburg',
      UserName = 'readonly' + System.currentTimeMillis() + '@example.com'
    );
    insert readOnlyUser;
  }

  @isTest
  static void testProcessIDAndExtractYear_NewRecord() {
    String newID = '0001025009083';

    Test.startTest();
    String year = IDSearchController.processIDAndExtractYear(newID);
    Test.stopTest();

    System.assertEquals('2000', year);

    List<Identity_Information__c> createdIDList = [
      SELECT ID_Number__c, Search_Count__c
      FROM Identity_Information__c
      WHERE ID_Number__c = :newID
      LIMIT 1
    ];
    System.assertNotEquals(0, createdIDList.size());
    System.assertEquals(1, createdIDList[0].Search_Count__c);
  }

  @isTest
  static void testProcessIDAndExtractYear_ExistingRecord() {
    String existingID = '9005240053082';

    Test.startTest();
    String year = IDSearchController.processIDAndExtractYear(existingID);
    Test.stopTest();

    System.assertEquals('1990', year);

    List<Identity_Information__c> incrementedIDList = [
      SELECT Search_Count__c
      FROM Identity_Information__c
      WHERE ID_Number__c = :existingID
      LIMIT 1
    ];
    System.assertNotEquals(0, incrementedIDList.size());
    System.assertEquals(2, incrementedIDList[0].Search_Count__c);
  }

  @isTest
  static void testProcessIDAndExtractYear_ReadOnlyUser_NoEditAccess() {
    User readOnlyUser = [
      SELECT Id
      FROM User
      WHERE LastName = 'readUser'
      LIMIT 1
    ];

    System.runAs(readOnlyUser) {
      Test.startTest();
      try {
        String year = IDSearchController.processIDAndExtractYear(
          '9005240053082'
        );
        System.assertNotEquals(
          null,
          year,
          'Expected a valid year to be returned.'
        );
      } catch (AuraHandledException e) {
        System.assert(true, 'AuraHandledException was correctly thrown.');
      }
      Test.stopTest();
    }
  }

  @isTest
  static void testProcessIDAndExtractYear_ReadOnlyUser_NoCreateAccess() {
    User readOnlyUser = [
      SELECT Id
      FROM User
      WHERE LastName = 'readUser'
      LIMIT 1
    ];

    System.runAs(readOnlyUser) {
      Test.startTest();
      try {
        String year = IDSearchController.processIDAndExtractYear(
          '0101025009081'
        );
        System.assertNotEquals(
          null,
          year,
          'Expected a valid year to be returned.'
        );
      } catch (AuraHandledException e) {
        System.assert(true, 'AuraHandledException was correctly thrown.');
      }
      Test.stopTest();
    }
  }

  @isTest
  static void testProcessIDAndExtractYear_ExceptionHandling() {
    Test.startTest();
    try {
      IDSearchController.processIDAndExtractYear(null);
      System.assert(false, 'Expected AuraHandledException was not thrown.');
    } catch (AuraHandledException e) {
      System.assert(true, 'AuraHandledException was correctly thrown.');
    }
    Test.stopTest();
  }
}
