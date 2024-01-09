@PutConfirmCOATest @PerformanceEnhancement
Feature: PutCOAConfirm API automation tests

  Background: Set config
    * string putConfirmCOAUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/confirmation"
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }

  Scenario Outline: Validate with a valid fairId or current keyword
    * def putConfirmCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutConfirmCOA')
    Then match putConfirmCOAResponse.responseStatus == 200
    * print putConfirmCOAResponse.response

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5633533           |
      | azhou1@scholastic.com | password1 | current           |

  Scenario Outline: Validate PutConfirmCOA API with invalid login session and valid fairId
    And replace putConfirmCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + putConfirmCOAUri
    And cookies { SCHL : eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNzAxMzY1MzUyLCJzdWIiOiI5ODMwMzM2MSIsImlhdCI6MTcwMTM2NTM1NywiZXhwIjoxNzAxMzY3MTU3fQ.RuNxPupsos4pRP7GVeYoUTM_bxxHfXS4FWpf_bZaeZs}
    And method PUT
    Then match responseStatus == 401

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5633533           |

  Scenario Outline: Validate PutConfirmCOA with current keyword valid SCHL and invalid fairsession
    * def sbf_jarvis = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    And replace putConfirmCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + putConfirmCOAUri
    And cookies { SCHL : '#(sbf_jarvis.SCHL)',SBF_JARVIS  :eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ}
    And method PUT
    Then match responseStatus == 400

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | current           |

  Scenario Outline: Validate with invalid fairId or current keyword
    And replace putConfirmCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + putConfirmCOAUri
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method PUT
    Then match responseStatus == 403
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"


    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 56335             |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace putConfirmCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + putConfirmCOAUri
    Given method PUT
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def putConfirmCOAResponse = call read('RunnerHelper.feature@PutConfirmCOA')
    Then match putConfirmCOAResponse.responseStatus == 404
    And match putConfirmCOAResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_FAIR_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | abc1234           |


  @Happy
  Scenario Outline: Verify that coa confirm changes the status of the COA for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def COA_STATUS = {"coaStatus": "Not Yet Accepted"}
    * def FAIR_ID = FAIRID_OR_CURRENT
    Given def cmdmUpdateCoaStatusResponse = call read('classpath:common/cmdm/fairs/CMDMRunnerHelper.feature@UpdateFairCOAStatus')
    * sleep(1000)
    Then def getCOAStatusResponse = call read('RunnerHelper.feature@GetCOA')
    Then match getCOAStatusResponse.responseStatus == 200
    Then match getCOAStatusResponse.response.fairInfo.coaStatus == "Not Yet Accepted"
    Then def confirmCOAResponse = call read('RunnerHelper.feature@PutConfirmCOA')
    Then match confirmCOAResponse.responseStatus == 200
    * sleep(1000)
    Then def getCOAStatusResponse = call read('RunnerHelper.feature@GetCOA')
    Then match getCOAStatusResponse.responseStatus == 200
    Then match getCOAStatusResponse.response.fairInfo.coaStatus == "Accepted"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694296           |

  @Unhappy
  Scenario Outline: Verify that coa confirm sends 404 if fair doesn't exist on SQL database for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Then def confirmCOAResponse = call read('RunnerHelper.feature@PutConfirmCOA')
    Then match confirmCOAResponse.responseStatus == 404

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5695332           |



