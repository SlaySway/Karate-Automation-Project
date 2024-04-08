@ignore @report=true
Feature: Helper for running recruit-volunteers-controller endpoints

  Background: Set config
    * string getVolunteersUrlUri = "/api/user/fairs/<resourceId>/homepage/volunteers"
    * string updateVolunteersUrlUri = "/api/user/fairs/<resourceId>/homepage/volunteers"

  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetVolunteersUrl
  Scenario: Run get fair contact info for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getVolunteersUrlUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getVolunteersUrlUri
    * cookies { userEmail : '#(USER_NAME)'}
    Then method GET

  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @UpdateVolunteersUrl
  Scenario: Run create fair event for user: <USER_NAME> and password: <REQUEST_BODY.password>
    * replace updateVolunteersUrlUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + updateVolunteersUrlUri
    * cookies { userEmail : '#(USER_NAME)'}
    * request REQUEST_BODY
    Then method PUT