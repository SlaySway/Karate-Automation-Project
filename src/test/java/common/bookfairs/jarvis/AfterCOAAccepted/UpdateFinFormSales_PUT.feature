@UpdateFinFormSales @PerformanceEnhancement
Feature: UpdateFinFormSales PUT Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def updateFinFormSalesUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/form/sales"
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }

  @Unhappy
  Scenario Outline: Validate when invalid request body for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = ""
    Given def updateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match updateFinFormSalesResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    Given def updateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match updateFinFormSalesResponse.responseStatus == 204
    And match updateFinFormSalesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID | requestBodyJson |
      | nofairs@testing.com | password1 | 5694296     | updateSales     |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    Given def updateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match updateFinFormSalesResponse.responseStatus == 204
    And match updateFinFormSalesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | requestBodyJson |
      | azhou1@scholastic.com | password1 | 5694300     | updateSales     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * replace updateFinFormSalesUri.resourceId =  RESOURCE_ID
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    * url BOOKFAIRS_JARVIS_URL + updateFinFormSalesUri
    Given method put
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | RESOURCE_ID | requestBodyJson |
      | 5694296     | updateSales     |
      | current     | updateSales     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * replace updateFinFormSalesUri.resourceId =  "current"
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    * url BOOKFAIRS_JARVIS_URL + updateFinFormSalesUri
    * cookies { SCHL : '<EXPIRED_SCHL>'}
    Given method put
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | requestBodyJson | EXPIRED_SCHL                                                                                                                                                                                                                                                      |  |
      | updateSales     | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |  |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    Given def updateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match updateFinFormSalesResponse.responseStatus == 403
    And match updateFinFormSalesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | requestBodyJson |
      | azhou1@scholastic.com | password1 | 5734325     | updateSales     |

  @Unhappy
  Scenario Outline: Validate when user uses invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    Given def updateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match updateFinFormSalesResponse.responseStatus == 404
    And match updateFinFormSalesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | requestBodyJson |
      | azhou1@scholastic.com | password1 | abc1234     | updateSales     |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    Given def updateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match updateFinFormSalesResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(updateFinFormSalesResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | requestBodyJson |
      | azhou1@scholastic.com | password1 | 5694296     | 5694296       | updateSales     |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for user:<USER_NAME>, fair:<RESOURCE_ID>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    * replace updateFinFormSalesUri.resourceId = RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormSalesUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method put
    Then match responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SBF_JARVIS_FAIR | requestBodyJson |
      | azhou1@scholastic.com | password1 | 5694296     | 5694296       | 5694309         | updateSales     |
      | azhou1@scholastic.com | password1 | current     | 5694296       | 5694296         | updateSales     |

  @Unhappy
  Scenario Outline: Validate when current is used without SBF_JARVIS user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace updateFinFormSalesUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + updateFinFormSalesUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    Given method put
    Then match responseStatus == 400
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SELECTED_RESOURCE"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | requestBodyJson |
      | azhou1@scholastic.com | password1 | current     | updateSales     |

  @Happy @Mongo
  Scenario Outline: Validate mongo is updated in appropriate fields for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def setBigSetFieldsToSubsetValues =
    """
    function(bigSet, subset){
      for(var key in subset){
          if(typeof bigSet[key] === 'object' && typeof subset[key] === 'object'){
            bigSet[key] = setBigSetFieldsToSubsetValues(bigSet[key], subset[key]);
          } else {
            bigSet[key] =  subset[key];
          }
      }
      return bigSet;
    }
    """
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
    * def REQUEST_BODY =
    """
    {
        "sales": {
            "scholasticDollars": {
                "totalRedeemed": 1.50,
                "taxExemptSales": 2,
                "taxCollected": 3.0
            },
            "tenderTotals": {
                "cashAndChecks": 4,
                "creditCards": 5.05,
                "purchaseOrders": 6.0
            },
            "grossSales": {
                "total": 5.50,
                "taxExemptSales": 7.00,
                "taxableSales": 8,
                "taxTotal": 6.25
            },
            "netSales": {
                "shareTheFairFunds": {
                    "collected": 9,
                    "redeemed": 10
                }
            }
        }
    }
    """
    Given def UpdateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match UpdateFinFormSalesResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document contains deep setBigSetFieldsToSubsetValues(originalDocument, REQUEST_BODY)
    * def REQUEST_BODY =
    """
    {
        "sales": {
            "scholasticDollars": {
                "totalRedeemed": 10.50,
                "taxExemptSales": 9,
                "taxCollected": 8
            },
            "tenderTotals": {
                "cashAndChecks": 7,
                "creditCards": 6,
                "purchaseOrders": 5
            },
            "grossSales": {
                "total": 2,
                "taxExemptSales": 4,
                "taxableSales": 3,
                "taxTotal":  5
            },
            "netSales": {
                "shareTheFairFunds": {
                    "collected": 2,
                    "redeemed": 1
                }
            }
        }
    }
    """
    Given def UpdateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match UpdateFinFormSalesResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And match mongoJson.document contains deep setBigSetFieldsToSubsetValues(originalDocument, REQUEST_BODY)

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |