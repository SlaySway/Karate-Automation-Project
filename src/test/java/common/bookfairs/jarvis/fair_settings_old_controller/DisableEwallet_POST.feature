@PostDisableEwalletTest
Feature: Disable Ewallet API automation tests

  Background: Set config
    * string putDisableEwallet = "/api/private/fairs/current/ewallet/disable"

  Scenario Outline: Validate 200 response code for a valid request
    * def PostDisableEwalletResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_old_controller/FairSettingsOldRunnerHelper.feature@PostDisableEwalletRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match PostDisableEwalletResponseMap.responseStatus == 200

    @QA
    Examples:
      | USER_NAME                          | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com| passw0rd | 5734325 |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + putDisableEwallet
    And headers {Content-Type : 'application/json'}
    And method POST
    Then match responseStatus == 401

  Scenario Outline: Validate when invalid cookies are passed
    Given url BOOKFAIRS_JARVIS_URL + putDisableEwallet
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method POST
    Then match responseStatus == 401

    Examples:
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |
