#Author: Ravindra Pallerla
@getFairsSettingsDatesTest
Feature: GetFairsSettingsDates API automation tests

  Background: Set config
    * string getFairSettingsDatesUrl = "/bookfairs-jarvis/api/user/fairs/current/settings/dates"

  Scenario Outline: Validate when sessoion cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsDatesUrl
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate when sessoion cookies are invalid
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsDatesUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate 200 response code for a valid request
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsDatesRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.StatusCode == 200
    And print ResponseDataMap.ResponseString

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 |