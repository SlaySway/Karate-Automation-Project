package common;

/**
 * @author Ravindra Pallerla
 * 
 */

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

public class ParallelRunner {

	@Test
	public void executeTest() {
		// need to have path and tags be variables
		System.out.println("TestPath before converting: " + System.getProperty("testPath"));
		System.out.println("Tags before converting: " + System.getProperty("tags"));
//		String testPath = System.getProperty("testPath"); //== null ? "classpath:common/bookfairs/jarvis" : System.getProperty("testPath");
//		String[] tags = new String[]{System.getProperty("tags")}; //== null ? new String[]{"@QA", "~@Regression"} : new String[]{System.getProperty("tags")};
		String testPath = System.getProperty("testPath") == null ? "classpath:common/bookfairs/jarvis" : System.getProperty("testPath");
		String[] tags = new String[]{System.getProperty("tags")} == null ? new String[]{"@QA", "~@Regression"} : new String[]{System.getProperty("tags")};

		System.out.println("TestPath after conversion: " + testPath);
		System.out.println("Tags after conversion: " + String.join(",", tags));


		Results results = Runner.path(testPath).outputCucumberJson(true).outputJunitXml(true)
				.configDir("src/test/java").tags(tags).parallel(1);

		System.out.println("Total Feature => " + results.getFeaturesTotal());
		System.out.println("Total Scenarios => " + results.getScenariosTotal());
		System.out.println("Passed Scenarios => " + results.getScenariosPassed());
		System.out.println("Failed Scenarios => " + results.getFailCount());

		generateCucumberReport(results.getReportDir());
		Assertions.assertEquals(0, results.getFailCount(), results.getErrorMessages());

	}

	private static void generateCucumberReport(String reportDirLocation) {
		Collection<File> jsonFiles = FileUtils.listFiles(new File(reportDirLocation), new String[] { "json" }, true);

		List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
		jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));

		Configuration configuration = new Configuration(new File("target"), "KarateAPITest");
		ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, configuration);
		reportBuilder.generateReports();
	}

}