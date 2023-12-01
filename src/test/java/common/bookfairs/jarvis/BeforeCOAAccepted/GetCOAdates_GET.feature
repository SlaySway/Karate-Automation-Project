@GetCOAdatesTest
Feature: GetCOAdates API automation tests

  Background: Set config
    * string getCOAdatesUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/dates"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate with a valid fairId or current keyword
    * def getCOAdatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOAdates')
    Then match getCOAdatesResponse.responseStatus == 200
    * print getCOAdatesResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5633533           |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038           |
      | sdevineni-consultant@scholastic.com | passw0rd  | current           |
      | azhou1@scholastic.com               | password1 | current           |

  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOAdatesBase')
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOAdates')
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response

    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", base
    Then print "Response from current qa code base", target
    Then print 'Differences any...', compResult
    And match base == target

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com               | password1 | 5633533          |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038          |

  Scenario Outline: Validate GetCOAdates API with a valid fairId SCHL and Session Cookie
    * def getCOAdatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOAdates')
    Then match getCOAdatesResponse.responseStatus == 200
    * print getCOAdatesResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5633533           |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038           |

  Scenario Outline: Validate GetCOAdates API with current keyword SCHL and Session Cookie
    * def getCOAdatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOAdates')
    Then match getCOAdatesResponse.responseStatus == 200
    * print getCOAdatesResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com               | password1 | current          |
      | sdevineni-consultant@scholastic.com | passw0rd  | current          |

  Scenario Outline: Validate with invalid fairId and valid SCHL and session cookie
    And replace getCOAdatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOAdatesUri
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET
    Then match responseStatus == 403
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5565              |

  Scenario Outline: Validate with invalid login session and a valid fairId
    And replace getCOAdatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOAdatesUri
    And cookies { SCHL : eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNzAxMzY1MzUyLCJzdWIiOiI5ODMwMzM2MSIsImlhdCI6MTcwMTM2NTM1NywiZXhwIjoxNzAxMzY3MTU3fQ.RuNxPupsos4pRP7GVeYoUTM_bxxHfXS4FWpf_bZaeZs}
    And method GET
    Then match responseStatus == 401
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com | password1 |          5775209 |

  Scenario Outline: Validate with invalid session cookie and a valid fairId
    And replace getCOAdatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOAdatesUri
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And cookies { SCHL : '#(schlResponse.SCHL)',SBF_JARVIS  : eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJib29rZmFpcnMtamFydmlzIiwiYXVkIjoiU2Nob2xhc3RpYyIsIm5iZiI6MTcwMTM5OTAwOSwiZmlkIjoiNTYzMzUzMyIsImVtbCI6ImF6aG91MUBzY2hvbGFzdGljLmNvbSIsImVzZiI6InRydWUiLCJmcnMiOlt7ImlkIjoiNTYzODE5MCIsIm5hbSI6IlJFRCBXQVRFUiBFTEVNRU5UQVJZIFNDSE9PTCBGYWlyIiwidHlwIjoiY2FzZSIsInN0ciI6IjIwMjItMDUtMjUiLCJlbmQiOiIyMDIyLTA3LTE5IiwiY29hIjoidHJ1ZSJ9LHsiaWQiOiI1NzYyMDk1IiwibmFtIjoiUkVEIFdBVEVSIEVMRU1FTlRBUlkgU0NIT09MIEZhaXIiLCJ0eXAiOiJjYXNlIiwic3RyIjoiMjAyMy0xMC0wMiIsImVuZCI6IjIwMjMtMTAtMjAiLCJjb2EiOiJmYWxzZSJ9LHsiaWQiOiI1NzgyNTk1IiwibmFtIjoiUkVEIFdBVEVSIEVMRU1FTlRBUlkgU0NIT09MIEZhaXIiLCJ0eXAiOiJVbmtub3duIiwic3RyIjoiMjAyMy0wOS0wNiIsImVuZCI6IjIwMjMtMTItMzEiLCJjb2EiOiJ0cnVlIn0seyJpZCI6IjU2MjI3OTQiLCJuYW0iOiJEQVlUT04gRUxFTUVOVEFSWSBTQ0hPT0wgRmFpciIsInR5cCI6IlVua25vd24iLCJzdHIiOiIyMDIzLTA3LTEwIiwiZW5kIjoiMjAyMy0wOC0xNCIsImNvYSI6InRydWUifSx7ImlkIjoiNTYzMzUzMyIsIm5hbSI6IkRBWVRPTiBFTEVNRU5UQVJZIFNDSE9PTCBGYWlyIiwidHlwIjoiY2FzZSIsInN0ciI6IjIwMjMtMTAtMTgiLCJlbmQiOiIyMDI0LTAxLTAzIiwiY29hIjoiZmFsc2UifSx7ImlkIjoiNTYzODE4OSIsIm5hbSI6IkRBWVRPTiBFTEVNRU5UQVJZIFNDSE9PTCBGYWlyIiwidHlwIjoiVW5rbm93biIsInN0ciI6IjIwMjMtMDctMTciLCJlbmQiOiIyMDIzLTA3LTIxIiwiY29hIjoidHJ1ZSJ9LHsiaWQiOiI1NzcwMzMwIiwibmFtIjoiREFZVE9OIEVMRU1FTlRBUlkgU0NIT09MIEZhaXIiLCJ0eXAiOiJjYXNlIiwic3RyIjoiMjAyMy0wOS0xMyIsImVuZCI6IjIwMjMtMDktMTUiLCJjb2EiOiJmYWxzZSJ9LHsiaWQiOiI1NzczMDQ1IiwibmFtIjoiREFZVE9OIEVMRU1FTlRBUlkgU0NIT09MIEZhaXIiLCJ0eXAiOiJib2dvIGNhc2UiLCJzdHIiOiIyMDIzLTEwLTAyIiwiZW5kIjoiMjAyMy0xMC0wNCIsImNvYSI6ImZhbHNlIn0seyJpZCI6IjU3NzUyMDkiLCJuYW0iOiJEQVlUT04gRUxFTUVOVEFSWSBTQ0hPT0wgRmFpciIsInR5cCI6ImNhc2UiLCJzdHIiOiIyMDIzLTA5LTI1IiwiZW5kIjoiMjAyMy0wOS0yOSIsImNvYSI6InRydWUifSx7ImlkIjoiNTc3NTIxMSIsIm5hbSI6IkRBWVRPTiBFTEVNRU5UQVJZIFNDSE9PTCBGYWlyIiwidHlwIjoiVmlydHVhbCIsInN0ciI6IjIwMjMtMDktMjYiLCJlbmQiOiIyMDIzLTEwLTA5IiwiY29hIjoiZmFsc2UifSx7ImlkIjoiNTc4NDM1MCIsIm5hbSI6IkRBWVRPTiBFTEVNRU5UQVJZIFNDSE9PTCBGYWlyIiwidHlwIjoiVmlydHVhbCIsInN0ciI6IjIwMjItMTAtMTciLCJlbmQiOiIyMDIyLTEwLTMwIiwiY29hIjoidHJ1ZSJ9LHsiaWQiOiI1ODI5MTg3IiwibmFtIjoiREFZVE9OIEVMRU1FTlRBUlkgU0NIT09MIEZhaXIiLCJ0eXAiOiJWaXJ0dWFsIiwic3RyIjoiMjAyMy0xMS0yOCIsImVuZCI6IjIwMjMtMTItMTEiLCJjb2EiOiJmYWxzZSJ9LHsiaWQiOiI1NjIyNzkzIiwibmFtIjoiUEhPRU5JWCBDSElMRFJFTlMgQUNBRCBQUyAyMjUgRmFpciIsInR5cCI6IlVua25vd24iLCJzdHIiOiIyMDIzLTA3LTEwIiwiZW5kIjoiMjAyMy0wNy0zMCIsImNvYSI6InRydWUifV0sInN1YiI6Ijk4NDgzMTAzIiwiaWF0IjoxNzAxMzk5MDE0LCJleHAiOjE3MDE0MjA2MTR9.pm5P8i0w0IyxSemRheQDNSCGJNj5gTxOonYyThAIwkY}
    And method GET
    Then match responseStatus == 404

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com | password1 |                  |
