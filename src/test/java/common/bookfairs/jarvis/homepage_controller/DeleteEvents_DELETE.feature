@DeleteEventsTest
Feature: Delete events API automation tests

  Background: Set config
    * string deleteEventsUrl = "/api/user/fairs/current/homepage/events"

  Scenario Outline: Validate 200 response code for a valid request
    * def inputBody =
      """
      [
        {
        "id": 1,
        "scheduleDate": "2021-06-12",
        "createDate": "2023-10-18T18:57:19.9",
        "eventCategory": "Family Event",
        "eventName": "2023-05-17 14:53:55.127",
        "startTime": "06:30:00",
        "endTime": "07:30:00",
        "description": "Test 102 Jul 18th"
        }
      ]
      """
    * def DeleteEventsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@DeleteEventsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>', Input_Body : '#(inputBody)'}
    Then match DeleteEventsResponseMap.responseStatus == 200

    @QA
    Examples:
      | USER_NAME                          | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com| passw0rd | 5734325 |

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
