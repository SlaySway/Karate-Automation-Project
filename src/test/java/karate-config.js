function fn() {
	var env = karate.env;
	karate.log('karate.env system property was:', env);
	if (!env) {
		env = 'qa';
	}
	var config = {
		env: env,
        		BOOKFAIRS_JARVIS_URL: 'https://bookfairs-jarvis.qa.apps.scholastic.tech/bookfairs-jarvis',
        		BOOKFAIRS_JARVIS_BASE: 'https://bookfairs-jarvis.stage.apps.scholastic.tech/bookfairs-jarvis',
        		BOOKFAIRS_JARVIS_TARGET: 'https://bookfairs-jarvis.qa.apps.scholastic.tech/bookfairs-jarvis',
        		BOOKFAIRS_CONTENT_URL: 'https://bookfairs-content.qa.apps.scholastic.tech',
        		BOOKFAIRS_CONTENT_BASE: 'https://bookfairs-content.stage.apps.scholastic.tech',
        		BOOKFAIRS_CONTENT_TARGET: 'https://bookfairs-content.qa.apps.scholastic.tech',
        		EXTERNAL_SCH_COOKIE_URL: 'https://login-qa.scholastic.com',
        		EXTERNAL_SCH_COOKIE_BASE: 'https://login-stage.scholastic.com',
        		EXTERNAL_SCH_COOKIE_TARGET: 'https://login-qa.scholastic.com',
        		CMDM_URL: 'https://qa-internal.api.scholastic.com/cmdm/fair-service/v1',
        		CMDM_QA_URL: 'https://qa-internal.api.scholastic.com',
        		CONTENT_ACCESS_TOKEN: '3dIx0ZzA49dKFMQmZKEPnz3aUWesIafl',
        		SCHL_LOGIN_URL: 'https://login-qa.scholastic.com',
        		SCHL_LOGIN_URL_TARGET: 'https://login-qa.scholastic.com',
        		SCHL_LOGIN_URL_BASE: 'https://login-stage.scholastic.com',
        		BOOKFAIRS_FATPIPE_REPORTS_URL : 'https://fatpipe-reports-api.qa.apps.scholastic.tech',
                BOOKFAIRS_FATPIPE_REPORTS_BASE : 'https://fatpipe-reports-api.qa.apps.scholastic.tech',
                BOOKFAIRS_FATPIPE_REPORTS_TARGET : 'https://fatpipe-reports-api.qa.apps.scholastic.tech',
        	}

        	if (env == 'qa') {

        		config.BOOKFAIRS_JARVIS_URL = 'https://bookfairs-jarvis.qa.apps.scholastic.tech/bookfairs-jarvis';
        		config.BOOKFAIRS_JARVIS_BASE = 'https://bookfairs-jarvis.stage.apps.scholastic.tech/bookfairs-jarvis';
        		config.BOOKFAIRS_JARVIS_TARGET = 'https://bookfairs-jarvis.qa.apps.scholastic.tech/bookfairs-jarvis';
        		config.BOOKFAIRS_CONTENT_URL = 'https://bookfairs-content.qa.apps.scholastic.tech/bookfairs-jarvis';
        		config.BOOKFAIRS_CONTENT_BASE = 'https://bookfairs-content.stage.apps.scholastic.tech/bookfairs-jarvis';
        		config.BOOKFAIRS_CONTENT_TARGET = 'https://bookfairs-content.qa.apps.scholastic.tech/bookfairs-jarvis';
        		config.EXTERNAL_SCH_COOKIE_URL = 'https://login-qa.scholastic.com';
        		config.EXTERNAL_SCH_COOKIE_BASE = 'https://login-stage.scholastic.com';
        		config.EXTERNAL_SCH_COOKIE_TARGET = 'https://login-qa.scholastic.com';
        		config.CMDM_URL = 'https://qa-internal.api.scholastic.com/cmdm/fair-service/v1';
        		config.CMDM_QA_URL = 'https://qa-internal.api.scholastic.com';
        		config.CONTENT_ACCESS_TOKEN = '3dIx0ZzA49dKFMQmZKEPnz3aUWesIafl';
        		config.SCHL_LOGIN_URL = 'https://login-qa.scholastic.com';
        		config.SCHL_LOGIN_URL_TARGET = 'https://login-qa.scholastic.com';
        		config.SCHL_LOGIN_URL_BASE = 'https://login-stage.scholastic.com';

	} else if (env == 'dev') {

		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE= '';
		config.BOOKFAIRS_CONTENT_URL = '';
        config.BOOKFAIRS_CONTENT_BASE = '';
        config.BOOKFAIRS_CONTENT_TARGET = '';
		config.EXTERNAL_SCH_COOKIE_URL = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_URL = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_BASE = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_TARGET = '';

	} else if (env == 'stage') {
		
		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE= '';
		config.BOOKFAIRS_CONTENT_URL = '';
        config.BOOKFAIRS_CONTENT_BASE = '';
        config.BOOKFAIRS_CONTENT_TARGET = '';
		config.EXTERNAL_SCH_COOKIE = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_URL = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_BASE = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_TARGET = '';


	} else if (env == 'prod') {

		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE= '';
	    config.BOOKFAIRS_CONTENT_URL = '';
        config.BOOKFAIRS_CONTENT_BASE = '';
        config.BOOKFAIRS_CONTENT_TARGET = '';
		config.EXTERNAL_SCH_COOKIE = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_URL = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_BASE = '';
		config.BOOKFAIRS_FATPIPE_REPORTS_TARGET = '';

	}

	return config;
}