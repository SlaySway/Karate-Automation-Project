@UpdateFinFormPurchaseOrders @PerformanceEnhancement
Feature: UpdateFinFormPurchaseOrders PUT Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def updateFinFormPurchaseOrdersUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/form/purchase-orders"
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
    * def invalidPurchaseOrderUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/forms/purchase-order"

  @Unhappy
  Scenario Outline: Validate when invalid request body type for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = ""
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694296     |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 204
    And match updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID |
      | nofairs@testing.com | password1 | 5694296     |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 204
    And match updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694300     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * replace updateFinFormPurchaseOrdersUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
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
    * replace updateFinFormPurchaseOrdersUri.resourceId =  "current"
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
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
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 403
    And match updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 404
    And match updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | abc1234     |

  @Unhappy
  Scenario Outline: Validate when unsupported http method is called
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace updateFinFormPurchaseOrdersUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method patch
    Then match responseStatus == 405
    Then match response.error == "Method Not Allowed"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694309         |

  @Unhappy
  Scenario Outline: Validate for internal server error
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace invalidPurchaseOrderUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + invalidPurchaseOrderUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method put
    Then match responseStatus == 500

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694309         |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694296       |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for user:<USER_NAME>, fair:<RESOURCE_ID>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * def REQUEST_BODY = read('UpdateFinFormPurchaseOrdersRequests.json')[requestBodyJson]
    * replace updateFinFormPurchaseOrdersUri.resourceId = RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method put
    Then match responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SBF_JARVIS_FAIR | requestBodyJson |
      | azhou1@scholastic.com | password2 | 5694296     | 5694296       | 5694309         | validPayload    |
      | azhou1@scholastic.com | password2 | current     | 5694296       | 5694296         | validPayload    |

  @Unhappy
  Scenario Outline: Validate when current is used without SBF_JARVIS user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateFinFormPurchaseOrdersUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request {}
    Given method put
    Then match responseStatus == 400
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SELECTED_RESOURCE"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | current     |

  @Unhappy
  Scenario Outline: Validate when current is used without SBF_JARVIS user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateFinFormPurchaseOrdersUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request {}
    Given method put
    Then match responseStatus == 400
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SELECTED_RESOURCE"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | current     |

  @Unhappy
  Scenario Outline: Validate when invalid request body for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormPurchaseOrdersRequests.json')[requestBodyJson]
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | requestBodyJson |
      | azhou1@scholastic.com | password2 | 5694296     | invalidAmount   |

  @Unhappy @ignore
  Scenario Outline: Validate when user exceeds maximum(10) purchase orders list inputs i.e., 11 fairs:<USER_NAME>, fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormPurchaseOrdersRequests.json')[requestBodyJson]
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 400

    @QA
    Examples:
      | USER_NAME              | PASSWORD | RESOURCE_ID | requestBodyJson      |
      | mtodaro@scholastic.com | passw0rd | 5694314     | ElevenPurchaseOrders |

  @Happy @Mongo
  Scenario Outline: Validate mongo is updated in purchase order field for user:<USER_NAME>, fair:<RESOURCE_ID>, request scenario: <requestBody>
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
    And def originalPurchaseOrderList = mongoJson.document.purchaseOrders
    * def REQUEST_BODY = read('UpdateFinFormPurchaseOrdersRequests.json')[requestBody]
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document.purchaseOrders == REQUEST_BODY.list
    * def REQUEST_BODY =
    """
    {
      "list" : "#(originalPurchaseOrderList)"
    }
    """
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document.purchaseOrders == REQUEST_BODY.list

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | requestBody            |
      | azhou1@scholastic.com | password2 | 5694296     | twoValidPurchaseOrders |
      | azhou1@scholastic.com | password2 | 5694296     | validPayload           |
      | azhou1@scholastic.com | password2 | 5694296     | emptyList              |

  Scenario Outline: Validate when user uses max limits of fields:<USER_NAME>, fair:<RESOURCE_ID>
    * def convertValuesToThatOfJson =
    """
    function(jsonToChange, jsonOfChanges){
      for(let field in jsonOfChanges){
          jsonToChange[field] = jsonOfChanges[field]
        }
    }
    """
    * def jsonOfChanges = read('UpdateFinFormPurchaseOrdersRequests.json')[replaceValuesWithJson]
    * def REQUEST_BODY =
    """
    {
      "list": [
        {
          "number": "automationPurchaseOrder1",
          "amount": 1,
          "contactName": "Automation Robot",
          "agencyName": "NY DOE",
          "address": "507 Broadway",
          "city": "New Jersey",
          "state": "NJ",
          "zipcode": "10011"
        }
      ]
    }
    """
    * convertValuesToThatOfJson(REQUEST_BODY.list[0],jsonOfChanges)
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | replaceValuesWithJson |
      | azhou1@scholastic.com | password2 | 5694296     | maxLengths            |

  Scenario Outline: Validate when user has invalid field:<USER_NAME>, fair:<RESOURCE_ID>, invalid_field: <replaceValuesWithJson>
    * def convertValuesToThatOfJson =
    """
    function(jsonToChange, jsonOfChanges){
      for(let field in jsonOfChanges){
          jsonToChange[field] = jsonOfChanges[field]
        }
    }
    """
    * def jsonOfChanges = read('UpdateFinFormPurchaseOrdersRequests.json')[replaceValuesWithJson]
    * def REQUEST_BODY =
    """
    {
      "list": [
        {
          "number": "automationPurchaseOrder1",
          "amount": 1,
          "contactName": "Automation Robot",
          "agencyName": "NY DOE",
          "address": "507 Broadway",
          "city": "New Jersey",
          "state": "NJ",
          "zipcode": "10011"
        }
      ]
    }
    """
    * convertValuesToThatOfJson(REQUEST_BODY.list[0],jsonOfChanges)
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | replaceValuesWithJson        |
      | azhou1@scholastic.com | password2 | 5694296     | overCharLimitNumber          |
      | azhou1@scholastic.com | password2 | 5694296     | nonAlphanumericalNumber      |
      | azhou1@scholastic.com | password2 | 5694296     | overLimitAmount              |
      | azhou1@scholastic.com | password2 | 5694296     | overCharLimitAmount          |
      | azhou1@scholastic.com | password2 | 5694296     | overCharLimitContactName     |
      | azhou1@scholastic.com | password2 | 5694296     | nonAlphanumericalContactName |
      | azhou1@scholastic.com | password2 | 5694296     | overCharLimitAgencyName      |
      | azhou1@scholastic.com | password2 | 5694296     | nonAlphanumericalAgencyName  |
      | azhou1@scholastic.com | password2 | 5694296     | overCharLimitAddress         |
      | azhou1@scholastic.com | password2 | 5694296     | nonAlphanumericalAddress     |
      | azhou1@scholastic.com | password2 | 5694296     | overCharLimitCity            |
      | azhou1@scholastic.com | password2 | 5694296     | nonAlphanumericalCity        |
      | azhou1@scholastic.com | password2 | 5694296     | alphaZipcode                 |
      | azhou1@scholastic.com | password2 | 5694296     | underCharMinZipcode          |

  Scenario Outline: Validate when user has null for mandatory fields:<USER_NAME>, fair:<RESOURCE_ID>, nulled_field: <mandatoryField>
    * def REQUEST_BODY =
    """
    {
      "list": [
        {
          "number": "automationPurchaseOrder1",
          "amount": 1,
          "contactName": "Automation Robot",
          "agencyName": "NY DOE",
          "address": "507 Broadway",
          "city": "New Jersey",
          "state": "NJ",
          "zipcode": "10011"
        }
      ]
    }
    """
    * REQUEST_BODY.list[0][mandatoryField] = null
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | mandatoryField |
      | azhou1@scholastic.com | password2 | 5694296     | number         |
      | azhou1@scholastic.com | password2 | 5694296     | amount         |
      | azhou1@scholastic.com | password2 | 5694296     | contactName    |
      | azhou1@scholastic.com | password2 | 5694296     | agencyName     |
      | azhou1@scholastic.com | password2 | 5694296     | address        |
      | azhou1@scholastic.com | password2 | 5694296     | city           |
      | azhou1@scholastic.com | password2 | 5694296     | state          |
      | azhou1@scholastic.com | password2 | 5694296     | zipcode        |

  Scenario Outline: Validate when user inputs "" for mandatory fields:<USER_NAME>, fair:<RESOURCE_ID>, empty_field: <mandatoryField>
    * def REQUEST_BODY =
    """
    {
      "list": [
        {
          "number": "automationPurchaseOrder1",
          "amount": 1,
          "contactName": "Automation Robot",
          "agencyName": "NY DOE",
          "address": "507 Broadway",
          "city": "New Jersey",
          "state": "NJ",
          "zipcode": "10011"
        }
      ]
    }
    """
    * REQUEST_BODY.list[0][mandatoryField] = ""
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | mandatoryField |
      | azhou1@scholastic.com | password2 | 5694296     | number         |
      | azhou1@scholastic.com | password2 | 5694296     | amount         |
      | azhou1@scholastic.com | password2 | 5694296     | contactName    |
      | azhou1@scholastic.com | password2 | 5694296     | agencyName     |
      | azhou1@scholastic.com | password2 | 5694296     | address        |
      | azhou1@scholastic.com | password2 | 5694296     | city           |
      | azhou1@scholastic.com | password2 | 5694296     | state          |
      | azhou1@scholastic.com | password2 | 5694296     | zipcode        |