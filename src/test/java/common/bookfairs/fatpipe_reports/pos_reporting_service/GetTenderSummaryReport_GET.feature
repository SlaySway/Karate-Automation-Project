@GetFatpipeTenderSummaryTest
Feature: Fatpipe Tender summary report API automation tests

  Background: Set config
    * string getTenderSummaryUri = "/api/v1/fairs"

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFatpipeTenderSummaryReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeTenderSummaryReportRunner'){FAIR_ID : '<FAIR_ID>', source : '<source>'}
    * print getFatpipeTenderSummaryReportResponse
    Then match getFatpipeTenderSummaryReportResponse.responseStatus == 200
    Then match getFatpipeTenderSummaryReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'
    Then match getFatpipeTenderSummaryReportResponse.response.metaData.params.source == '#(source)'

    @QA
    Examples:
      | FAIR_ID | source |
      | 5633533 | POS    |
      | 5633533 | PP     |
      | 5633533 | ALL    |
      | 5240970 | PP     |

#  Note: This API cannot distinguish between invalid Fairs and Fairs which simply have no data.
  Scenario Outline: Validate a 200 status code for a invalid fairId
    * def getFatpipeTenderSummaryReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeTenderSummaryReportRunner'){FAIR_ID : '<FAIR_ID>', source : '<source>'}
    * print getFatpipeTenderSummaryReportResponse
    Then match getFatpipeTenderSummaryReportResponse.responseStatus == 200
    Then match getFatpipeTenderSummaryReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'
    Then match getFatpipeTenderSummaryReportResponse.response.metaData.params.source == '#(source)'

    @QA
    Examples:
      | FAIR_ID | source |
      | 5630    | POS    |
      | 563b    | PP     |

  Scenario Outline: Validate when invalid typeCode is provided
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getTenderSummaryUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/tenders/summary'
    And params {source : '#(source)',typeCode : 'ABC', includeNetzero : 'false',includeNetzero : 'false',perRegister:'false',tenderAuthStatusGroup:'REGISTER', tenderStatusGroup:'REGISTER',transactionStatusGroup:'REGISTER'}
    And method GET
    Then match responseStatus == 400

    @QA
    Examples:
      | FAIR_ID | source |
      | 5633533 | POS    |
      | 5633533 | PP     |

