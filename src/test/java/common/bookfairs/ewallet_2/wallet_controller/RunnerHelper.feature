@ignore @report=true
Feature: Helper for running wallet-controller endpoints

  Background: Set config
    * string getWalletByWalletIdUri = "/api/wallets/<walletId>"
    * string updateWalletInfoByWalletIdUri = "/api/wallets/<walletId>"
    * string closeWalletByWalletIdUri = "/api/wallets/<walletId>"
    * string moveWalletToOtherFairUri = "/api/wallets/<walletId>/to/<fairId>"
    * string getWalletsByParametersUri = "/api/wallets"
    * string createWalletUri = "/api/wallets"
    * string backfillBatchesUri = "/api/wallets/backfill-uuids/batches/<numBatches>/per-batch/<perBatch>"

  # Input: WALLETID
  # Output: response
  @GetWalletByWalletID
  Scenario: Get wallet by wallet id: <WALLETID>
    * replace getWalletByWalletIdUri.walletId = WALLETID
    * url BOOKFAIRS_EWALLET_2_URL + getWalletByWalletIdUri
    Then method GET

  # Input: WALLETID, REQUEST_BODY
  # Output: response
  @UpdateWalletInfoByWalletId
  Scenario: Update wallet info by wallet id: <WALLETID>
    * replace updateWalletInfoByWalletIdUri.walletId = WALLETID
    * url BOOKFAIRS_EWALLET_2_URL + updateWalletInfoByWalletIdUri
    * request REQUEST_BODY
    Then method PUT

  # Input: WALLETID
  # Output: response
  @CloseWalletByWalletId
  Scenario: Close wallet by wallet id: <WALLETID>
    * replace closeWalletByWalletIdUri.walletId = WALLETID
    * url BOOKFAIRS_EWALLET_2_URL + closeWalletByWalletIdUri
    Then method DELETE

  # Input: WALLETID, FAIRID
  # Output: response
  @MoveWalletToOtherFair
  Scenario: Move wallet to other fair for wallet: <WALLETID> and fair:<FAIRID>
    * replace moveWalletToOtherFairUri.walletId = WALLETID
    * replace moveWalletToOtherFairUri.fairId = FAIRID
    * url BOOKFAIRS_EWALLET_2_URL + moveWalletToOtherFairUri
    Then method PUT

  # Input: idamUserId, fairId, activeWallets, remainingBalance
  # Output: response
  @GetWalletsByParameters
  Scenario: Get wallet by parameters: idamUserId: <idamUserId>, fairId: <fairId>, activeWallets: <activeWallets>, remainingBalance: <remainingBalance>
    * url BOOKFAIRS_EWALLET_2_URL + getWalletsByParametersUri
    * params {idamUserId: '#(idamUserId)', fairId:'#(fairId)', activeWallets:'#(activeWallets)', remainingBalance:'#(remainingBalance)'}
    Then method GET

  # Input: REQUEST_BODY
  # Output: response
  @CreateWallet
  Scenario: Create wallet with request:<REQUEST_BODY>
    * url BOOKFAIRS_EWALLET_2_URL + createWalletUri
    * request REQUEST_BODY
    Then method POST

  # Input: numBatches, perBatch
  # Output: response
  @BackfillBatches
  Scenario: Backfill batches with parameters: numBatches: <numBatches>, perBatch: <perBatch>
    * url BOOKFAIRS_EWALLET_2_URL + backfillBatchesUri
    * params {numBatches: '#(numBatches)', perBatch:'#(perBatch)'}
    Then method POST