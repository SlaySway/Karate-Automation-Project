@ignore @report=true
Feature: Helper for running session-controller endpoints

  Background: Set config
    * string getWalletTransactionsUri = "/api/wallets/<walletId>/transactions"
    * string createWalletTransactionsUri = "/api/wallets/<walletId>/transactions"
    * string getWalletsForFairUri = "/api/wallets"
    * string createWalletRefundUri = "/api/wallets/<walletId>/transactions/<transactionId>/refunds"

  # Input: USER_NAME, PASSWORD, FAIRID, WALLETID
  # Output: response
  @GetWalletTransactions
  Scenario: Get the transactions for the wallet for user: <USER_NAME>, fair: <FAIRID>, and wallet: <WALLETID>
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace getWalletTransactionsUri.walletId = WALLETID
    * url BOOKFAIRS_PAYPORTAL_URL + getWalletTransactionsUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0 : '#(sessionResponse.PP2)'}
    Then method GET

  # Input: USER_NAME, PASSWORD, FAIRID, WALLETID, REQUEST_BODY
  # Output: response
  @CreateWalletTransactions
  Scenario: Create a transactions for the wallet for user: <USER_NAME>, fair: <FAIRID>, and wallet: <WALLETID>
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createWalletTransactionsUri.walletId = WALLETID
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletTransactionsUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0 : '#(sessionResponse.PP2)'}
    * request REQUEST_BODY
    Then method POST

  # Input: USER_NAME, PASSWORD, FAIRID
  # Output: response
  @GetWalletsForFair
  Scenario: Get the wallets related to the fair for user: <USER_NAME> and fair: <FAIRID>
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * url BOOKFAIRS_PAYPORTAL_URL + getWalletsForFairUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method GET

  # Input: USER_NAME, PASSWORD, FAIRID, WALLETID, TRANSACTIONID
  # Output: response
  @CreateWalletRefund
  Scenario: Create a wallet refund on the transaction for user: <USER_NAME>, fair: <FAIRID>, wallet: <WALLETID> transaction: <TRANSACTIONID>
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createWalletRefundUri.fairIdOrCurrent = WALLETID
    * replace createWalletRefundUri.transactionId = TRANSACTIONID
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletRefundUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method POST