@UpdateEventsTest
Feature: Update Events API automation tests

  Background: Set config
    * string updateEventsUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"

  Scenario Outline: Validate 200 response code for a valid request
    * json getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    And json HomepageRes = getHomepageDetailsResponse.response
    * print HomepageRes
    * def OriginalEventName = getHomepageDetailsResponse.response.events.eventName
    * def getDate =
  """
  function() {
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    var sdf = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss.sss');
    var date = new java.util.Date();
    return sdf.format(date);
  }
  """
     * def temp = getDate()
     * print temp
     * def requestBody =
      """
      [
    {
        "id": 1,
        "scheduleDate": "2021-06-12",
        "createDate": "2023-10-25T15:48:17.43",
        "eventCategory": "TEST Event",
        "eventName": '#(temp)',
        "startTime": "06:30:00",
        "endTime": "07:30:00",
        "description": "Test 102 Jul 18th"
    }
]
      """
    * def UpdateEventsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@UpdateEventsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>', REQUEST_BODY : '#(requestBody)'}
    Then match UpdateEventsResponseMap.responseStatus == 200
    * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    * def CurrentEventName = getHomepageDetailsResponse.response.events[0].eventName
    * print CurrentEventName
    And match CurrentEventName != OriginalEventName
    And match CurrentEventName == temp

    @QA
    Examples:
      | USER_NAME               | PASSWORD  | FAIR_ID |
      | azhou1@scholastic.com   | password1 | 5782595 |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + updateEventsUrl
    And headers {Content-Type : 'application/json'}
    And method PUT
    Then match responseStatus == 401

  Scenario Outline: Validate when invalid cookies are passed
    Given url BOOKFAIRS_JARVIS_URL + updateEventsUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method PUT
    Then match responseStatus == 401

    Examples:
      | USER_NAME               | PASSWORD  |
      | azhou1@scholastic.com   | password1 |
