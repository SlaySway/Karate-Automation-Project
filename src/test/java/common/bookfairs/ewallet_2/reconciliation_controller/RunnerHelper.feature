@ignore @report=true
Feature: Helper for fund-controller endpoints

  Background: Set config
    * string createReconciliationsUri = "/reconciliations"
    * string getReconciliationByReconciliationId = "/reconciliations/<reconciliationId>"
    * string getReconciliationReportByReconciliationId = "/reconciliations/<reconciliationId>/report"

  # Input: REQUEST_BODY
  # Output: response
  @CreateReconciliations
  Scenario: Create reconciliations for wallets
    * url BOOKFAIRS_EWALLET_2_URL + createReconciliationsUri
    * request REQUEST_BODY
    Then method POST

  # Input: RECONCILIATION_ID
  # Output: response
  @GetReconciliationById
  Scenario: Get reconciliation by reconciliation id
    * replace getReconciliationByReconciliationId.reconciliationId = RECONCILIATION_ID
    * url BOOKFAIRS_EWALLET_2_URL + getReconciliationByReconciliationId
    Then method GET

  # Input: RECONCILIATION_ID
  # Output: response
  @GetReconciliationReportById
  Scenario: Get reconciliation report by reconciliation id
    * replace getReconciliationReportByReconciliationId.reconciliationId = RECONCILIATION_ID
    * url BOOKFAIRS_EWALLET_2_URL + getReconciliationReportByReconciliationId
    Then method GET