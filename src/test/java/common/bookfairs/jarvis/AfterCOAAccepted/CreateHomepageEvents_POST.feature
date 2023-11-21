@CreateHomepageEvents
Feature: CreateHomepageEvents POST Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def createHomepageEventsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage/events"


  @Unhappy
Scenario Outline: Validate when invalid request body for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
* def REQUEST_BODY = ""
Given def createHomepageEventsResponse = call read('RunnerHelper.feature@CreateHomepageEvents')
Then match createHomepageEventsResponse.responseStatus == 415

@QA
Examples:
| USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
| azhou1@scholastic.com | password1 | 5633533           |

@Unhappy
Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
* replace createHomepageEventsUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
* url BOOKFAIRS_JARVIS_URL + createHomepageEventsUri
Given method post
Then match responseStatus == 401

@QA
Examples:
| FAIRID_OR_CURRENT |
| 5633533           |
| current           |

@Unhappy
Scenario Outline: Validate when SCHL cookie is expired
* replace createHomepageEventsUri.fairIdOrCurrent =  "current"
* url BOOKFAIRS_JARVIS_URL + createHomepageEventsUri
* cookies { SCHL : '<EXPIRED_SCHL>'}
Given method post
Then match responseStatus == 401

@QA
Examples:
| EXPIRED_SCHL |
| eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |

@Happy
Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
* def REQUEST_BODY = {}
Given def createHomepageEventsResponse = call read('RunnerHelper.feature@CreateHomepageEvents')
Then match createHomepageEventsResponse.responseStatus == 204
And match createHomepageEventsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_FAIRS"

@QA
Examples:
| USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
| nofairs@testing.com | password1 | current           |

@Unhappy
Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
* def REQUEST_BODY = {}
Given def createHomepageEventsResponse = call read('RunnerHelper.feature@CreateHomepageEvents')
Then match createHomepageEventsResponse.responseStatus == 403
And match createHomepageEventsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

@QA
Examples:
| USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
| azhou1@scholastic.com | password1 | 5734325           |

@Unhappy
Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
* def REQUEST_BODY = {}
Given def createHomepageEventsResponse = call read('RunnerHelper.feature@CreateHomepageEvents')
Then match createHomepageEventsResponse.responseStatus == 204
And match createHomepageEventsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

@QA
Examples:
| USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
| azhou1@scholastic.com | password1 | 5829187           |

@Happy
Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<FAIRID_OR_CURRENT>
* def REQUEST_BODY = {}
Given def createHomepageEventsResponse = call read('RunnerHelper.feature@CreateHomepageEvents')
Then match createHomepageEventsResponse.responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(createHomepageEventsResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

@QA
Examples:
| USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR |
| azhou1@scholastic.com | password1 | 5633533           | 5633533       |

@Happy
Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, cookie fair:<SBF_JARVIS_FAIR>
Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT: <SBF_JARVIS_FAIR>}
* def REQUEST_BODY = {}
* replace createHomepageEventsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
* url BOOKFAIRS_JARVIS_URL + createHomepageEventsUri
* cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
Then method post
Then match responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'PREVIOUSLY_SELECTED'))

@QA
Examples:
| USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SBF_JARVIS_FAIR |
| azhou1@scholastic.com | password1 | 5633533           | 5633533       | 5782595         |
| azhou1@scholastic.com | password1 | current           | 5633533       | 5633533         |