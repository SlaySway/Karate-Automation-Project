@GetHomepageDetailsTest
Feature: HomepageDetails API automation tests

  Background: Set config
    * string getHomepageDetailsUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage"

  Scenario Outline: Validate 200 response code for a valid request
    * def getHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match getHomepageDetailsResponse.responseStatus == 200

    Examples:
      | USER_NAME                           | PASSWORD  | FAIR_ID |
      | azhou1@scholastic.com               | password1 | 5633533 |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5734325 |

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

