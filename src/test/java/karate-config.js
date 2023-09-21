function fn() {
	var env = karate.env;
	karate.log('karate.env system property was:', env);
	if (!env) {
		env = 'qa';
	}
	var config = {
		env: env,
		 BOOKFAIRS_JARVIS_URL: 'https://bookfairs-jarvis.qa.apps.scholastic.tech/bookfairs-jarvis',
		 SCHL_LOGIN_URL : 'https://login-qa.scholastic.com/api/login',
		 CMDM_URL : 'https://qa-internal.api.scholastic.com/cmdm/fair-service/v1',

	}
	
	if (env == 'qa') {
		
        config.BOOKFAIRS_JARVIS_URL = 'https://bookfairs-jarvis.qa.apps.scholastic.tech';
        config.BOOKFAIRS_JARVIS_BASE= 'https://bookfairs-jarvis.qa.apps.scholastic.tech';
        config.BOOKFAIRS_JARVIS_TARGET = 'https://bookfairs-jarvis.qa.apps.scholastic.tech';

        config.EXTERNAL_SCH_COOKIE_URL = 'https://login-qa.scholastic.com';
        config.EXTERNAL_SCH_COOKIE_BASE = 'https://login-qa.scholastic.com';
        config.EXTERNAL_SCH_COOKIE_TARGET = 'https://login-qa.scholastic.com';

        config.CMDM_QA_URL = 'https://qa-internal.api.scholastic.com';
        config.EXTERNAL_CMDM_URL = "https://qa-internal.api.scholastic.com/cmdm/fair-service/v1";
        config.CMDM_BEARER_TOKEN = "3dIx0ZzA49dKFMQmZKEPnz3aUWesIafl"

        config.BOOKFAIRS_JARVIS_URL = "https://bookfairs-jarvis.qa.apps.scholastic.tech/bookfairs-jarvis";
        config.SCHL_LOGIN_URL = "https://login-qa.scholastic.com/api/login";
        config.CMDM_URL = "https://qa-internal.api.scholastic.com/cmdm/fair-service/v1"

	} else if (env == 'dev') {
		
		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE= '';
		config.EXTERNAL_SCH_COOKIE_URL = '';
		
	} else if (env == 'stage') {
		
		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE= '';
		config.EXTERNAL_SCH_COOKIE = '';
		
	} else if (env == 'prod') {

		config.BOOKFAIRS_JARVIS_URL = 'author';
		config.BOOKFAIRS_JARVIS_TARGET = 'authorpassword';
		config.BOOKFAIRS_JARVIS_BASE= '';
		config.EXTERNAL_SCH_COOKIE = '';
	}

	return config;
}