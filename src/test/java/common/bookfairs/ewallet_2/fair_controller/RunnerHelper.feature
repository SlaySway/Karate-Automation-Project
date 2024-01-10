@ignore @report=true
Feature: Helper for running fair-controller endpoints

  Background: Set config
    * string reopenFairByFairIdUri = "/api/fair/<fairId>/reopen"
    * string updateFairChecksByFairIdUri = "/api/fair/<fairId>"
    * string closeFairByFairIdUri = "/api/fair/<fairId>/close"
    * string resolveClosedFairTransactionsUri = "/api/fair/resolveCloseFairTransactions"
    * string closeFairsUri = "/api/fair/close-fairs"
    * string getWalletsByFairIdUri = "/api/fair/<fairId>/wallets"

  # Input: FAIRID
  # Output: response
  @ReopenFairByFairId
  Scenario: Reopen the fair for ewallets to be added for fair: <FAIRID_OR_CURRENT>
    * replace reopenFairByFairIdUri.fairId = FAIRID
    * url BOOKFAIRS_EWALLET_2_URL + reopenFairByFairIdUri
    Then method PUT

  # Input: FAIRID, disableFairApiCheck, disablePosApiCheck
  # Output: response
  @UpdateFairChecksByFairId
  Scenario: Update the checks for closing the fair for fair: <FAIRID_OR_CURRENT>
    * replace updateFairChecksByFairIdUri.fairId = FAIRID
    * url BOOKFAIRS_EWALLET_2_URL + updateFairChecksByFairIdUri
    * params {disableFairApiCheck: disableFairApiCheck, disbalePosApiCheck: disablePosApiCheck}
    Then method POST

  # Input: FAIRID
  # Output: response
  @CloseFairByFairId
  Scenario: Close the ewallets of the fair for fair: <FAIRID_OR_CURRENT>
    * replace closeFairByFairIdUri.fairId = FAIRID
    * url BOOKFAIRS_EWALLET_2_URL + closeFairByFairIdUri
    Then method POST

  # Output: response
  @ResolveClosedFairTransactions
  Scenario: Resolve all transactions for all closed ewallets in a closed fair
    * url BOOKFAIRS_EWALLET_2_URL + resolveClosedFairTransactionsUri
    Then method POST

  # Output: response
  @CloseFairs
  Scenario: Close fairs
    * url BOOKFAIRS_EWALLET_2_URL + closeFairsUri
    Then method POST

  # Input: FAIRID
  # Output: response
  @GetWalletsByFairId
  Scenario: Get all the wallets for fair: <FAIRID_OR_CURRENT>
    * replace getWalletsByFairIdUri.fairId = FAIRID
    * url BOOKFAIRS_EWALLET_2_URL + getWalletsByFairIdUri
    Then method GET