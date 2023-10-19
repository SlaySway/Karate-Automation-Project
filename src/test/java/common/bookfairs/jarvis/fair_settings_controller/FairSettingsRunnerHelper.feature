@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string getFairSettingsUri = "/bookfairs-jarvis/api/user/fairs/current/settings"
    * string getFairSettingsDatesUri = "/bookfairs-jarvis/api/user/fairs/current/settings/dates"
    * string setFairBlackOutDatesUri = "/bookfairs-jarvis/api/user/fairs/current/settings/dates/blackout-dates"

  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairSettingsRunner
  Scenario: Run GetFairsettings api with no other endpoint calls
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    And method GET

  # Input: USER_NAME, PWD, FAIR_ID
  @GetFairSettingsBase
  Scenario: Run GetFairSettings api in base environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_BASE + getFairSettingsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_NAME, PWD, FAIR_ID
  @GetFairSettingsTarget
  Scenario: Run GetFairSettings api in target environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunnerTarget'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_TARGET + getFairSettingsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_NAME, PWD, FAIR_ID
  @GetFairSettingsDatesBase
  Scenario: Run getFairSettingsDates api in base environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_BASE + getFairSettingsDatesUri
    * print loginAuthorizationResponse
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_NAME, PWD, FAIR_ID
  @GetFairSettingsDatesTarget
  Scenario: Run getFairSettingsDates api in target environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunnerTarget'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_TARGET + getFairSettingsDatesUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get
