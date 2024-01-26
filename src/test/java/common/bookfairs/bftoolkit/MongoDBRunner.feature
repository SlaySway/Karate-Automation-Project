@ignore @report=true
Feature: Helper for accessing bftoolkit Mongo

  Background: Set config
    * def uri = "mongodb+srv://bftoolkitUser:a6AJEefUWIF7HY7y@uber-index-qa.ipjav.mongodb.net/admin?retryWrites=true&replicaSet=UBER-INDEX-QA-shard-0&readPreference=primary&srvServiceName=mongodb&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1"
    * def dbName = "bf-toolkit"

    # Input: collection, field, value
    # Output: document (returns document as JSON)
  @FindDocumentByField
  Scenario: Find and return document by field
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, collection)
    * json document = db.findByField(collection, field, value)
    * print document
    * db.disconnect()