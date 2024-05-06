@GetFairSessionInfo
Feature: Canada Toolkit get fair session info API Tests

  # TODO: when dev complete
  Scenario: Mock api
    Given def response = call read('RunnerHelper.feature@GetFairSessionInfo'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200