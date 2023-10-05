@GetFatpipeOrphansTransactionByTransactionIdTest
Feature: Fatpipe Orphans transaction by transactionId report API automation tests

  Background: Set config
    * string getOrphansTransactionByTransactionIdUri = "/api/v1/transactions"

    # NOTE: As there are no such transactionIds so only unhappy path could be automated
  Scenario Outline: Validate 500 status code for an invalid transactionId
    * def getFatpipeOrphansTransactionByTransactionIdReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeOrphansTransactionByTransactionIdReportRunner'){TRANSACTION_ID : '<TRANSACTION_ID>'}
    * print getFatpipeOrphansTransactionByTransactionIdReportResponse
    Then match getFatpipeOrphansTransactionByTransactionIdReportResponse.responseStatus == 500

    @QA
    Examples:
      | TRANSACTION_ID |
      | 5633534543     |
