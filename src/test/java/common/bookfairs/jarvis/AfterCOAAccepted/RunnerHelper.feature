@ignore @report=true
Feature: Helper for running Before COA Accepted endpoints

  Background: Set config
    * string getJWTForCOAUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage"
    * string getFairWalletsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage"

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetJWTForCOA
  Scenario: Run get JWT for COA for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getJWTForCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getJWTForCOAUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetFairWallets
  Scenario: Run get wallets for fair for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getFairWalletsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getFairWalletsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get