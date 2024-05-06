@GetCOAPDFLink
Feature: Canada Toolkit Get COA PDF Link API Tests

  Background: Set config
    * string getCOAPDFLinkUri = "/api/user/fairs/<resourceId>/coa/pdf-links"

  Scenario Outline: Validate get coa pdf links for fair: <FAIRID_OR_CURRENT>
    # retrieve pdf link
    # hit the get coa jwt with it
    Given def response = call read('RunnerHelper.feature@GetCOAPDFLink'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 200

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |
      | azhou1@scholastic.com | password1 | 5196693           |
      | azhou1@scholastic.com | password1 | 5196693           |
