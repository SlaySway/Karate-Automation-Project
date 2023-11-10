@GetFatpipePOSstatusTest
Feature: Fatpipe POS status report API automation tests

  Background: Set config
    * string getPOSstatusUri = "/api/v1/fairs"

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFatpipePOSstatusReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipePOSstatusReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipePOSstatusReportResponse
    Then match getFatpipePOSstatusReportResponse.responseStatus == 200
    Then match getFatpipePOSstatusReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'
    Then match getFatpipePOSstatusReportResponse.response.status.statusCode == 'PROCESSED'

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |

  Scenario Outline: Validating the endpoint using dynamic comparison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipePOSstatusReportBase'){FAIR_ID : '<FAIR_ID>'}
    * def TargetResponseMap = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipePOSstatusReportRunner'){FAIR_ID : '<FAIR_ID>'}
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

  Scenario Outline: Validate when invalid input is provided
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getPOSstatusUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/status'
    And params {connectivityFilter : 'REGIST', includeNetzero:'false', perRegister:'false'}
    And method GET
    Then match responseStatus == 400

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |
