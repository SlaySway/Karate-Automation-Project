@GetFairSettingsTest
Feature: GetfairsSettings API automation tests

  Background: Set config
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