@GetVolunteersUrl
Feature: Canada Toolkit Get Volunteers URL API Tests

  # TODO: when dev complete
  Scenario: Mock api
    Given def response = call read('RunnerHelper.feature@GetVolunteersUrl'){FAIR_ID:"51234", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200