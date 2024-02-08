Feature: Health Controller api tests for general health

  Scenario Outline: Verify all scenarios return a happy response code for funding
    * json apiParamsAsJson = apiParams
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE

    @QA
    Examples:
      | api             | EXPECTED_CODE! | apiParams |
      | GetServerHealth | 200            | {}        |