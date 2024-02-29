@ignore @report=true
Feature: Helper for running Library processing endpoints

  Background: Set config
    * string getLibraryDetailsUri = "/api/user/library/orgs/<accountId>"
    * string saveLibraryDetailsUri = "/api/user/library/orgs/<accountId>"

  # Input: accountId
  # Output: response
  @GetLibraryDetails
  Scenario: Run get library details: <accountId>
    * replace getLibraryDetailsUri.accountId = ACCOUNT_ID
    * url LIBRARY_PROCESSING_URL + getLibraryDetailsUri
    Then method get

  # Input: accountId
  # Output: response
  @GetLibraryDetailsBase
  Scenario: Run get library details: <accountId>
    * replace getLibraryDetailsUri.accountId = ACCOUNT_ID
    * url LIBRARY_PROCESSING_BASE + getLibraryDetailsUri
    Then method get

  # Input: accountId
  # Output: response
  @PutLibraryDetails
  Scenario: Run save library details: <accountId>
    * replace saveLibraryDetailsUri.accountId = ACCOUNT_ID
    * url LIBRARY_PROCESSING_URL + saveLibraryDetailsUri
    * request REQUEST_BODY
    Then method PUT

  # Input: accountId
  # Output: response
  @PutLibraryDetailsBase
  Scenario: Run save library details: <accountId>
    * replace saveLibraryDetailsUri.accountId = ACCOUNT_ID
    * url LIBRARY_PROCESSING_BASE + saveLibraryDetailsUri
    * request REQUEST_BODY
    Then method PUT


