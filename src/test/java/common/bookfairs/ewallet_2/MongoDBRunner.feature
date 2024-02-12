@ignore @report=true
Feature: Helper for accessing ewallet Mongo

  Background: Set config
    * def uri = "mongodb+srv://egift-dev:nlFlUfFWAQ677Y71@virtual-payment-gateway-qa-nc1xz.mongodb.net/admin?retryWrites=true&replicaSet=virtual-payment-gateway-qa-shard-0&readPreference=primary&srvServiceName=mongodb&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1"
    * def dbName = "ewallet"
#    * def uri = "mongodb+srv://egift-dev:nlFlUfFWAQ677Y71@virtual-payment-gateway-qa-nc1xz.mongodb.net/admin?retryWrites=true&replicaSet=virtual-payment-gateway-qa-shard-0&readPreference=primary&srvServiceName=mongodb&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1"
#    * def uri = "mongodb+srv://egift-dev:nlFlUfFWAQ677Y71@virtual-payment-gateway-dev-nc1xz.mongodb.net/ewallet?retryWrites=true&w=majority"
    # Input: collection, field, value
    # Output: document (returns document as JSON)
  @FindDocumentByField
  Scenario: Find and return document by field
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, collection)
    * json document = db.findByField(collection, field, value)
    * print document
    * db.disconnect()

    # Input: collection, field, value, updateField, updateValue
    # Output: document (returns document as JSON)
  @FindDocumentByFieldThenUpdateField
  Scenario: Find and return document by field
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, collection)
    * json document = db.findByFieldThenUpdate(collection, field, value, updateField, updateValue)
    * print document
    * db.disconnect()