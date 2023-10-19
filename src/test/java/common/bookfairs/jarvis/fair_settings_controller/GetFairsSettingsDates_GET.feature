@getFairsSettingsDatesTest
Feature: GetFairsSettingsDates API automation tests

  Background: Set config
    * string getFairSettingsDatesUrl = "/api/user/fairs/current/settings/dates"
    * def obj = Java.type('utils.StrictValidation')

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

  Scenario Outline: Validate regression using dynamic comaprison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairSettingsDatesBase'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairSettingsDatesTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match BaseResponseMap.BaseStatCd == TargetResponseMap.TargetStatCd
    * def compResult = obj.strictCompare(BaseResponseMap.BaseResponse, TargetResponseMap.TargetResponse)
    Then print "Response from production code base", BaseResponseMap.BaseResponse
    Then print "Response from current qa code base", TargetResponseMap.TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponseMap.BaseResponse == TargetResponseMap.TargetResponse

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
