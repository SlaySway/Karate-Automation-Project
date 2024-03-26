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

  Scenario: Functional test of user setting and getting events
    # User sets zero event
    # Check there is zero events
    # User sets 1 event
    # Check there is 1 event
    # User sets 2 events
    # Check there is 2 events

  Scenario: User cannot set event for another fair

  Scenario: User sends an invalid request body

  Scenario: User

    # User attempts sending extra field

  # User attempts sending without a field

  # Reference https://jira.sts.scholastic.com/browse/BFS-1847 for scenarios
