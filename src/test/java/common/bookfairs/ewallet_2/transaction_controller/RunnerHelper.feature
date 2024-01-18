@ignore @report=true
Feature: Helper for running After COA Accepted endpoints

  Background: Set config
    * string createWalletTransactionUri = "/api/wallets/<walletId>/transaction"
    * string createWalletReleaseUri = "/api/wallets/<walletId>/release"


  # Input: WALLETID, REQUEST_BODY
  # Output: response
  @CreateWalletTransaction
  Scenario: Create a sales transaction for wallet: <WALLETID>
    * replace createWalletTransactionUri.walletId = WALLETID
    * url BOOKFAIRS_EWALLET_2_URL + createWalletTransactionUri
    * request REQUEST_BODY
    Then method POST

  # Input: WALLETID, REQUEST_BODY
  # Output: response
  @CreateWalletRelease
  Scenario: Create release of wallet balance for wallet: <WALLETID>
    * replace createWalletTransactionUri.walletId = WALLETID
    * url BOOKFAIRS_EWALLET_2_URL + createWalletTransactionUri
    * request REQUEST_BODY
    Then method POST