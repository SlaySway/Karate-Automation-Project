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

  Scenario Outline: Validating the endpoint using dynamic comparison || fairId=<FAIR_ID>
      * def BaseResponseMap = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeTenderSummaryReportBase'){FAIR_ID : '<FAIR_ID>', source : '<source>'}
      * def TargetResponseMap = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeTenderSummaryReportRunner'){FAIR_ID : '<FAIR_ID>', source : '<source>'}
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

