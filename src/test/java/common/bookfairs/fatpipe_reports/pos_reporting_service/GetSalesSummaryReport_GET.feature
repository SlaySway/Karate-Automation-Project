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

  Scenario Outline: Validating the endpoint using dynamic comparison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeSalesSummaryReportBase'){FAIR_ID : '<FAIR_ID>', source : '<source>'}
    * def TargetResponseMap = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeSalesSummaryReportRunner'){FAIR_ID : '<FAIR_ID>', source : '<source>'}
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response

    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", base
    Then print "Response from current qa code base", target
    Then print 'Differences any...', compResult
    And match BaseResponseMap.BaseResponse == TargetResponseMap.TargetResponse

    Examples:
      | FAIR_ID | source |
      | 5633533 | POS    |
      | 5633533 | PP     |
      | 5633533 | ALL    |
      | 5240970 | PP     |

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
