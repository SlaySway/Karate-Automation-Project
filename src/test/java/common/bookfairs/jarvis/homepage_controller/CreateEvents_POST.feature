@CreateEventsTest
Feature: Create events API automation tests

  Background: Set config
    * string createEventsUrl = "/api/user/fairs/current/homepage/events"

  Scenario Outline: Validate 200 response code for a valid request
    * def inputBody =
      """
        [
  {
    "scheduleDate": "2021-06-16",
    "eventCategory": "Family Event",
    "eventName": "Hello World",
    "startTime": "06:30:00",
    "endTime": "07:30:00",
    "description": "Test 1"
  },
  {
    "scheduleDate": "2021-06-17",
    "eventCategory": "Family Event",
    "eventName": "Hello World 2",
    "startTime": "06:30:00",
    "endTime": "07:30:00",
    "description": "Test 2"
  }
]
      """
    * def CreateEventsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@CreateEventsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>', Input_Body : '#(inputBody)'}
    Then match CreateEventsResponseMap.responseStatus == 200

    @QA
    Examples:
      | USER_NAME                          | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com| passw0rd | 5734325 |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + createEventsUrl
    And headers {Content-Type : 'application/json'}
    And method POST
    Then match responseStatus == 401

  Scenario Outline: Validate when invalid cookies are passed
    Given url BOOKFAIRS_JARVIS_URL + createEventsUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method POST
    Then match responseStatus == 401

    Examples:
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |
