@UpdateFairContactInfo
Feature: Canada Toolkit ResetPassword API Tests

  # TODO: when dev complete
  Scenario: Mock api
    * def REQUEST_BODY =
    """
    {
      "firstName": "string",
      "lastName": "string",
      "email": "string",
      "phoneNumber": "string",
      "displayContactOnHomePage": true,
      "displayEmailOnHomePage": true
    }
    """
    Given def response = call read('RunnerHelper.feature@UpdateFairContactInfo'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200