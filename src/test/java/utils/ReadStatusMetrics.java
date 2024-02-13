package utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * 
 * @author Ravindra Pallerla
 * 
 */

public class ReadStatusMetrics {

	static int TotalTestCases = 0;
	static int TotalTestCasesPassed = 0;
	static int TotalTestCasesFailed = 0;

	static DocumentBuilderFactory dbf;
	static DocumentBuilder db;

	/*
	 * public static void main(String[] args) throws IOException,
	 * ParserConfigurationException, SAXException, JSONException { readXMlFiles(
	 * "C:\\Bitbucket\\bookfairs-services-karate-api-automation\\target\\karate-reports",
	 * "target\\Results.json", "json"); }
	 */

	public static void readXMlFiles(String directory, String targetFile, String fileType)
			throws IOException, ParserConfigurationException, SAXException, JSONException {

		File folder = new File(directory);
		List<File> aList = new ArrayList<File>();
		File[] files = folder.listFiles();
		for (File f : files) {
			if (f.isFile() && getFileExtensionName(f).indexOf("xml") != -1) {

				System.out.println("File Name is ===> " + f);
				String xmlFile = new String(Files.readAllBytes(f.toPath()), Charset.defaultCharset());
				dbf = DocumentBuilderFactory.newInstance();
				db = dbf.newDocumentBuilder();
				Document doc = db.parse(f);
				doc.getDocumentElement().normalize();

				NodeList nList = doc.getElementsByTagName("testsuite");
				for (int temp = 0; temp < nList.getLength(); temp++) {
					Node nNode = nList.item(temp);
					if (nNode.getNodeType() == Node.ELEMENT_NODE) {
						Element eElement = (Element) nNode;
						String Tests = eElement.getAttribute("tests");
						String Failures = eElement.getAttribute("failures");

						int EachFileTests = Integer.parseInt(Tests);
						int EachFileFailures = Integer.parseInt(Failures);

						TotalTestCases = TotalTestCases + EachFileTests;
						TotalTestCasesFailed = TotalTestCasesFailed + EachFileFailures;
						aList.add(f);
					}
				}

			}
		}
		TotalTestCasesPassed = TotalTestCases - TotalTestCasesFailed;
		System.out.println("------------------------------------------------------------");
		System.out.println("TotalTestCases ===> " + TotalTestCases);
		System.out.println("TotalTestCasesPassed ===> " + TotalTestCasesPassed);
		System.out.println("TotalTestCasesFailed ===> " + TotalTestCasesFailed);

		if (fileType.equalsIgnoreCase("json")) {
			generateResultsJSON(targetFile);

		} else if (fileType.equalsIgnoreCase("xml")) {

			System.out.println("Yet to implement");
		}

	}

	public static void generateResultsJSON(String targetFile) throws JSONException, IOException {

		String tot = Integer.toString(TotalTestCases);
		String passed = Integer.toString(TotalTestCasesPassed);
		String failed = Integer.toString(TotalTestCasesFailed);

		JSONObject results = new JSONObject();
		results.put("totalTestCases", tot);
		results.put("totalTestCasesPassed", passed);
		results.put("totalTestCasesFailed", failed);

		JSONObject resultsObject = new JSONObject();
		resultsObject.put("results", results);

		// Write JSON file
		try (FileWriter file = new FileWriter(targetFile)) {
			file.write(resultsObject.toString());
			file.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public static String getFileExtensionName(File f) {
		if (f.getName().indexOf(".") == -1) {
			return "";
		} else {
			return f.getName().substring(f.getName().length() - 3, f.getName().length());
		}
	}
}
