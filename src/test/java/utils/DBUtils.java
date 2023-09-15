package utils;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.support.rowset.ResultSetWrappingSqlRowSet;

/**
 * @author Ravindra Pallerla
 * 
 */

public class DBUtils {

	private static final Logger logger = LoggerFactory.getLogger(DBUtils.class);

	static String url;
	static String username;
	static String password;
	static String driverClassName;

	private final JdbcTemplate jdbc;

	public DBUtils(String DBNAME, String UserName, String Pwd) throws IOException {

		url = "";
		driverClassName = "";
		username = UserName;
		password = Pwd;

		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName(driverClassName);
		dataSource.setUrl(url);
		dataSource.setUsername(username);
		dataSource.setPassword(password);
		jdbc = new JdbcTemplate(dataSource);
		logger.info("init jdbc template: {}", url);
	}

	public int getRowsCount(String query) {

		int rowCount = 0;
		ResultSetWrappingSqlRowSet rowSet = (ResultSetWrappingSqlRowSet) jdbc.queryForRowSet(query);
		while (rowSet.next()) {
			rowCount++;
		}

		return rowCount;

	}

	public Object readValue(String query) {
		return jdbc.queryForObject(query, Object.class);
	}

	public Map<String, Object> readRow(String query) {
		return jdbc.queryForMap(query);
	}

	public List<Map<String, Object>> readRows(String query) {
		return jdbc.queryForList(query);
	}

}