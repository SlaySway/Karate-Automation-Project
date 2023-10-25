@PutOnlineFairToggleTest
Feature: Online fair toggle API automation tests

  Background: Set config
    * string putOnlineFairToggleUrl = "/bookfairs-jarvis/api/private/fairs/current/onlinefair/toggle"

  Scenario Outline: Validate 200 response code for a valid request
    * def PutOnlineFairToggleResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_old_controller/FairSettingsOldRunnerHelper.feature@PutOnlineFairToggleRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match PutOnlineFairToggleResponseMap.responseStatus == 200

    @QA
    Examples:
      | USER_NAME                          | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com| passw0rd | 5734325 |

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + putOnlineFairToggleUrl
    And headers {Content-Type : 'application/json'}
    And method PUT
    Then match responseStatus == 401

  Scenario Outline: Validate when invalid cookies are passed
    Given url BOOKFAIRS_JARVIS_URL + putOnlineFairToggleUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method PUT
    Then match responseStatus == 401

    Examples:
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |
