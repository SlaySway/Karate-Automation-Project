Feature: Retry Controller api tests for general health

  Scenario Outline: Verify all scenarios return a happy response code
    * json apiParamsAsJson = apiParams
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE * 1

    @QA
    Examples:
      | api                | EXPECTED_CODE | apiParams |
      | RetryResolveWallet | 200           | {}        |
      | RetryFundingWallet | 200           | {}        |