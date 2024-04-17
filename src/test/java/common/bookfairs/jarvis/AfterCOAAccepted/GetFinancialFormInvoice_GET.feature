@GetFinancialFormInvoice @PerformanceEnhancement @4bfinfrom
Feature: GetFinancialFormInvoice GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getFinancialFormInvoiceUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/form/invoice"

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormInvoiceResponse = call read('RunnerHelper.feature@GetFinancialFormInvoice')
    Then match getFinancialFormInvoiceResponse.responseStatus == 204
    And match getFinancialFormInvoiceResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID |
      | nofairs@testing.com | password1 | current     |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormInvoiceResponse = call read('RunnerHelper.feature@GetFinancialFormInvoice')
    Then match getFinancialFormInvoiceResponse.responseStatus == 204
    And match getFinancialFormInvoiceResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694300     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * replace getFinancialFormInvoiceUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormInvoiceUri
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | RESOURCE_ID |
      | 5694296     |
      | current     |

  @Unhappy
  Scenario: Validate when SCHL cookie is expired
    * replace getFinancialFormInvoiceUri.resourceId =  "current"
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormInvoiceUri
    * cookies { SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIj'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormInvoiceResponse = call read('RunnerHelper.feature@GetFinancialFormInvoice')
    Then match getFinancialFormInvoiceResponse.responseStatus == 403
    And match getFinancialFormInvoiceResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormInvoiceResponse = call read('RunnerHelper.feature@GetFinancialFormInvoice')
    Then match getFinancialFormInvoiceResponse.responseStatus == 404
    And match getFinancialFormInvoiceResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | abc1234     |

  @Happy @ignore #TODO: not all the fairs will have invoice ready since invoice requires whole process to be done, not sure if we want to do this test for this
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<RESOURCE_ID>, scenario:<SCENARIO>
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    Then match getFinancialFormEarningsResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(getFinancialFormEarningsResponse.responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME                                   | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SCENARIO                                     |
      | azhou1@scholastic.com                       | password2 | 5694296     | 5694296       | Return path parameter fairId information     |
      | azhou1@scholastic.com                       | password2 | current     | 5694296       | Has current, upcoming, and past fairs        |
      | hasAllFairs@testing.com                     | password2 | current     | 5694301       | Has all fairs                                |
      | hasUpcomingAndPastFairs@testing.com         | password1 | current     | 5694305       | Has upcoming and past fairs                  |
      | hasPastFairs@testing.com                    | password1 | current     | 5694307       | Has past fairs                               |
      | hasRecentlyUpcomingAndPastFairs@testing.com | password1 | current     | 5694303       | Has recently ended, upcoming, and past fairs |

  @Happy @ignore #TODO: same issue as above
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<RESOURCE_ID>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getFinancialFormEarningsUri.resourceId = RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormEarningsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method get
    Then match responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694296       | 5694309         |
      | azhou1@scholastic.com | password2 | current     | 5694296       | 5694296         |

  @Happy @Mongo
  Scenario Outline: Validate invoice response with mongo, cmdm, and calculations for user <USER_NAME>, fair:<RESOURCE_ID>
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
    * def AGGREGATE_PIPELINE =
    """
    [
      {
        $match:{
            "_id":"#(RESOURCE_ID)"
        }
      }
    ]
    """
    * def mongoResults = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@RunAggregate'){collectionName: "financials"}
    * convertNumberDecimal(mongoResults.document[0])
    * print mongoResults.document[0]

    * def getCMDMFairResponse = call read('classpath:common/cmdm/fairs/CMDMRunnerHelper.feature@GetFairRunner'){FAIR_ID:<RESOURCE_ID>}

    Given def getFinancialFormInvoiceResponse = call read('RunnerHelper.feature@GetFinancialFormInvoice')
    * print getFinancialFormInvoiceResponse
    * match getFinancialFormInvoiceResponse.response.number == "W" + RESOURCE_ID + "BF"
    * match getFinancialFormInvoiceResponse.response.host.name == getCMDMFairResponse.response.chairperson.firstName + " " + getCMDMFairResponse.response.chairperson.lastName
    * match getFinancialFormInvoiceResponse.response.host.email == getCMDMFairResponse.response.chairperson.email
    * match getFinancialFormInvoiceResponse.response.school.name == getCMDMFairResponse.response.organization.name
    * match getFinancialFormInvoiceResponse.response.school.address == getCMDMFairResponse.response.organization.addressLine1
    * match getFinancialFormInvoiceResponse.response.school.bookfairAccountId == getCMDMFairResponse.response.organization.bookfairAccountId

#    * match getFinancialFormInvoiceResponse.response.amountDetails.totalCollected == getCMDMFairResponse.response.organization.bookfairAccountId

    * def calculateAmountDetails =
    """
    function(financialsDocument){
      let expectedAmountDetails = {}
      let purchaseOrderSum = 0
      for(let purchaseOrder of financialsDocument.purchaseOrders){
        purchaseOrderSum += purchaseOrder.amount
      }

      expectedAmountDetails.totalCollected = financialsDocument.sales.tenderTotals.creditCards + financialsDocument.sales.tenderTotals.cashAndChecks + purchaseOrderSum + (0.5*financialsDocument.sales.scholasticDollars.totalRedeemed)
      expectedAmountDetails.digitalPaymentsCollected = financialsDocument.sales.tenderTotals.creditCards
      expectedAmountDetails.amountDue = expectedAmountDetails.totalCollected - financialsDocument.sales.tenderTotals.creditCards - purchaseOrderSum - financialsDocument.fairEarning.cash.selected

      return expectedAmountDetails
    }
    """
    * match getFinancialFormInvoiceResponse.response.amountDetails == calculateAmountDetails(mongoResults.document[0])

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694296     |
