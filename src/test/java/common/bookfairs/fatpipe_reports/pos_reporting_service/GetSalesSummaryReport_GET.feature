@GetFatpipeSalesSummaryTest
Feature: Fatpipe Sales summary report API automation tests

  Background: Set config
    * string getSalesSummaryUri = "/api/v1/fairs"

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFatpipeSalesSummaryReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeSalesSummaryReportRunner'){FAIR_ID : '<FAIR_ID>', source : '<source>'}
    * print getFatpipeSalesSummaryReportResponse
    Then match getFatpipeSalesSummaryReportResponse.responseStatus == 200
    Then match getFatpipeSalesSummaryReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'
    Then match getFatpipeSalesSummaryReportResponse.response.metaData.params.source == '#(source)'

    @QA
    Examples:
      | FAIR_ID | source |
      | 5633533 | POS    |
      | 5633533 | PP     |
      | 5633533 | ALL    |

#  Note: This API cannot distinguish between invalid Fairs and Fairs which simply have no data.
  Scenario Outline: Validate a 200 status code for a invalid fairId
    * def getFatpipeSalesSummaryReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeSalesSummaryReportRunner'){FAIR_ID : '<FAIR_ID>', source : '<source>'}
    * print getFatpipeSalesSummaryReportResponse
    Then match getFatpipeSalesSummaryReportResponse.responseStatus == 200
    Then match getFatpipeSalesSummaryReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'
    Then match getFatpipeSalesSummaryReportResponse.response.metaData.params.source == '#(source)'

    @QA
    Examples:
      | FAIR_ID | source |
      | 5630    | PO     |
      | 563b    | PPn    |

  Scenario Outline: Validate when invalid input is provided
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getSalesSummaryUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/sales/summary'
    And params {source : '#(source)', perRegister : 'false', transactionStatusGroup : 'REGI'}
    And method GET
    Then match responseStatus == 400

    @QA
    Examples:
      | FAIR_ID | source |
      | 5633533 | POS    |
      | 5633533 | PP     |
