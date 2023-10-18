@GetHomepageDetailsTest
Feature: HomepageDetails API automation tests

  Background: Set config
    * string getHomepageDetailsUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage"

Scenario Outline: Validate 200 response code for a valid request
  * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
  * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
  * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
  Then match getHomepageDetailsResponse.responseStatus == 200

Examples:
| USER_NAME                          | PASSWORD | FAIR_ID |
| azhou1@scholastic.com              | password1| 5633533 |
| sdevineni-consultant@scholastic.com| passw0rd | 5734325 |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + getHomepageDetailsUrl
    And headers {Content-Type : 'application/json'}
    And method GET
    Then match responseStatus == 401

    Scenario Outline: Validate when invalid cookies are passed
      Given url BOOKFAIRS_JARVIS_URL + getHomepageDetailsUrl
      And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
      When method GET
      Then match responseStatus == 401

      Examples:
        | USER_NAME                    | PASSWORD |
        | sd-consultant@scholastic.com | passw0rd |


