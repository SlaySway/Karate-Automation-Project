Feature: Fair Controller api tests for general health

  Scenario Outline: Verify all scenarios return a happy response code
    * json apiParamsAsJson = apiParams
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE * 1

    @QA
    Examples:
      | api                           | EXPECTED_CODE | apiParams                                                             |
      | ReopenFairByFairId            | 204           | {FAIRID:5694296}                                                      |
      | UpdateFairChecksByFairId      | 200           | {FAIRID:5633533, disableFairApiCheck:false, disablePosApiCheck:false} |
      | CloseFairByFairId             | 201           | {FAIRID:5633533}                                                      |
      | ResolveClosedFairTransactions | 201           | {}                                                                    |
      | CloseFairs                    | 200           | {}                                                                    |
      | GetWalletsByFairId            | 200           | {FAIRID:5694296}                                                      |