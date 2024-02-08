@ignore @report=true
Feature: Helper for running Library processing endpoints

  Background: Set config
    * string getLibraryDetailsUri = "/api/user/library/orgs/<orgUcn>"
    * string saveLibraryDetailsUri = "/api/user/library/orgs/<orgUcn>"

  # Input: orgUcn
  # Output: response
  @GetLibraryDetails
  Scenario: Run get library details: <orgUcn>
    * replace getLibraryDetailsUri.orgUcn = ORG_UCN
    * url LIBRARY_PROCESSING_URL + getLibraryDetailsUri
    Then method get

  # Input: orgUcn
  # Output: response
  @GetLibraryDetailsBase
  Scenario: Run get library details: <orgUcn>
    * replace getLibraryDetailsUri.orgUcn = ORG_UCN
    * url LIBRARY_PROCESSING_BASE + getLibraryDetailsUri
    Then method get

  # Input: orgUcn
  # Output: response
  @PutLibraryDetails
  Scenario: Run save library details: <orgUcn>
    * replace saveLibraryDetailsUri.orgUcn = ORG_UCN
    * url LIBRARY_PROCESSING_URL + saveLibraryDetailsUri
    * request REQUEST_BODY
    Then method PUT

  # Input: orgUcn
  # Output: response
  @PutLibraryDetailsBase
  Scenario: Run save library details: <orgUcn>
    * replace saveLibraryDetailsUri.orgUcn = ORG_UCN
    * url LIBRARY_PROCESSING_BASE + saveLibraryDetailsUri
    * request REQUEST_BODY
    Then method PUT


