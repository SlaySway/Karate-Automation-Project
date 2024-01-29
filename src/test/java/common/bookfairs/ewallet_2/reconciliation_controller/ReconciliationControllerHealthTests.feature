Feature: Reconciliation Controller api tests for general health

  Scenario Outline: Verify all scenarios return a happy response code
    * json apiParamsAsJson = apiParams
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE * 1

    @QA
    Examples:
      | api                         | EXPECTED_CODE | apiParams                                                                                                                                |
      | CreateReconciliations       | 201           | {REQUEST_BODY:[  {    "amount": 1,    "voucherKey": "63y8der",    "fairId": 5694296,    "reference": "3xGbTRRgL9PQgQVp1c4Nyz42irwS"  }]} |
      | GetReconciliationById       | 200           | {RECONCILIATION_ID:2231}                                                                                                                 |
      | GetReconciliationReportById | 200           | {RECONCILIATION_ID:2231}                                                                                                                 |