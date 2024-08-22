/*
*********************************************************
Apex Class Name    : HttpCalloutHandlerTest
Created Date       : August 22, 2024
@description       : Test class for HttpCalloutHandler
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                 Modification
1.0   22-08-2024   Cornelia Smit         Initial Version
*********************************************************
*/
@isTest
private class HttpCalloutHandlerTest {
  private class MockHttpResponseGenerator implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      HTTPResponse res = new HTTPResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"status":"success"}');
      res.setStatusCode(200);
      return res;
    }
  }

  @isTest
  static void testMakeCallout() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    HttpResponse response = HttpCalloutHandler.makeCallout(
      'callout:TestEndpoint',
      'GET'
    );
    System.assertEquals(200, response.getStatusCode());
    System.assert(response.getBody().contains('success'));
  }
}
