@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string getFairSettingsUri = "/bookfairs-jarvis/api/user/fairs/current/settings"
    * string externalSCHLCookieUri = "/api/login"
    * string beginFairSessionUri = "/api/login/userAuthorization/fairs"
    * string getFairSettingsUri = "/api/user/fairs/current/settings"
    * string getFairSettingsDatesUri = "/api/user/fairs/current/settings/dates"
    * string setFairBlackOutDatesUri = "/api/user/fairs/current/settings/dates/blackout-dates"

  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairSettingsRunner
  Scenario: Run GetFairsettings api with no other endpoint calls
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    And method GET

  # Input: USER_ID, PWD, FAIRID
  @GetFairSettingsBase
  Scenario: Run GetFairSettings api in base environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_BASE + getFairSettingsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_ID, PWD, FAIRID
  @GetFairSettingsTarget
  Scenario: Run GetFairSettings api in target environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunnerTarget'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_TARGET + getFairSettingsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_ID, PWD, FAIRID
  @getFairSettingsDatesBase
  Scenario: Run getFairSettingsDates api in base environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_BASE + getFairSettingsDatesUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_ID, PWD, FAIRID
  @getFairSettingsDatesTarget
  Scenario: Run getFairSettingsDates api in target environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunnerTarget'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_TARGET + getFairSettingsDatesUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get
