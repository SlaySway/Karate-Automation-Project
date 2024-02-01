Feature: Wallet Controller api tests for general health

  Scenario Outline: Verify all scenarios return a happy response code
    * json apiParamsAsJson = apiParams
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE * 1

    @CoveredInWalletFunctionalFlowTestAsThisTestIsntDynamicEnough
    Examples:
      | api                        | EXPECTED_CODE | apiParams                                                                                                                                                                                                                                                                                                             |
      | GetWalletByWalletID        | 200           | {WALLETID:1211335}                                                                                                                                                                                                                                                                                                    |
      | UpdateWalletInfoByWalletId | 200           | {WALLETID:1211335, REQUEST_BODY: {"studentFirstName": "Karate",  "studentLastName": "Testing",  "teacherFirstName": "Happy",  "teacherLastName": "Path",  "parentFirstName": "200",  "parentLastName": "OK"}}                                                                                                         |
      | CloseWalletByWalletId      | 204           | {WALLETID:1214737}                                                                                                                                                                                                                                                                                                    |
      | MoveWalletToOtherFair      | 200           | {WALLETID:1211335, FAIRID:  5697025}                                                                                                                                                                                                                                                                                  |
      | GetWalletsByParameters     | 200           | {idamUserId: 98483103, fairId:5694296, activeWallets:'', remainingBalance:''}                                                                                                                                                                                                                                         |
      | CreateWallet               | 201           | {REQUEST_BODY: {  "customerProfileId": 98483103,  "fairId": 5694296,  "studentFirstName": "Karate",  "studentLastName": "Automated",  "teacherFirstName": "Testing",  "teacherLastName": "Automated",  "parentFirstName": "Automated",  "parentLastName": "Testing",  "grade": "pre_k",  "recipientType": "TEACHER"}} |