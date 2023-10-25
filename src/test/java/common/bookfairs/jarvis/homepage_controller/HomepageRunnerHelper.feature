@ignore @report=true
Feature: Helper for running homepage-controller apis

  Background: Set config
    * string getHomepageDetailsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage"
    * string updateHomepageDetailsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage"
    * string updateEventsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"
    * string updateGoalsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/goals"
    * string createEventsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"
    * string deleteEventsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"

  # Input: SCHL, SBF_JARVIS
  # Output: Homepage details in response
  @GetHomepageDetailsRunner
  Scenario: Run GetHomepageDetails api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + getHomepageDetailsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method GET

# Input: SCHL, SBF_JARVIS, Homepage details to be updated as request body
  # Output: Updated homepage details in response
  @UpdateHomepageDetailsRunner
  Scenario: Run UpdateHomepageDetails api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + updateHomepageDetailsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def putPayload = {inputBody : '#(Input_Body)'}
    And request putPayload
    When method PUT

    # Input: SCHL, SBF_JARVIS, Event details to be updated as request body
    # Output: Updated Event details in response
  @UpdateEventsRunner
  Scenario: Run UpdateEvents api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + updateEventsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def putPayload = {inputBody : '#(Input_Body)'}
    And request putPayload
    When method PUT

    # Input: SCHL, SBF_JARVIS, Goals details to be updated as request body
    # Output: response
  @UpdateGoalsRunner
  Scenario: Run UpdateGoals api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + updateGoalsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def putPayload = {inputBody : '#(Input_Body)'}
    And request putPayload
    When method PUT

    # Input: SCHL, SBF_JARVIS, New event details to be created as request body
    # Output: response
  @CreateEventsRunner
  Scenario: Run CreateEvents api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + createEventsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def putPayload = {inputBody : '#(Input_Body)'}
    And request putPayload
    When method POST

        # Input: SCHL, SBF_JARVIS, Events to be deleted as request body
        # Output: response
  @DeleteEventsRunner
  Scenario: Run DeleteEvents api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + deleteEventsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def putPayload = {inputBody : '#(Input_Body)'}
    And request putPayload
    When method DELETE