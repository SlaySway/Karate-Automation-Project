@UpdateHomepageEvents
Feature: UpdateHomepageEvents PUT Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def updateHomepageEventsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage/events"
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }

  @Happy
  Scenario Outline: Validate successful response for valid change request for user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, request scenario:<requestBody>
    # Get a record of the original amount of events
    Given def getHomepageResponse = call read('RunnerHelper.feature@GetFairHomepage')
    Then match getHomepageResponse.responseStatus == 200
    * def originalEvents = getHomepageResponse.response.events

    # Create an event
    * def REQUEST_BODY = read('UpdateHomepageEventsRequest.json')
    Given def createEventsResponse = call read("RunnerHelper.feature@CreateHomepageEvents")
    Then match createEventsResponse.responseStatus == 200

    # Verify event is created
    * sleep(1000)
    Given def getHomepageResponse = call read('RunnerHelper.feature@GetFairHomepage')
    Then getHomepageResponse.responseStatus == 200
    Then match originalEvents != getHomepageResponse.response.events
    And assert originalEvents.length < getHomepageResponse.response.events.length

    # Select an event to update
    * def selectedEventToChange = getHomepageResponse.response.events[0]
    # Update the event
    * set selectedEventToChange.description = "I should now be new"
    * def array = [""]
    * set array[0] = selectedEventToChange
    * def REQUEST_BODY = array
    Given def updateHomepageEventsResponse = call read("RunnerHelper.feature@UpdateHomepageEvents")
    Then match updateHomepageEventsResponse.responseStatus == 200

    # Verify value of event
    * sleep(1000)
    Given def getHomepageResponse = call read('RunnerHelper.feature@GetFairHomepage')
    Then match getHomepageResponse.responseStatus == 200
    Then match getHomepageResponse.response.events contains selectedEventToChange

    # delete the event
    * def REQUEST_BODY = array
    Given def deleteHomepageEventResponse = call read('RunnerHelper.feature@DeleteHomepageEvents')
    Then match deleteHomepageEventResponse.responseStatus == 200

    # Verify event doesn't exist anymore
    * sleep(1000)
    Given def getHomepageResponse = call read('RunnerHelper.feature@GetFairHomepage')
    Then match getHomepageResponse.responseStatus == 200
    Then match getHomepageResponse.response.events !contains selectedEventToChange
    Then assert originalEvents.length == getHomepageResponse.response.events.length

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5633533           |


  @Unhappy
  Scenario Outline: Validate when invalid request body for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = ""
    Given def updateHomepageEventsResponse = call read('RunnerHelper.feature@UpdateHomepageEvents')
    Then match updateHomepageEventsResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5633533           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace updateHomepageEventsUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateHomepageEventsUri
    Given method put
    Then match responseStatus == 401

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5633533           |
      | current           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * replace updateHomepageEventsUri.fairIdOrCurrent =  "current"
    * url BOOKFAIRS_JARVIS_URL + updateHomepageEventsUri
    * cookies { SCHL : '<EXPIRED_SCHL>'}
    Given method put
    Then match responseStatus == 401

    @QA
    Examples:
      | EXPIRED_SCHL |
      | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |

  @Happy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageEventsResponse = call read('RunnerHelper.feature@UpdateHomepageEvents')
    Then match updateHomepageEventsResponse.responseStatus == 204
    And match updateHomepageEventsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_FAIRS"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | current           |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageEventResponse = call read('RunnerHelper.feature@UpdateHomepageEvents')
    Then match updateHomepageEventResponse.responseStatus == 403
    And match updateHomepageEventResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5734325           |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageEventResponse = call read('RunnerHelper.feature@UpdateHomepageEvents')
    Then match updateHomepageEventResponse.responseStatus == 204
    And match updateHomepageEventResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5829187           |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageEventResponse = call read('RunnerHelper.feature@UpdateHomepageEvents')
    Then match updateHomepageEventResponse.responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(updateHomepageEventResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR |
      | azhou1@scholastic.com | password1 | 5633533           | 5633533       |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT: <SBF_JARVIS_FAIR>}
    * def REQUEST_BODY = {}
    * replace updateHomepageEventsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateHomepageEventsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method put
    Then match responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5633533           | 5633533       | 5782595         |
      | azhou1@scholastic.com | password1 | current           | 5633533       | 5633533         |