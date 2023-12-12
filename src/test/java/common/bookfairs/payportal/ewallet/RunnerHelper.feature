@ignore @report=true
Feature: Helper for running session-controller endpoints

  Background: Set config
    * string createWalletRefundUri = "/api/wallets/<walletId>/transactions"
    * string createWalletTransactionsUri = "/api/wallets/<walletId>/transactions"
    * string getWalletsForFairUri = "/api/wallets"
    * string getWalletTransactionsUri = "/api/wallets/<walletId>/transactions/<transactionId>/refunds"

  # Input: USER_NAME, PASSWORD, FAIRID
  # Output: response
  @CreateSession
  Scenario: Run create payportal 2.0 session for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * param fairId = FAIRID
    * url BOOKFAIRS_PAYPORTAL_URL + createSessionUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method POST
    * def SCHL = schlResponse.SCHL
    * print "cookies: ", responseCookies
    * def PP2 = responseCookies["PP2.0"].value

  # Input: USER_NAME, PASSWORD, FAIRID
  # Output: response
  @GetSessionInfo
  Scenario: Run get session info for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    Given def sessionResponse = call read('RunnerHelper.feature@CreateSession'){FAIR_ID: '#(FAIRID)'}
    * url BOOKFAIRS_PAYPORTAL_URL + getSessionInfoUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method GET

  # Input: USER_NAME, PASSWORD, FAIRID
  # Output: response
  @GetSessionIdentifiers
  Scenario: Run get session identigiers for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    Given def sessionResponse = call read('RunnerHelper.feature@CreateSession'){FAIR_ID: '#(FAIRID)'}
    * replace getFairHomepageUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_PAYPORTAL_URL + getSessionIdentifiersUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method GET