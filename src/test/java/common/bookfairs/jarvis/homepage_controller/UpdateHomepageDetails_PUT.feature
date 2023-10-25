@UpdateHomepageDetailsTest
Feature: Update HomepageDetails API automation tests

  Background: Set config
    * string updateHomepageDetailsUrl = "/api/user/fairs/current/homepage"

  Scenario Outline: Validate 200 response code for a valid request
    * def inputBody =
      """
        {
          "fairId": '<FAIR_ID>',
          "paymentCheckCkbox": '<PAYMENT_CHECKBOX>'
        }
      """
    * def UpdateHomepageDetailsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@UpdateHomepageDetailsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>', Input_Body : '#(inputBody)'}
    Then match UpdateHomepageDetailsResponseMap.responseStatus == 204

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID | PAYMENT_CHECKBOX |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 | N                |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + updateHomepageDetailsUrl
    And headers {Content-Type : 'application/json'}
    And method PUT
    Then match responseStatus == 401

  Scenario Outline: Validate when invalid cookies are passed
    Given url BOOKFAIRS_JARVIS_URL + updateHomepageDetailsUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method PUT
    Then match responseStatus == 401

    Examples:
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |
