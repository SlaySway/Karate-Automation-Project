@UpdateGoalsTest
Feature: Update Goals API automation tests

  Background: Set config
    * string updateGoalsUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage/goals"

  Scenario Outline: Validate 200 response code for a valid request
    * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    And json OriginalBookfairGoalCkbox = getHomepageDetailsResponse.response.goals.onlineHomepage.bookFairGoalCkbox
    * def UpdateGoalsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@UpdateGoalsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>', Input_Body : '#(inputBody)'}
    Then match UpdateGoalsResponseMap.responseStatus == 200
    * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    And json CurrentBookfairGoalCkbox = getHomepageDetailsResponse.response.goals.onlineHomepage.bookFairGoalCkbox
    And match OriginalBookfairGoalCkbox != CurrentBookfairGoalCkbox

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + updateGoalsUrl
    And headers {Content-Type : 'application/json'}
    And method PUT
    Then match responseStatus == 401

  Scenario Outline: Validate when invalid cookies are passed
    Given url BOOKFAIRS_JARVIS_URL + updateGoalsUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method PUT
    Then match responseStatus == 401

    Examples:
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

