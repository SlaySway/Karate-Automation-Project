@UpdateFairInfo
Feature: Canada Toolkit Update Volunteer URL API Tests

  # TODO: when dev complete
  Scenario: Mock api
    * def REQUEST_BODY =
    """
    {
      "url": "iamtheurl"
    }
    """
    Given def response = call read('RunnerHelper.feature@UpdateVolunteersUrl'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200

  Scenario: Invalid request body
    * def REQUEST_BODY =
    """
    {
      "url": "iamtheurl"
    }
    """
    Given def response = call read('RunnerHelper.feature@UpdateVolunteersUrl'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200