@GetFairSettingsTest
Feature: GetfairsSettings API automation tests

  Background: Set config
    * string getFairSettingsUri = "/api/user/fairs/current/settings"

  Scenario: Validate when session cookies are not passed
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL: '', SBF_JARVIS : ''}
    Then match getFairSettingsResponse.response.statusCode == 401

  Scenario: Validate when sessoion cookies are invalid
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL: 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ'}
    Then match responseStatus == 401

  Scenario Outline: Validate 200 response code for a valid request
#    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
#    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID: '<FAIR_ID>'}
    Then getFairSettingsResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 |

  Scenario Outline: Validate bookfairAccountId is matching with cmdm bookFairId

    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    * def cmdmGetFairResponse = call read('classpath:common/cmdm/fairs/CMDMRunnerHelper.feature@GetFairRunner'){FAIR_ID : '<FAIR_ID>'}
    Then match getFairSettingsResponse.response.fairInfo.bookfairAccountId == cmdmGetFairResponse.response.organization.bookfairAccountId

    @QA
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
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'case'

    @QA
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
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'tabletop'

    @QA
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
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'bogo case'

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638187 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762088 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762089 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762087 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5603785 |

  Scenario Outline: Validate fairType 'bogo tabletop'
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'bogo tabletop'

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638186 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644037 |

  Scenario Outline: Validate fairType 'Virtual'
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'Virtual'

    @QA
    Examples:
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731020 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638188 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725454 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731008 |

  Scenario Outline: Validate fairType 'discounted 25%'
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)', FAIR_ID : '<FAIR_ID>'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@GetFairSettingsRunner'){SCHL : '#(schlResponse.SCHL)', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingsResponse.response.fairInfo.fairType == 'discounted 25%'

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |

  Scenario Outline: Validate SBF_JARVIS does not match SCHL
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>'}
    * def beginFairSessionResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@AltBeginFairSessionRunner'){SCHL : '#(schlResponse.SCHL)'}
    * def getFairSettingsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@AltGetFairSettingsRunner'){SCHL: '', SBF_JARVIS : '#(beginFairSessionResponse.SBF_JARVIS)'}
    Then match getFairSettingsResponse.response.errorMessage == "SBF_JARVIS does not match SCHL"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |