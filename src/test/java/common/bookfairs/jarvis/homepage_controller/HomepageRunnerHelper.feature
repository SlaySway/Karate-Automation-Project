@ignore @report=true
Feature: Helper for running homepage-controller apis

  Background: Set config
    * string getHomepageDetailsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage"
    * string updateHomepageDetailsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage"
    * string updateEventsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"
    * string updateGoalsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/goals"
    * string createEventsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"
    * string deleteEventsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"

  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetHomepageDetailsRunner
  Scenario: Run GetHomepageDetails api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + getHomepageDetailsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method GET

# Input: USER_NAME, PASSWORD, FAIR_ID, Homepage details to be updated as request body
  # Output: Updated homepage details in response
  @UpdateHomepageDetailsRunner
  Scenario: Run UpdateHomepageDetails api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + updateHomepageDetailsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def putPayload = {inputBody : '#(Input_Body)'}
    And request putPayload
    When method PUT

    # Input: USER_NAME, PASSWORD, FAIR_ID, Event details to be updated as request body
    # Output: Updated Event details in response
  @UpdateEventsRunner
  Scenario: Run UpdateEvents api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + updateEventsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    And request inputBody
    When method PUT

    # Input: USER_NAME, PASSWORD, FAIR_ID, Goals details to be updated as request body
    # Output: response
  @UpdateGoalsRunner
  Scenario: Run UpdateGoals api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + updateGoalsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def inputBody =
      """
   {
    "booksGoal": "608",
    "booksSales": "325",
    "dollarsGoal": "4848",
    "dollarsSales": "2600",
    "bookFairGoalCkbox": "N",
    "goalPurpose": "2023-10-19T10:49:31.365Z"
  }
      """
    And request inputBody
    When method PUT

    # Input: USER_NAME, PASSWORD, FAIR_ID, New event details to be created as request body
    # Output: response
  @CreateEventsRunner
  Scenario: Run CreateEvents api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + createEventsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def requestBody =
      """
      [
         {
          "scheduleDate": "2021-06-22",
          "eventCategory": "School Event",
          "eventName": "Hello World 3",
          "startTime": "05:30:00",
          "endTime": "08:30:00",
          "description": "Test 3"
        }
       ]
      """
    And request requestBody
    When method POST

        # Input: USER_NAME, PASSWORD, FAIR_ID, Events to be deleted as request body
        # Output: response
  @DeleteEventsRunner
  Scenario: Run DeleteEvents api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + deleteEventsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def putPayload = {inputBody : '#(Input_Body)'}
    And request putPayload
    When method DELETE