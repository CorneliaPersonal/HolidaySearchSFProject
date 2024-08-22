/*
*********************************************************
Apex Class Name    : IDSearchApiServiceTest
Created Date       : August 22, 2024
@description       : Test class for IDSearchApiService
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                Modification
1.0   21-08-2024   Cornelia Smit        Initial Version
*********************************************************
*/
@isTest
private class IDSearchApiServiceTest {
  @testSetup
  static void createReadOnlyUser() {
    Profile readOnlyProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Read Only'
      LIMIT 1
    ];
    User readOnlyUser = new User(
      Alias = 'stdusr',
      Email = 'readonlyuser2@example.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'readUser2',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = readOnlyProfile.Id,
      TimeZoneSidKey = 'Africa/Johannesburg',
      UserName = 'readonly' + System.currentTimeMillis() + '@example.com'
    );
    insert readOnlyUser;
  }

  private class MockHttpResponseGenerator implements HttpCalloutMock {
    private Integer statusCode;
    private String body;

    public MockHttpResponseGenerator(Integer statusCode, String body) {
      this.statusCode = statusCode;
      this.body = body;
    }

    public HTTPResponse respond(HTTPRequest req) {
      HTTPResponse res = new HTTPResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody(body);
      res.setStatusCode(statusCode);
      return res;
    }
  }

  @isTest
  static void testExecuteCalloutPass() {
    String body = '{"holidays":[{"name":"New Year\'s Day","description":"New Year’s Day is celebrated with a blend of both diversity and tradition in countries such as South Africa on January 1 each year.","country":{"id":"za","name":"South Africa"},"date":{"iso":"1985-01-01","datetime":{"year":1985,"month":1,"day":1}},"type":["National holiday"],"primary_type":"Public Holiday","canonical_url":"https://calendarific.com/holiday/south-africa/new-year-day","urlid":"south-africa/new-year-day","locations":"All","states":"All"}]}';
    Integer statusCode = 200;

    Test.startTest();
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGenerator(statusCode, body)
    );

    String result = IDSearchApiService.executeCallout('2024', 'ZA', 'national');

    System.assert(
      result.contains('New Year\'s Day'),
      'Expected holiday name not found in the response'
    );
    System.assert(
      result.contains(
        'New Year’s Day is celebrated with a blend of both diversity and tradition in countries such as South Africa on January 1 each year.'
      ),
      'Expected holiday description not found in the response'
    );
    System.assert(
      result.contains(
        'https://calendarific.com/holiday/south-africa/new-year-day'
      ),
      'Expected canonical URL not found in the response'
    );
    Test.stopTest();
  }

  @isTest
  static void testExecuteCallout_CalloutException() {
    Test.startTest();
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGenerator(500, 'Simulated callout failure')
    );

    try {
      IDSearchApiService.executeCallout('2024', 'ZA', 'national');
      System.assert(false, 'Expected AuraHandledException was not thrown.');
    } catch (AuraHandledException e) {
      System.assert(true, 'AuraHandledException was correctly thrown.');
    }
    Test.stopTest();
  }

  @isTest
  static void testExecuteCallout_APIKeyNotAccessible() {
    String body = '{"holidays":[{"name":"New Year\'s Day","description":"New Year’s Day is celebrated with a blend of both diversity and tradition in countries such as South Africa on January 1 each year.","country":{"id":"za","name":"South Africa"},"date":{"iso":"1985-01-01","datetime":{"year":1985,"month":1,"day":1}},"type":["National holiday"],"primary_type":"Public Holiday","canonical_url":"https://calendarific.com/holiday/south-africa/new-year-day","urlid":"south-africa/new-year-day","locations":"All","states":"All"}]}';
    Integer statusCode = 200;

    //Read Only user does not have access to API Key Settings custom metadata type
    User readOnlyUser = [
      SELECT Id
      FROM User
      WHERE LastName = 'readUser2'
      LIMIT 1
    ];

    System.runAs(readOnlyUser) {
      Test.startTest();
      Test.setMock(
        HttpCalloutMock.class,
        new MockHttpResponseGenerator(statusCode, body)
      );

      try {
        IDSearchApiService.executeCallout('2024', 'ZA', 'national');
        System.assert(false, 'Expected AuraHandledException was not thrown.');
      } catch (AuraHandledException e) {
        System.assert(true, 'AuraHandledException was correctly thrown.');
      }
      Test.stopTest();
    }
  }
}
