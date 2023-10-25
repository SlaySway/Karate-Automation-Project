@UpdateGoalsTest
Feature: Update Goals API automation tests

  Background: Set config
    * string updateGoalsUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage/goals"

  Scenario Outline: Validate 200 response code for a valid request
    * def inputBody =
      """
   {
    "booksGoal": "608",
    "booksSales": "325",
    "dollarsGoal": "4848",
    "dollarsSales": "2600",
    "bookFairGoalCkbox": "Y",
    "goalPurpose": "2023-10-19T10:49:31.365Z"
  }
      """
    * def UpdateGoalsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@UpdateGoalsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>', Input_Body : '#(inputBody)'}
    Then match UpdateGoalsResponseMap.responseStatus == 200

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

