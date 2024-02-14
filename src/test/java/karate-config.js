function fn() {
	var env = karate.env;
	karate.log('karate.env system property was:', env);
	if (!env) {
		env = 'qa';
	}
	var config = {
		env: env,

		BOOKFAIRS_JARVIS_URL: 'https://bookfairs-jarvis.qa.apps.scholastic.tech',
		BOOKFAIRS_JARVIS_BASE: 'https://bookfairs-jarvis.stage.apps.scholastic.tech',

		BOOKFAIRS_CONTENT_URL: 'https://bookfairs-content.qa.apps.scholastic.tech',
		BOOKFAIRS_CONTENT_BASE: 'https://bookfairs-content.stage.apps.scholastic.tech',

		CONTENT_ACCESS_TOKEN: '3dIx0ZzA49dKFMQmZKEPnz3aUWesIafl',

		SCHL_LOGIN_URL: 'https://login-qa.scholastic.com',
		SCHL_LOGIN_BASE: 'https://login-stage.scholastic.com',

		CMDM_URL: 'https://qa-internal.api.scholastic.com',
		CMDM_BEARER_TOKEN: '3dIx0ZzA49dKFMQmZKEPnz3aUWesIafl',

		BOOKFAIRS_FATPIPE_REPORTS_URL: 'https://fatpipe-reports-api.qa.apps.scholastic.tech',
		BOOKFAIRS_FATPIPE_REPORTS_BASE: 'https://fatpipe-reports-api.stage.apps.scholastic.tech',
		BOOKFAIRS_FATPIPE_REPORTS_TARGET: 'https://fatpipe-reports-api.qa.apps.scholastic.tech',

		BOOKFAIRS_SERVICE_URL: 'https://bookfairs-service.qa.apps.scholastic.tech',

		BOOKFAIRS_PAYPORTAL_URL: 'https://payportal-service.qa.apps.scholastic.tech',
		BOOKFAIRS_EWALLET_2_URL: 'https://ewallet-2.qa.apps.scholastic.tech',

		LIBRARY_PROCESSING_URL: 'https://library-processing.qa.apps.scholastic.tech',
		LIBRARY_PROCESSING_BASE: 'https://library-processing.stage.apps.scholastic.tech',

		CANADA_TOOLKIT_URL: "https://canada-toolkit.qa.apps.scholastic.tech",
		CANADA_TOOLKIT_BASE: "https://canada-toolkit.stage.apps.scholastic.tech"

	}

	if (env == 'dev') {

		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE = '';
		config.BOOKFAIRS_CONTENT_URL = '';
		config.BOOKFAIRS_CONTENT_BASE = '';
		config.BOOKFAIRS_CONTENT_TARGET = '';
		config.EXTERNAL_SCH_COOKIE_URL = '';
		config.BOOKFAIRS_SERVICE_URL = '';

	} else if (env == 'stage') {

		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE = '';
		config.BOOKFAIRS_CONTENT_URL = '';
		config.BOOKFAIRS_CONTENT_BASE = '';
		config.BOOKFAIRS_CONTENT_TARGET = '';
		config.EXTERNAL_SCH_COOKIE = '';
		config.BOOKFAIRS_SERVICE_URL = '';

	} else if (env == 'prod') {

		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE = '';
		config.BOOKFAIRS_CONTENT_URL = '';
		config.BOOKFAIRS_CONTENT_BASE = '';
		config.BOOKFAIRS_CONTENT_TARGET = '';
		config.EXTERNAL_SCH_COOKIE = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_URL = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_BASE = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_TARGET = '';
		config.BOOKFAIRS_SERVICE_URL = '';

	}

	return config;
}