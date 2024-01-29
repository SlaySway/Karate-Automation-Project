@UpdateFinFormPurchaseOrders @PerformanceEnhancement
Feature: UpdateFinFormPurchaseOrders PATCH Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def updateFinFormPurchaseOrdersUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/financials/form/purchase-orders"
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }

  @Unhappy
  Scenario Outline: Validate when invalid request body type for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = ""
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateHomepageResponse.responseStatus == 204
    And match updateHomepageResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_FAIRS"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateHomepageResponse.responseStatus == 204
    And match updateHomepageResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694300           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace updateFinFormPurchaseOrdersUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
    Given method put
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |
      | current           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * replace updateFinFormPurchaseOrdersUri.fairIdOrCurrent =  "current"
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
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateHomepageResponse.responseStatus == 403
    And match updateHomepageResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5734325           |

  @Unhappy
  Scenario Outline: Validate when user uses invalid fair ID for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateHomepageResponse.responseStatus == 404
    And match updateHomepageResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_FAIR_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | abc1234           |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateHomepageResponse.responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(updateHomepageResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR |
      | azhou1@scholastic.com | password1 | 5694296           | 5694296       |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT: <SBF_JARVIS_FAIR>}
    * def REQUEST_BODY = {}
    * replace updateFinFormPurchaseOrdersUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method put
    Then match responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5694296           | 5694296       | 5694300         |
      | azhou1@scholastic.com | password1 | current           | 5694296       | 5694296         |

  @Unhappy
  Scenario Outline: Validate when current is used without SBF_JARVIS user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateFinFormPurchaseOrdersUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request {}
    Given method put
    Then match responseStatus == 400
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SELECTED_FAIR"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | current           |

  @Unhappy
  Scenario Outline: Validate when current is used without SBF_JARVIS user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateFinFormPurchaseOrdersUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateFinFormPurchaseOrdersUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request {}
    Given method put
    Then match responseStatus == 400
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SELECTED_FAIR"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | current           |

  @Unhappy
  Scenario Outline: Validate when invalid request body for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = read('UpdateFinFormPurchaseOrdersRequests.json')[requestBodyJson]
    Given def updateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match updateFinFormPurchaseOrdersResponse.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | requestBodyJson |
      | azhou1@scholastic.com | password1 | 5694296           | invalidAmount   |

  @Happy
  Scenario Outline: Validate mongo is updated in appropriate fields for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
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
      let updatedPOs = new Map(updatedFields.map(purchaseOrder=>[purchaseOrder.purchaseOrderNumber, purchaseOrder]));
      let currentPOs = new Map(currentDocument.map(purchaseOrder=>[purchaseOrder.purchaseOrderNumber, purchaseOrder]));
      let purchaseOrderSchema = {
        "purchaseOrderNumber" : "1",
        "amount" : "2",
        "contactName" : "3",
        "agencyName" : "4",
        "address" : "5",
        "city" : "6",
        "state" : "7",
        "zipCode" : "8"
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
        "purchaseOrders": [
            {
                "purchaseOrderNumber": "1",
                "amount": 1,
                "contactName": "PostmanTesting",
                "agencyName": "Scholastic",
                "address": "NYE",
                "city": "Marryland",
                "state": "ss",
                "zipCode": "34567"
            },
            {
                "purchaseOrderNumber": "3",
                "amount": 2,
                "contactName": "PostTesting",
                "agencyName": "sd",
                "address": "asfh",
                "city": "david",
                "state": "ss",
                "zipCode": "112233"
            }
        ]
    }
    """
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    And def expectedDocument = mongoJson.document
    * def newPurchaseOrdersList = updatePurchaseOrdersList(expectedDocument.sales.purchaseOrdersList, REQUEST_BODY.purchaseOrders)
    And set expectedDocument.sales.purchaseOrdersList = newPurchaseOrdersList
    Given def UpdateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match UpdateFinFormPurchaseOrdersResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document contains expectedDocument
    * def REQUEST_BODY =
    """
    {
    "purchaseOrders": [
        {
            "purchaseOrderNumber": "1",
            "amount": 3,
            "contactName": "PostmanTestingss",
            "agencyName": "Scholasticssss",
            "address": "NYEsss",
            "city": "Marrylandsss",
            "state": "ssss",
            "zipCode": "445566"
        },
        {
            "purchaseOrderNumber": "3",
            "amount": 4,
            "contactName": "PostTestingsss",
            "agencyName": "sdss",
            "address": "asfhss",
            "city": "davesss",
            "state": "ssss",
            "zipCode": "223344"
        }
      ]
    }
    """
    And def expectedDocument = mongoJson.document
    And set expectedDocument.sales.purchaseOrdersList = updatePurchaseOrdersList(expectedDocument.sales.purchaseOrdersList, REQUEST_BODY.purchaseOrders)
    Given def UpdateFinFormPurchaseOrdersResponse = call read('RunnerHelper.feature@UpdateFinFormPurchaseOrders')
    Then match UpdateFinFormPurchaseOrdersResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document contains expectedDocument

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694296           |