@UpdateFairInfo
Feature: Canada Toolkit Update Volunteer URL API Tests

  # TODO: when dev complete
  Scenario: Mock api
    * def REQUEST_BODY =
    """
        i am the url
    """
    Given def response = call read('RunnerHelper.feature@UpdateFairInfo'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200