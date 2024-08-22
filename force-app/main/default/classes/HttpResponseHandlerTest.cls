/*
*********************************************************
Apex Class Name    : HttpResponseHandlerTest
Created Date       : August 22, 2024
@description       : Test class for HttpResponseHandler
@author            : Cornelia Smit
Modification Log:
Ver   Date         Author                Modification
1.0   22-08-2024   Cornelia Smit        Initial Version
*********************************************************
*/
@isTest
private class HttpResponseHandlerTest {
  @isTest
  static void testHandleResponse_Success() {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    response.setBody('{"data":"Success"}');

    String result = HttpResponseHandler.handleResponse(response);
    System.assertEquals(
      '{"data":"Success"}',
      result,
      'Expected response body to match'
    );
  }

  @isTest
  static void testHandleResponse_Unauthorized() {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(401);
    response.setBody('{"error":"Unauthorized"}');

    try {
      HttpResponseHandler.handleResponse(response);
      System.assert(
        false,
        'Expected CustomException to be thrown for 401 Unauthorized'
      );
    } catch (HttpResponseHandler.CustomException e) {
      System.assert(
        e.getMessage().contains('Invalid response: Status 401 - Unauthorized'),
        'Unexpected exception message: ' + e.getMessage()
      );
    }
  }

  @isTest
  static void testHandleResponse_Unprocessable() {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(422);
    response.setBody('{"error":"Unprocessable entity"}');

    try {
      HttpResponseHandler.handleResponse(response);
      System.assert(
        false,
        'Expected CustomException to be thrown for 422 Un-processable'
      );
    } catch (HttpResponseHandler.CustomException e) {
      System.assert(
        e.getMessage()
          .contains('Invalid response: Status 422 - Un-processable'),
        'Unexpected exception message: ' + e.getMessage()
      );
    }
  }

  @isTest
  static void testHandleResponse_InternalServerError() {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(500);
    response.setBody('{"error":"Internal server error"}');

    try {
      HttpResponseHandler.handleResponse(response);
      System.assert(
        false,
        'Expected CustomException to be thrown for 500 Internal Server Error'
      );
    } catch (HttpResponseHandler.CustomException e) {
      System.assert(
        e.getMessage()
          .contains('Invalid response: Status 500 - Internal server error'),
        'Unexpected exception message: ' + e.getMessage()
      );
    }
  }

  @isTest
  static void testHandleResponse_ServiceUnavailable() {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(503);
    response.setBody('{"error":"Service unavailable"}');

    try {
      HttpResponseHandler.handleResponse(response);
      System.assert(
        false,
        'Expected CustomException to be thrown for 503 Service Unavailable'
      );
    } catch (HttpResponseHandler.CustomException e) {
      System.assert(
        e.getMessage()
          .contains('Invalid response: Status 503 - Service unavailable'),
        'Unexpected exception message: ' + e.getMessage()
      );
    }
  }

  @isTest
  static void testHandleResponse_TooManyQueries() {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(429);
    response.setBody('{"error":"Too many queries"}');

    try {
      HttpResponseHandler.handleResponse(response);
      System.assert(
        false,
        'Expected CustomException to be thrown for 429 Too Many Queries'
      );
    } catch (HttpResponseHandler.CustomException e) {
      System.assert(
        e.getMessage()
          .contains('Invalid response: Status 429 - Too many queries'),
        'Unexpected exception message: ' + e.getMessage()
      );
    }
  }

  @isTest
  static void testHandleResponse_UnexpectedStatus() {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(999);
    response.setBody('{"error":"Unexpected status"}');

    try {
      HttpResponseHandler.handleResponse(response);
      System.assert(
        false,
        'Expected CustomException to be thrown for unexpected status code'
      );
    } catch (HttpResponseHandler.CustomException e) {
      System.assert(
        e.getMessage()
          .contains(
            'Unexpected response: Status 999. Response body: {"error":"Unexpected status"}'
          ),
        'Unexpected exception message: ' + e.getMessage()
      );
    }
  }
}
