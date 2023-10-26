@PutEnableEwalletTest
Feature: Enable Ewallet API automation tests

  Background: Set config
    * string putEnableEwallet = "/bookfairs-jarvis/api/private/fairs/current/ewallet/enable"

  Scenario Outline: Validate 200 response code for a valid request
    * def PutEnableEwalletResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_old_controller/FairSettingsOldRunnerHelper.feature@PutEnableEwalletRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match PutEnableEwalletResponseMap.responseStatus == 200
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.ewallet.enabled == true

    @QA
    Examples:
      | USER_NAME                          | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com| passw0rd | 5734325 |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + putEnableEwallet
    And headers {Content-Type : 'application/json'}
    And method PUT
    Then match responseStatus == 401

  Scenario Outline: Validate when invalid cookies are passed
    Given url BOOKFAIRS_JARVIS_URL + putEnableEwallet
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method PUT
    Then match responseStatus == 401

    Examples:
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |
