@GetCOAWithJWT
Feature: Canada Toolkit GetCOAWithJWT API Tests

  Background: Set config
    * string getCOAWithJWTUri = "/api/public/coa/pdf-links/<jwt>"

  Scenario Outline: Validate fields returned by get coa with jwt against cmdm for fair: <FAIRID_OR_CURRENT>
    Given def retrieveJWTResponse = call read('RunnerHelper.feature@GetCOAPDFLink'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match retrieveJWTResponse.responseStatus == 200
    And def cmdmResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * print cmdmResponse

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate no authorization cookie provided for get events for fair: <FAIRID_OR_CURRENT>
    * replace getCOAWithJWTUri.jwt = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + getCOAWithJWTUri
    Then method GET
    Then match responseStatus == 204
    Then match responseHeaders['Sbf-Ca-Reason'] == ["NO_USER_EMAIL"]

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |