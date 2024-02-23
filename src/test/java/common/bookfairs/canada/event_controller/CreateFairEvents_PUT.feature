@UpdateFairEvents
Feature: Canada Toolkit ResetPassword API Tests

  # TODO: when dev complete
  Scenario: Mock api
    * def REQUEST_BODY =
    """
    [
      {
          "eventDate": "2021-06-12",
          "eventCategory": "Family Event",
          "eventTitle": "Breakfast and Books",
          "startTime": "06:30:00",
          "endTime": "07:30:00",
          "englishDetailMessage": "Test 102 Jul 18th",
          "frenchDetailMessage": "Test 102 Jul 18th"
      }
    ]
    """
    Given def response = call read('RunnerHelper.feature@UpdateFairEvents'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200