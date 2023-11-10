@GetFatpipeOrphanTransactionTest
Feature: Fatpipe Orphan transactions report API automation tests

  Background: Set config
    * string getOrphanTransactionsUri = "/api/v1/fairs"

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFatpipeOrphanTransactionsReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeOrphansTransactionReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipeOrphanTransactionsReportResponse
    Then match getFatpipeOrphanTransactionsReportResponse.responseStatus == 200

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |

  Scenario Outline: Validating the endpoint using dynamic comparison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeOrphansTransactionReportBase'){FAIR_ID : '<FAIR_ID>'}
    * def TargetResponseMap = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeOrphansTransactionReportRunner'){FAIR_ID : '<FAIR_ID>'}
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
      | FAIR_ID |
      | 5633533 |
      | 5240970 |

    #  Note: This API cannot distinguish between invalid Fairs and Fairs which simply have no data.
  Scenario Outline: Validate a 200 status code for a invalid fairId
    * def getFatpipeOrphanTransactionsReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeOrphansTransactionReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipeOrphanTransactionsReportResponse
    Then match getFatpipeOrphanTransactionsReportResponse.responseStatus == 200

    @QA
    Examples:
      | FAIR_ID |
      | 56300a  |
      | 52723a  |

  Scenario Outline: Validate when invalid input is provided
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getOrphanTransactionsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/orphans'
    And params {orphanStatus:'invalid'}
    And method GET
    Then match responseStatus == 400

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |
