Feature: Wallet Flow Api tests

  Scenario: User creates wallet, gets the wallet, updates the wallet details, moves the wallet to another fair, then closes the wallet
    # Create an ewallet for an active and existing fair
    * string fairId = '5694296'
    * string userId = '98483103'
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
    # TODO restore below lines when done with temp testing, and delete the harcoded walletId and walletUuid
#    Given def createWalletResponse = call read('RunnerHelper.feature@CreateWallet') {REQUEST_BODY:'#(createWalletRequestBody)'}
#    Then match createWalletResponse.response ==
#    """
#    {
#      id: '#regex[0-9]+',
#      uuid: '#regex[0-9,a-z,-]+'
#    }
#    """
#    * def walletId = createWalletResponse.response.id
#    * def walletUuid = createWalletResponse.response.uuid
    * def walletId = 1214819
    * def walletUuid = "710fb0f1-6377-4250-9dbe-625621f670e7"
    Given def getFairWalletsResponse = call read('classpath:common/bookfairs/ewallet_2/fair_controller/RunnerHelper.feature@GetWalletsByFairId') {FAIRID:'#(fairId)'}
      Then match getFairWalletsResponse.responseStatus == 200
      And def createdWallet = karate.jsonPath(getFairWalletsResponse.response, "$[?(@.id==" + walletId + ")]" )[0]
      And match createdWallet.uuid == walletUuid
      And match createdWallet contains createWalletRequestBody
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
      Then match getWalletResponse.responseStatus == 200
      And match getWalletResponse.response == createdWallet
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
    # TODO Delete 57 - 69, temp code to change the details back so I can rerun this multi times
    * def updateWalletRequestBody =
    """
      {
        "studentFirstName": "KarateAutomated",
        "studentLastName": "Testing",
        "teacherFirstName": "CreatingWallet",
        "teacherLastName": "Step",
        "parentFirstName": "NextStep",
        "parentLastName": "IsChangingDetails"
      }
    """
    Given def updateWalletResponse = call read('RunnerHelper.feature@UpdateWalletInfoByWalletId') {WALLETID:'#(walletId)', REQUEST_BODY:'#(updateWalletRequestBody)'}
      Then match updateWalletResponse.responseStatus == 200
    Given def getWalletResponse = call read('RunnerHelper.feature@GetWalletByWalletID') {WALLETID:'#(walletId)'}
      Then match getWalletResponse.responseStatus == 200
      And match getWalletResponse.response contains updateWalletRequestBody
    # end of TODO delete
    * def fairToTransferTo = '5697025'
    Given def moveWalletToFairResponse = call read('RunnerHelper.feature@MoveWalletToOtherFair') {WALLETID:'#(walletId)', FAIRID:'#(fairToTransferTo)'}
      Then match getWalletResponse.responseStatus == 200
    Given def getFairWalletsResponse = call read('classpath:common/bookfairs/ewallet_2/fair_controller/RunnerHelper.feature@GetWalletsByFairId') {FAIRID:'#(fairToTransferTo)'}
      Then match getFairWalletsResponse.responseStatus == 200
      And def wallet = karate.jsonPath(getFairWalletsResponse.response, "$[?(@.id==" + walletId + ")]" )[0]
      And match wallet.uuid == walletUuid
    Given def getFairWalletsResponse = call read('classpath:common/bookfairs/ewallet_2/fair_controller/RunnerHelper.feature@GetWalletsByFairId') {FAIRID:'#(fairId)'}
      Then match getFairWalletsResponse.responseStatus == 200
    * def attemptToFindWallet = karate.jsonPath(getFairWalletsResponse.response, "$[?(@.id==" + walletId + ")]" )
    And match [] == attemptToFindWallet
  # Transfer fair back
    Given def moveWalletToFairResponse = call read('RunnerHelper.feature@MoveWalletToOtherFair') {WALLETID:'#(walletId)', FAIRID:'#(fairId)'}
     Then match getWalletResponse.responseStatus == 200
    Given def getFairWalletsResponse = call read('classpath:common/bookfairs/ewallet_2/fair_controller/RunnerHelper.feature@GetWalletsByFairId') {FAIRID:'#(fairId)'}
      Then match getFairWalletsResponse.responseStatus == 200
      And def wallet = karate.jsonPath(getFairWalletsResponse.response, "$[?(@.id==" + walletId + ")]" )[0]
      And match wallet.uuid == walletUuid
  # End of transferring fair back




    # ?? fund the wallet
    # Get the wallet details and verify funding
    # Close the wallet
    # Get wallet details and make sure its closed

    # All things to possibly do before ewallet is closed
    # Possibly fund the wallet?
    # Verify fund is created
    # Create transaction
    # Verify transaction is created
    # Create wallet release
    # Verify fund in wallet has been released

  # Add move ewallet test when fair is not active