@ignore @report=true
Feature: Helper for fund-controller endpoints

  Background: Set config
    * string fundWalletByWalletIdUri = "/api/wallets/<walletId>/fund"

  # Input: WALLETID, REQUEST_BODY
  # Output: response
  @FundWalletByWalletId
  Scenario: Fund a wallet for wallet: <WALLETID>
    * replace fundWalletByWalletIdUri.walletId = WALLETID
    * url BOOKFAIRS_EWALLET_2_URL + fundWalletByWalletIdUri
    * request REQUEST_BODY
    Then method POST