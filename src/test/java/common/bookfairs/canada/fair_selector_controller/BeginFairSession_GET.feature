@BeginFairSession
Feature: Canada Toolkit begin fair session API Tests

  # TODO: when dev complete
  Scenario: Mock api
    Given def response = call read('RunnerHelper.feature@BeginFairSession'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200