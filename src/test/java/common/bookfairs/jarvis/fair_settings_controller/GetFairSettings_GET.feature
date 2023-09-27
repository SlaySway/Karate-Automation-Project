@GetFairSettingsTest
Feature: GetfairsSettings API automation tests

  Background: Set config
    * string getFairSettingsUri = "/api/user/fairs/current/settings"

  Scenario Outline: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUrl
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate when sessoion cookies are invalid
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate 200 response code for a valid request
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.StatusCode == 200
    And print ResponseDataMap.ResponseString

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 |

  Scenario Outline: Validate bookfairAccountId is matching with cmdm bookFairId
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    * def CMDMResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/CMDM_Services_RunnerHelper.feature@cmdmgetFairsRunner'){FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.BFAcctId == CMDMResponseDataMap.BFAccountId

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644048 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5591617 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644034 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725452 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731880 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725433 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5576627 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5209377 |

  Scenario Outline: Validate fairType 'case'
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'case'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5790926 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644036 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644040 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644048 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5591617 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644034 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725452 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731880 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725433 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5576627 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5209377 |

  Scenario Outline: Validate fairType 'tabletop'
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'tabletop'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5782070 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5782069 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5782071 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644038 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638185 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5557393 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5414061 |

  Scenario Outline: Validate fairType 'bogo case'
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'bogo case'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638187 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762088 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762089 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762087 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5603785 |

  Scenario Outline: Validate fairType 'bogo tabletop'
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'bogo tabletop'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638186 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644037 |

  Scenario Outline: Validate fairType 'Virtual'
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'Virtual'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731020 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638188 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725454 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731008 |

  Scenario Outline: Validate fairType 'discounted 25%'
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'discounted 25%'

    Examples: 
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |
      | mtodaro@scholastic.com | passw0rd | 5782061 |
      | mtodaro@scholastic.com | passw0rd | 5782060 |
      | mtodaro@scholastic.com | passw0rd | 5782056 |
      | mtodaro@scholastic.com | passw0rd | 5782055 |
      | mtodaro@scholastic.com | passw0rd | 5782053 |


  Scenario Outline: Validate fairType 'discounted 25%'
    * def getFairSettingResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match getFairSettingResponse.response.fairInfo.fairType == 'discounted 25%'

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |

  Scenario Outline: Validate fairType 'discounted 25%' alternative
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@AltBeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)'}
    * def getFairSettingResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@AltGetFairSettingsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingResponse.response.fairInfo.fairType == 'discounted 25%'

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |

  Scenario Outline: Validate SBF_JARVIS does not match SCHL
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@AltBeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)'}
    * def getFairSettingResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@AltGetFairSettingsRunner'){SCHL: '', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingResponse.response.errorMessage == "SBF_JARVIS does not match SCHL"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |