@UpdateFinFormEarnings @PerformanceEnhancement
Feature: UpdateFinFormSales PUT Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def updateFinFormEarningsUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/form/earnings"
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }

  @Unhappy
  Scenario Outline: Validate when invalid request body for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = ""
    Given def updateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
    Then match updateFinFormEarningsResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
    Then match updateFinFormEarningsResponse.responseStatus == 204
    And match updateFinFormEarningsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID |
      | nofairs@testing.com | password1 | 5694296     |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
    Then match updateFinFormEarningsResponse.responseStatus == 204
    And match updateFinFormEarningsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694300     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * replace updateFinFormEarningsUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormEarningsUri
    Given method put
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | RESOURCE_ID |
      | 5694296     |
      | current     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * replace updateFinFormEarningsUri.resourceId =  "current"
    * url BOOKFAIRS_JARVIS_URL + updateFinFormEarningsUri
    * cookies { SCHL : '<EXPIRED_SCHL>'}
    Given method put
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | EXPIRED_SCHL                                                                                                                                                                                                                                                      |
      | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
    Then match updateFinFormEarningsResponse.responseStatus == 403
    And match updateFinFormEarningsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
    Then match updateFinFormEarningsResponse.responseStatus == 404
    And match updateFinFormEarningsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | abc1234     |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<RESOURCE_ID>
    * def REQUEST_BODY = { scholasticDollars:{selected:1}, cash:{selected:2} }
    Given def updateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
    Then match updateFinFormEarningsResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(updateFinFormEarningsResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR |
      | azhou1@scholastic.com | password1 | 5694296     | 5694296       |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for user:<USER_NAME>, fair:<RESOURCE_ID>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * def REQUEST_BODY = {}
    * replace updateFinFormEarningsUri.resourceId = RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormEarningsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method put
    Then match responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5694296     | 5694296       | 5694309         |
      | azhou1@scholastic.com | password1 | current     | 5694296       | 5694296         |

  @Unhappy
  Scenario Outline: Validate when current is used without SBF_JARVIS user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateFinFormEarningsUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormEarningsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request {}
    Given method put
    Then match responseStatus == 400
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SELECTED_RESOURCE"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | current     |

  @Happy @Mongo
  Scenario Outline: Validate mongo is updated in appropriate fields for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def convertNumberDecimal =
    """
    function(json){
      if(typeof json !== 'object' || json == null) {
          return json;
      }
      for(let field in json){
          let isFieldObject = (typeof json[field] === 'object');
          if(!Array.isArray(json[field]) && isFieldObject && json[field].containsKey('$numberDecimal')){
              json[field] = Number(json[field]['$numberDecimal']);
          }
          else if (isFieldObject){
              convertNumberDecimal(json[field]);
          }
        }
    }
    """
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And def originalDocument = mongoJson.document
    * def REQUEST_BODY = {cash:{selected:1},scholasticDollars:{selected:2}}
    * def expectedDocument = originalDocument
    * expectedDocument.fairEarning.scholasticDollars.selected = REQUEST_BODY.scholasticDollars.selected
    * expectedDocument.fairEarning.cash.selected = REQUEST_BODY.cash.selected
    Given def UpdateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
    Then match UpdateFinFormEarningsResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document contains deep expectedDocument
    * def REQUEST_BODY = {cash:{selected:1},scholasticDollars:{selected:2}}
    * expectedDocument.fairEarning.scholasticDollars.selected = REQUEST_BODY.scholasticDollars.selected
    * expectedDocument.fairEarning.cash.selected = REQUEST_BODY.cash.selected
    Given def UpdateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
    Then match UpdateFinFormEarningsResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document contains deep expectedDocument

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |