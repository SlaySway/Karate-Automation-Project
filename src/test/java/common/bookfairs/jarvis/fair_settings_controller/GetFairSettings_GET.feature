@GetFairSettingsTest
Feature: GetfairsSettings API automation tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getFairSettingsUri = "/bookfairs-jarvis/api/user/fairs/current/settings"

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    When method GET
    Then match responseStatus == 401

  Scenario: Validate when session cookies are invalid
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    And cookies { SCHL : 'invalid', SBF_JARVIS: 'invalid'}
    When method GET
    Then match responseStatus == 401

  Scenario Outline: Validate 200 response code for a valid request
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then getFairSettingsResponse.responseStatus == 200

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 |

  Scenario Outline: Validate bookfairAccountId is matching with cmdm bookFairId
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    * def cmdmGetFairResponse = call read('classpath:common/cmdm/fairs/CMDMRunnerHelper.feature@GetFairRunner'){FAIR_ID : '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.fairInfo.bookfairAccountId == cmdmGetFairResponse.response.organization.bookfairAccountId

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate fairType 'case'
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'case'

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate fairType 'tabletop'
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'tabletop'

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5782070 |

  Scenario Outline: Validate fairType 'bogo case'
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'bogo case'

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638187 |

  Scenario Outline: Validate fairType 'bogo tabletop'
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'bogo tabletop'

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638186 |

  Scenario Outline: Validate fairType 'Virtual'
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'Virtual'

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731020 |

  Scenario Outline: Validate fairType 'discounted 25%'
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'discounted 25%'

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |

  Scenario Outline: Validate SBF_JARVIS does not match SCHL
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.errorMessage == "SBF_JARVIS does not match SCHL"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |

  Scenario Outline: Validate regression using dynamic comaprison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsBase'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
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
