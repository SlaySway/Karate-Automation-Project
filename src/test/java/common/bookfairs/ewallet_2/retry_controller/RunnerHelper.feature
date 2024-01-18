@ignore @report=true
Feature: Helper for retry-controller endpoints

  Background: Set config
    * string retryResolvingWalletsUri = "/api/resolve-wallet/retry"
    * string retryFundingUri = "/api/fund/retry"

  # Output: response
  @RetryResolveWallet
  Scenario: Run retry resolve wallet
    * url BOOKFAIRS_EWALLET_2_URL + retryResolvingWalletsUri
    Then method POST

  # Output: response
  @RetryFundingWallet
  Scenario: Run retry funding wallet
    * url BOOKFAIRS_EWALLET_2_URL + retryFundingUri
    Then method POST