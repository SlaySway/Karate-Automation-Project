Feature: Wallet Flow Api tests

  Scenario Outline: User creates wallet, gets the wallet, updates the wallet details, moves the wallet to another fair, then closes the wallet
    # Create an ewallet for an active and existing fair
    * string fairId = FAIR_ID
    * string userId = USER_ID
    # Create an ewallet for user and fair then check its been created in getWallet and getFairWallets
    * def createWalletRequestBody =
    """
      {
        "customerProfileId": '#(userId)',
        "fairId": '#(fairId)',
        "studentFirstName": "KarateAutomated",
        "studentLastName": "Testing",
        "teacherFirstName": "CreatingWallet",
        "teacherLastName": "Step",
        "parentFirstName": "NextStep",
        "parentLastName": "IsChangingDetails",
        "grade": "pre_k",
        "recipientType": "TEACHER"
      }
    """
    Given def createWalletResponse = call read('RunnerHelper.feature@CreateWallet') {REQUEST_BODY:'#(createWalletRequestBody)'}
    Then match createWalletResponse.response ==
    """
    {
      id: '#regex[0-9]+',
      uuid: '#regex[0-9,a-z,-]+'
    }
    """
    * def walletId = createWalletResponse.response.id
    * def walletUuid = createWalletResponse.response.uuid
    Given def getFairWalletsResponse = call read('classpath:common/bookfairs/ewallet_2/fair_controller/RunnerHelper.feature@GetWalletsByFairId') {FAIRID:'#(fairId)'}
    Then match getFairWalletsResponse.responseStatus == 200
    And def createdWallet = karate.jsonPath(getFairWalletsResponse.response, "$[?(@.id==" + walletId + ")]" )[0]
    And match createdWallet.uuid == walletUuid
    And match createdWallet contains createWalletRequestBody
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    And match getWalletResponse.response == createdWallet
    Given def getWalletByParametersResponse = call read('RunnerHelper.feature@GetWalletsByParameters') {idamUserId:'#(userId)', fairId:'#(fairId)', remainingBalance:'', activeWallets:''}
    Then match getWalletByParametersResponse.responseStatus == 200
    And def createdWallet = karate.jsonPath(getWalletByParametersResponse.response, "$[?(@.id==" + walletId + ")]" )[0]
    And match createdWallet.uuid == walletUuid
    And match createdWallet contains createWalletRequestBody
    * def voucherKey = getWalletResponse.response.voucherKey
    # Update eWallet details
    * def updateWalletRequestBody =
    """
      {
        "studentFirstName": "ChangingName",
        "studentLastName": "ForKarate",
        "teacherFirstName": "Automation",
        "teacherLastName": "Testing",
        "parentFirstName": "NextThingToDo",
        "parentLastName": "IsChangingFairOwnership",
      }
    """
    Given def updateWalletResponse = call read('RunnerHelper.feature@UpdateWalletInfoByWalletId') {WALLETID:'#(walletId)', REQUEST_BODY:'#(updateWalletRequestBody)'}
    Then match updateWalletResponse.responseStatus == 200
    And match updateWalletResponse.response.id == walletId + ""
    And match updateWalletResponse.response.uuid == walletUuid
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    And match getWalletResponse.response contains updateWalletRequestBody
    # Transfer wallet and check that it's been properly transferred
    * def fairToTransferTo = FAIR_TO_TRANSFER_TO
    Given def moveWalletToFairResponse = call read('RunnerHelper.feature@MoveWalletToOtherFair') {WALLETID:'#(walletId)', FAIRID:'#(fairToTransferTo)'}
    Then match moveWalletToFairResponse.responseStatus == 200
    Given def getFairWalletsResponse = call read('classpath:common/bookfairs/ewallet_2/fair_controller/RunnerHelper.feature@GetWalletsByFairId') {FAIRID:'#(fairToTransferTo)'}
    Then match getFairWalletsResponse.responseStatus == 200
    And def wallet = karate.jsonPath(getFairWalletsResponse.response, "$[?(@.id==" + walletId + ")]" )[0]
    And match wallet.uuid == walletUuid
    Given def getFairWalletsResponse = call read('classpath:common/bookfairs/ewallet_2/fair_controller/RunnerHelper.feature@GetWalletsByFairId') {FAIRID:'#(fairId)'}
    Then match getFairWalletsResponse.responseStatus == 200
    * def attemptToFindWallet = karate.jsonPath(getFairWalletsResponse.response, "$[?(@.id==" + walletId + ")]" )
    And match [] == attemptToFindWallet
    # Transfer wallet back
    Given def moveWalletToFairResponse = call read('RunnerHelper.feature@MoveWalletToOtherFair') {WALLETID:'#(walletId)', FAIRID:'#(fairId)'}
    Then match moveWalletToFairResponse.responseStatus == 200
    Given def getFairWalletsResponse = call read('classpath:common/bookfairs/ewallet_2/fair_controller/RunnerHelper.feature@GetWalletsByFairId') {FAIRID:'#(fairId)'}
    Then match getFairWalletsResponse.responseStatus == 200
    And def wallet = karate.jsonPath(getFairWalletsResponse.response, "$[?(@.id==" + walletId + ")]" )[0]
    And match wallet.uuid == walletUuid
    # Fund the wallet
    * def walletTracker = wallet
    * def getDate =
    """
    function() {
      var DateTimeFormatter = Java.type('java.time.format.DateTimeFormatter');
      var dtf = DateTimeFormatter.ofPattern('ddHHmmss');
      var ldt = java.time.LocalDateTime.now();
      return ldt.format(dtf);
    }
    """
    * def REQUEST_BODY =
    """
    {
    "orderId": '#(getDate())',
    "amount": 4,
    "fundType": "cc",
    "purchaserInfo": {
        "idamUserId": "98220298",
        "firstName": "KarateAPITesting",
        "lastName": "AutomatedTests",
        "email": "azhou1@scholastic.com",
        "state": "NY",
        "walletOwner": false
        }
    }
    """
    Given def fundWalletResponse = call read('classpath:common/bookfairs/ewallet_2/fund_controller/RunnerHelper.feature@FundWalletByWalletId') {WALLETID:'#(walletId)'}
    Then match fundWalletResponse.responseStatus == 201
    * def transactionId = fundWalletResponse.response.id
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    Then def createdTransaction = karate.jsonPath(getWalletResponse.response.transactions, "$[?(@.id==" + transactionId + ")]" )[0]
    And match createdTransaction.amount == REQUEST_BODY.amount
    And match createdTransaction.fundType == REQUEST_BODY.fundType
    And match createdTransaction.orderId == REQUEST_BODY.orderId
    And match createdTransaction.purchaserInfo.isWalletOwner == REQUEST_BODY.purchaserInfo.walletOwner
    * remove createdTransaction.purchaserInfo.isWalletOwner
    * remove REQUEST_BODY.purchaserInfo.walletOwner
    And match createdTransaction.purchaserInfo == REQUEST_BODY.purchaserInfo
    * set walletTracker.amount = walletTracker.amount + REQUEST_BODY.amount
    * match getWalletResponse.response.amount == walletTracker.amount
    * match getWalletResponse.response.saleAmount  == walletTracker.saleAmount
    * match getWalletResponse.response.refundAmount == walletTracker.refundAmount
    # Create wallet SALE transaction
    * def REQUEST_BODY =
    """
    {
      "type": "SALE",
      "amount": 1,
      "timestamp": '#(getDate())',
      "reference": '#(getDate())',
      "note": "From Karate API Testing",
      "source": "string",
      "cashier": {
        "idamUserId": "string"
      }
    }
    """
    Given def createTransactionResponse = call read('classpath:common/bookfairs/ewallet_2/transaction_controller/RunnerHelper.feature@CreateWalletTransaction') {WALLETID:'#(walletId)'}
    Then match createTransactionResponse.responseStatus == 201
    * def transactionId = createTransactionResponse.response.id
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    Then def createdTransaction = karate.jsonPath(getWalletResponse.response.transactions, "$[?(@.id==" + transactionId + ")]" )[0]
    And match createdTransaction.amount == REQUEST_BODY.amount
    And match createdTransaction.type == REQUEST_BODY.type
    And match createdTransaction.note == REQUEST_BODY.note
    And match createdTransaction.source == REQUEST_BODY.source
    And match createdTransaction.cashier == REQUEST_BODY.cashier
    * set walletTracker.amount = walletTracker.amount - REQUEST_BODY.amount
    * set walletTracker.saleAmount = walletTracker.saleAmount + REQUEST_BODY.amount
    * match getWalletResponse.response.amount == walletTracker.amount
    * match getWalletResponse.response.saleAmount  == walletTracker.saleAmount
    * match getWalletResponse.response.refundAmount == walletTracker.refundAmount
    # Create wallet release
    * def REQUEST_BODY =
    """
    {
      "amount": 1,
      "reference": '#(getDate())',
      "orderId": '#(getDate())'
    }
    """
    Given def createTransactionResponse = call read('classpath:common/bookfairs/ewallet_2/transaction_controller/RunnerHelper.feature@CreateWalletRelease') {WALLETID:'#(walletId)'}
    Then match createTransactionResponse.responseStatus == 201
    * def transactionId = createTransactionResponse.response.id
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    Then def createdTransaction = karate.jsonPath(getWalletResponse.response.transactions, "$[?(@.id==" + transactionId + ")]" )[0]
    And match createdTransaction.amount == REQUEST_BODY.amount
    And match createdTransaction.type == "RELEASE"
    And match createdTransaction.orderId == REQUEST_BODY.orderId
    And match createdTransaction.reference == REQUEST_BODY.reference
    * set walletTracker.amount = walletTracker.amount - REQUEST_BODY.amount
    * match getWalletResponse.response.amount == walletTracker.amount
    * match getWalletResponse.response.saleAmount  == walletTracker.saleAmount
    * match getWalletResponse.response.refundAmount == walletTracker.refundAmount
    # Close wallet
    Given def closeWalletResponse = call read('RunnerHelper.feature@CloseWalletByWalletId') {WALLETID:'#(walletId)'}
    Then match closeWalletResponse.responseStatus == 204
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    And match getWalletResponse.response.status == "CLOSED"
    # Attempt creating a transaction sale
    * def REQUEST_BODY =
    """
    {
      "type": "SALE",
      "amount": 1,
      "timestamp": '#(getDate())',
      "reference": '#(getDate())',
      "note": "From Karate API Testing",
      "source": "string",
      "cashier": {
        "idamUserId": "string"
      }
    }
    """
    Given def createTransactionResponse = call read('classpath:common/bookfairs/ewallet_2/transaction_controller/RunnerHelper.feature@CreateWalletTransaction') {WALLETID:'#(walletId)'}
    Then match createTransactionResponse.responseStatus == 404
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    * match getWalletResponse.response.amount == walletTracker.amount
    * match getWalletResponse.response.saleAmount  == walletTracker.saleAmount
    * match getWalletResponse.response.refundAmount == walletTracker.refundAmount
    # Attempt funding the wallet
    * def REQUEST_BODY =
    """
    {
    "orderId": '#(getDate())',
    "amount": 1,
    "fundType": "cc",
    "purchaserInfo": {
        "idamUserId": "98220298",
        "firstName": "KarateAPITesting",
        "lastName": "AutomatedTests",
        "email": "azhou1@scholastic.com",
        "state": "NY",
        "walletOwner": false
        }
    }
    """
    Given def fundWalletResponse = call read('classpath:common/bookfairs/ewallet_2/fund_controller/RunnerHelper.feature@FundWalletByWalletId') {WALLETID:'#(walletId)'}
    Then match fundWalletResponse.responseStatus == 404
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    * match getWalletResponse.response.amount == walletTracker.amount
    * match getWalletResponse.response.saleAmount  == walletTracker.saleAmount
    * match getWalletResponse.response.refundAmount == walletTracker.refundAmount
    # Create a reconciliation
    * def REQUEST_BODY =
    """
    [
      {
        "amount": 1,
        "voucherKey": "#(voucherKey)",
        "fairId": "#(fairId)",
        "reference": "#(getDate())"
      }
    ]
    """
    Given def createReconciliationResponse = call read('classpath:common/bookfairs/ewallet_2/reconciliation_controller/RunnerHelper.feature@CreateReconciliations')
    Then match createReconciliationResponse.responseStatus == 201
    * def reconciliationId = createReconciliationResponse.response.id
    * def reconciliationReference = createReconciliationResponse.response.result.reference
    Given def getReconciliationResponse = call read('classpath:common/bookfairs/ewallet_2/reconciliation_controller/RunnerHelper.feature@GetReconciliationById'){RECONCILIATION_ID:'#(reconciliationId)'}
    Then match getReconciliationResponse.responseStatus == 200
    Given def getReconciliationReportResponse = call read('classpath:common/bookfairs/ewallet_2/reconciliation_controller/RunnerHelper.feature@GetReconciliationReportById'){RECONCILIATION_ID:'#(reconciliationId)'}
    Then match getReconciliationReportResponse.responseStatus == 200
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
    Then match getWalletResponse.responseStatus == 200
    Then def createdTransaction = karate.jsonPath(getWalletResponse.response.transactions, "$[?(@.reference=='" + reconciliationReference + "')]" )[0]
    And match createdTransaction.amount == REQUEST_BODY[0].amount
    * set walletTracker.amount = walletTracker.amount - REQUEST_BODY[0].amount
    * set walletTracker.saleAmount = walletTracker.saleAmount + REQUEST_BODY[0].amount
    * match getWalletResponse.response.amount == walletTracker.amount
    * match getWalletResponse.response.saleAmount  == walletTracker.saleAmount
    * match getWalletResponse.response.refundAmount == walletTracker.refundAmount

    @QA
    Examples:
      | USER_ID  | FAIR_ID | FAIR_TO_TRANSFER_TO |
      | 98483103 | 5694301 | 5694302             |