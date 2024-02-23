@GetFairInfo
Feature: Canada Toolkit ResetPassword API Tests

  # TODO: when dev complete
  Scenario: Mock api
    Given def response = call read('RunnerHelper.feature@GetFairInfo'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200