@ignore @report=true
Feature: Helper for running pdf-links-controller endpoints

  Background: Set config
    * string getCOAWithJWTUri = "/api/public/coa/pdf-links/<jwt>"
    * string getCOAPDFLinkUri = "/api/user/fairs/<resourceId>/coa/pdf-links"

  # Input: JWT
  # Output: response
  @GetCOAWithJWT
  Scenario: Run get coa with jwt for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getCOAWithJWTUri.jwt = JWT
    * url CANADA_TOOLKIT_URL + getCOAWithJWTUri
    Then method GET

  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @GetCOAPDFLink
  Scenario: Run get coa pdf link for user: <USER_NAME> and password: <REQUEST_BODY.password>
    * replace getCOAPDFLinkUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getCOAPDFLinkUri
    * cookies { userEmail : '#(USER_NAME)'}
    Then method GET