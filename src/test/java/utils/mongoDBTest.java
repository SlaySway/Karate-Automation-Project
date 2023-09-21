package utils;

public class mongoDBTest {

	public static void main(String[] args) {

		String DBNAME = "bf-toolkit";
		String COLLECTIONNAME = "fairs";

		String uri = "mongodb+srv://bftoolkitUser:a6AJEefUWIF7HY7y@uber-index-qa.ipjav.mongodb.net/admin?retryWrites=true&replicaSet=UBER-INDEX-QA-shard-0&readPreference=primary&srvServiceName=mongodb&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1";

		MongoDBUtils mongoObj = new MongoDBUtils(uri, DBNAME, COLLECTIONNAME);

	}

}
