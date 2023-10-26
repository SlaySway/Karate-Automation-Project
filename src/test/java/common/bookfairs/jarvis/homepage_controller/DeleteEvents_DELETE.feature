@DeleteEventsTest
Feature: Delete events API automation tests

  Background: Set config
    * string deleteEventsUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"

  Scenario Outline: Validate 200 response code for a valid request
    * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    And json originalEvents = getHomepageDetailsResponse.response.events
    * def originalNumOfEvents = originalEvents.length
    * print originalNumOfEvents
    * def inputBody =
      """
      [
         {
          "scheduleDate": "2021-06-22",
          "eventCategory": "School Event",
          "eventName": "Hello World 3",
          "startTime": "05:30:00",
          "endTime": "08:30:00",
          "description": "Test 3"
        }
       ]
      """
    * def DeleteEventsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@DeleteEventsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>', Input_Body : '#(inputBody)'}
    Then match DeleteEventsResponseMap.responseStatus == 200
    * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    And json currentEvents = getHomepageDetailsResponse.response.events
    * def newNumOfEvents = currentEvents.length
    And assert newNumOfEvents < originalNumOfEvents

    @QA
    Examples:
      | USER_NAME                          | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com| passw0rd | 5734323 |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + deleteEventsUrl
    And headers {Content-Type : 'application/json'}
    And method PUT
    Then match responseStatus == 401

  Scenario Outline: Validate when invalid cookies are passed
    Given url BOOKFAIRS_JARVIS_URL + deleteEventsUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method PUT
    Then match responseStatus == 401

    Examples:
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |
