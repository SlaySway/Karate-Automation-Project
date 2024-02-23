@ignore @report=true
Feature: Helper for accessing Payportal Mongo

  Background: Set config
    * def uri = "mongodb+srv://payportalReadWrite:PkYiSAIcz7ThhfYt@virtual-payment-gateway-qa.nc1xz.mongodb.net/admin?retryWrites=true&loadBalanced=false&replicaSet=virtual-payment-gateway-qa-shard-0&readPreference=primary&srvServiceName=mongodb&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1"
    * def dbName = "payportal"

  # Input: MONGO_COMMAND
  @RunCommand
  Scenario: Run a mongo command
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * json document = db.runCommand(karate.toString(MONGO_COMMAND))
    # * print document.cursor.firstBatch[0]
    * db.disconnect()

  # Input: AGGREGATE_PIPELINE, collectionName
  @RunAggregate
  Scenario: Run a mongo command
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * json document = db.runAggregate(karate.toString(AGGREGATE_PIPELINE), collectionName)
#    * print document
    * db.disconnect()


  # Will be kept here as reference
  Scenario Outline: Test Mongo Query RunCommand
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * def mongoQueryAsJson =
    """
    {
      find: "transaction",
      "filter": {
        "export.FairID": "#(FAIRID_OR_CURRENT)"
      }
    }
    """
    * print mongoQueryAsJson
    * print karate.toString(mongoQueryAsJson)
    * json document = db.runCommand(karate.toString(mongoQueryAsJson))
    * print document
    * db.disconnect()

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694329           |

  # Will be kept here as reference
  Scenario Outline: Test Mongo Query Aggregate
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * def mongoQueryAsJson =
    """
    [
        {
            $match:{
                "export.FairID":"5694329",
                "_class":"stf"
            }
        },
        {
            $group:{
                "_id": null,
                "stfTotalSaleAmount": { $sum: "$amount" }
            }
        }
      ]
    """
    * print mongoQueryAsJson
    * print karate.toString(mongoQueryAsJson)
    * json document = db.runAggregate(karate.toString(mongoQueryAsJson), "transaction")
    * print document
    * db.disconnect()

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694329           |
