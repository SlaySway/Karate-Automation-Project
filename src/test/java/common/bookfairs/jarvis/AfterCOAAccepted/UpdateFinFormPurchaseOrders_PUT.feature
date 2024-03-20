@UpdateFinFormPurchaseOrders @PerformanceEnhancement
Feature: UpdateFinFormPurchaseOrders PUT Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def updateFinFormPurchaseOrdersUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/form/purchase-orders"
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }

  @Unhappy
  Scenario Outline: Validate when invalid request body type for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = ""
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |

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
      | azhou1@scholastic.com | password1 | 5694300     |

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
      | azhou1@scholastic.com | password1 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 404
    And match updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | abc1234     |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<RESOURCE_ID>
    * def REQUEST_BODY = {}
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(updateFinFormPurchaseOrdersResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR |
      | azhou1@scholastic.com | password1 | 5694296     | 5694296       |

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
      | azhou1@scholastic.com | password1 | 5694296     | 5694296       | 5694309         | validPayload    |
      | azhou1@scholastic.com | password1 | current     | 5694296       | 5694296         | validPayload    |

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
      | azhou1@scholastic.com | password1 | current     |

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
      | azhou1@scholastic.com | password1 | current     |

  @Unhappy
  Scenario Outline: Validate when invalid request body for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormPurchaseOrdersRequests.json')[requestBodyJson]
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | requestBodyJson |
      | azhou1@scholastic.com | password1 | 5694296     | invalidAmount   |

  @Unhappy @ignore
  Scenario Outline: Validate when user exceeds maximum purchase orders list inputs i.e., 13 fairs:<USER_NAME>, fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormPurchaseOrdersRequests.json')[requestBodyJson]
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |  | requestBodyJson        |
      | azhou1@scholastic.com | password1 | 5694296     |  | ThirteenPurchaseOrders |

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
    * def updatePurchaseOrdersList =
    """
    function(currentDocument, updatedFields){
      let updatedPOs = new Map(updatedFields.map(purchaseOrder=>[purchaseOrder.number, purchaseOrder]));
      let currentPOs = new Map(currentDocument.map(purchaseOrder=>[purchaseOrder.number, purchaseOrder]));
      let purchaseOrderSchema = {
        "number" : "1",
        "amount" : "2",
        "contactName" : "3",
        "agencyName" : "4",
        "address" : "5",
        "city" : "6",
        "state" : "7",
        "zipcode" : "8"
      };
      updatedPOs.forEach((updatedFields, updateOrCreatePurchaseNumber) => {
          const purchaseOrderToUpdateOrCreate = currentPOs.get(updateOrCreatePurchaseNumber)
          if(purchaseOrderToUpdateOrCreate){
              purchaseOrderToUpdateOrCreate.keySet().forEach(key => {
                  if(Object.keys(purchaseOrderSchema).includes(key)){
                      purchaseOrderToUpdateOrCreate[key] = updatedFields[key]
                  }
              })
          }else{
              let newEntry = {}
              Object.keys(purchaseOrderSchema).forEach(key => {
                  if(Object.keys(purchaseOrderSchema).includes(key)){
                      newEntry[key] = updatedFields[key]
                  }
              })
              currentPOs.set(updateOrCreatePurchaseNumber, newEntry)
          }
      })
     return Array.from(currentPOs.values())
    }
    """
    * def REQUEST_BODY =
    """
    {
  "list": [
    {
      "number": "1hjttest9877",
      "amount": 1,
      "contactName": "Rew Sss",
      "agencyName": "NY DOE",
      "address": "507 Broadway",
      "city": "New Yrk",
      "state": "NY",
      "zipcode": "10011"
    },
    {
      "number": "2tesyt6i",
      "amount": 0,
      "contactName": "And tests",
      "agencyName": "NYC DOE",
      "address": "550 road",
      "city": "New York",
      "state": "NY",
      "zipcode": "10012"
    }
  ]
}
    """
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And def expectedDocument = mongoJson.document
    * def newPurchaseOrdersList = updatePurchaseOrdersList(expectedDocument.purchaseOrders, REQUEST_BODY.list)
    And set expectedDocument.purchaseOrders = newPurchaseOrdersList
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document contains expectedDocument
    * def REQUEST_BODY =
    """
    {
  "list": [
    {
      "number": "1hjtkhjktest9877",
      "amount": 1,
      "contactName": "Postman Sss",
      "agencyName": "NY DOE",
      "address": "507 Bradway",
      "city": "New Yrk",
      "state": "XY",
      "zipcode": "10013"
    },
    {
      "number": "2tesyt6i",
      "amount": 0,
      "contactName": "TTesting tests",
      "agencyName": "NYC DEO",
      "address": "559 road",
      "city": "New York",
      "state": "YZ",
      "zipcode": "10050"
    }
  ]
}
    """
    And def expectedDocument = mongoJson.document
    And set expectedDocument.purchaseOrders = updatePurchaseOrdersList(expectedDocument.purchaseOrders, REQUEST_BODY.list)
    Given def UpdateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match UpdateFinFormPurchaseOrdersResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document contains expectedDocument

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |