Feature: Transaction Controller api tests for general health

  Scenario Outline: Verify all scenarios return a happy response code
    * json apiParamsAsJson = apiParams
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE * 1

    @CoveredInWalletFunctionalFlowTestAsThisTestIsntDynamicEnough
    Examples:
      | api                     | EXPECTED_CODE | apiParams                                                                                                                                                                                                                                       |
      | CreateWalletTransaction | 201           | {WALLETID: 1214783, REQUEST_BODY:{  "type": "SALE",  "amount": 1,  "timestamp": "1705944786",  "reference": "11ZpSteJWLwU42zrKtx9prdSbJ4yJr3",  "note": "Karate API Testing",  "source": "Karate",  "cashier": {    "idamUserId": "string"  }}} |
      | CreateWalletRelease     | 201           | {WALLETID: 1214783, REQUEST_BODY:{  "amount": 1,  "reference": "202303171517",  "orderId": "12345"}}                                                                                                                                             |