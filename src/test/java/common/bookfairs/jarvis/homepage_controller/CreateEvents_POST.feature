@CreateEventsTest
Feature: Create events API automation tests

  Background: Set config
    * string createEventsUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"

  Scenario Outline: Validate 200 response code for a valid request
    * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    And json originalEvents = getHomepageDetailsResponse.response.events
    * def originalNumOfEvents = originalEvents.length
    * print originalNumOfEvents
    * def CreateEventsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@CreateEventsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match CreateEventsResponseMap.responseStatus == 200
    * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    And json currentEvents = getHomepageDetailsResponse.response.events
    * def newNumOfEvents = currentEvents.length
    And assert newNumOfEvents > originalNumOfEvents

    @QA
    Examples:
      |USER_NAME                           | PASSWORD  | FAIR_ID |
      |sdevineni-consultant@scholastic.com | passw0rd  | 5383023 |

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
