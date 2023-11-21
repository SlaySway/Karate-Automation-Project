@ignore @report=true
Feature: Helper for running After COA Accepted endpoints

  Background: Set config
    * string getFairWalletsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/ewallets"
    * string getFairHomepageUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage"
    * string updateFairHomepageUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage"
    * string updateHomepageEventsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage/events"
    * string createHomepageEventsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage/events"
    * string deleteHomepageEventsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage/events"
    * string updateHomepageGoalsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage/goals"
    * string getFairSettingsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings"
    * string setFairCoChairsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/co-chairs"
    * string toggleFairWalletStatusUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/ewallets"
    * string toggleFairOnlineFairStatusUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/online-fair"


  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetFairWallets
  Scenario: Run get wallets for fair for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getFairWalletsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getFairWalletsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetFairHomepage
  Scenario: Run get fair homepage for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getFairHomepageUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getFairHomepageUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, REQUEST_BODY
  # Output: response
  @UpdateFairHomepage
  Scenario: Run update homepage for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>, and request body: <REQUEST_BODY>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateFairHomepageUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateFairHomepageUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request REQUEST_BODY
    Then method put

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, REQUEST_BODY
  # Output: response
  @UpdateHomepageEvents
  Scenario: Run update homepage events for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>, and request body: <REQUEST_BODY>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateHomepageEventsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateHomepageEventsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request REQUEST_BODY
    Then method put

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, REQUEST_BODY
  # Output: response
  @CreateHomepageEvents
  Scenario: Run create homepage events for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>, and request body: <REQUEST_BODY>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace createHomepageEventsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + createHomepageEventsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request REQUEST_BODY
    Then method post

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, REQUEST_BODY
  # Output: response
  @DeleteHomepageEvents
  Scenario: Run delete homepage events for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>, and request body: <REQUEST_BODY>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace deleteHomepageEventsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + deleteHomepageEventsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request REQUEST_BODY
    Then method delete

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, REQUEST_BODY
  # Output: response
  @UpdateHomepageGoals
  Scenario: Run update homepage goals for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>, and request body: <REQUEST_BODY>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateHomepageGoalsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateHomepageGoalsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request REQUEST_BODY
    Then method put

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetFairSettings
  Scenario: Run get fair settings for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getFairSettingsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, REQUEST_BODY
  # Output: response
  @SetFairCoChairs
  Scenario: Run update fair cochairs for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>, and request body: <REQUEST_BODY>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateFairCochairsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + setFairCoChairsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request REQUEST_BODY
    Then method put

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, REQUEST_BODY
  # Output: response
  @ToggleFairWalletStatus
  Scenario: Run toggle fair ewallet status for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>, and request body: <REQUEST_BODY>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace toggleFairWalletStatusUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + toggleFairWalletStatusUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request REQUEST_BODY
    Then method put

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, REQUEST_BODY
  # Output: response
  @ToggleFairOnlineFairStatus
  Scenario: Run toggle fair online fair status for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>, and request body: <REQUEST_BODY>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace toggleFairOnlineFairStatusUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + toggleFairOnlineFairStatusUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request REQUEST_BODY
    Then method put