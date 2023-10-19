@getFairsSettingsDatesTest
Feature: GetFairsSettingsDates API automation tests

  Background: Set config
    * string getFairSettingsDatesUri = "/bookfairs-jarvis/api/user/fairs/current/settings/dates"
    * def obj = Java.type('utils.StrictValidation')

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsDatesUri
    When method get
    Then match responseStatus == 401

  Scenario: Validate when session cookies are invalid
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsDatesUri
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method get
    Then match responseStatus == 401

  Scenario Outline: Validate 200 response code for a valid request
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsDatesBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match ResponseDataMap.responseStatus == 200

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 |

  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsDatesBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsDatesRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response

    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com              | passw0rd | 5782058 |
      | mtodaro@scholastic.com              | passw0rd | 5782061 |
      | mtodaro@scholastic.com              | passw0rd | 5782060 |
      | mtodaro@scholastic.com              | passw0rd | 5782056 |
      | mtodaro@scholastic.com              | passw0rd | 5782055 |
      | mtodaro@scholastic.com              | passw0rd | 5782053 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5591617 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644034 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725452 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731880 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725433 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5576627 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5209377 |
      | mtodaro@scholastic.com              | passw0rd | 5782061 |
      | mtodaro@scholastic.com              | passw0rd | 5782060 |
      | mtodaro@scholastic.com              | passw0rd | 5782056 |
      | mtodaro@scholastic.com              | passw0rd | 5782055 |
      | mtodaro@scholastic.com              | passw0rd | 5782053 |
