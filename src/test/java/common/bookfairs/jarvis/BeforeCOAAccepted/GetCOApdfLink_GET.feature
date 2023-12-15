@GetCOApdfLinkTest @PerformanceEnhancement
Feature: GetCOApdfLink API automation tests

  Background: Set config
    * string getCOApdfLinkUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/pdf-links"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate with a valid fairId or current keyword
    * def getCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLink')
    Then match getCOApdfLinkResponse.responseStatus == 200
    * print getCOApdfLinkResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5633533           |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038           |
      | sdevineni-consultant@scholastic.com | passw0rd  | current           |
      | azhou1@scholastic.com               | password1 | current           |


  Scenario Outline: Validate GetCOApdfLink API with a valid fairId invalid SCHL cookie
    And replace getCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOApdfLinkUri
    And cookies { SCHL : eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNzAxMzY1MzUyLCJzdWIiOiI5ODMwMzM2MSIsImlhdCI6MTcwMTM2NTM1NywiZXhwIjoxNzAxMzY3MTU3fQ.RuNxPupsos4pRP7GVeYoUTM_bxxHfXS4FWpf_bZaeZs}
    And method GET
    Then match responseStatus == 401

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5633533           |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038           |

  Scenario Outline: Validate GetCOApdfLink API with invalid fairID and valid login session
    And replace getCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOApdfLinkUri
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunnerBase')
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET
    Then match responseStatus == 403

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 56335             |

  Scenario Outline: Validate with current keyword or valid fairId valid login session and invalid session cookie
    * def sbf_jarvis = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    And replace getCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOApdfLinkUri
    And cookies { SCHL : '#(sbf_jarvis.SCHL)', SBF_JARVIS  : eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ}
    And method GET
    Then match responseStatus == 200

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | current           |
      | azhou1@scholastic.com | password1 | 5775209           |

