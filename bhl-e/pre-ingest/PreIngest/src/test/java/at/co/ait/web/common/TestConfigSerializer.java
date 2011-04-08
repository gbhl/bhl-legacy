package at.co.ait.web.common;

import static org.junit.Assert.fail;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration
public class TestConfigSerializer {
	
	private static final Logger logger = LoggerFactory.getLogger(TestConfigSerializer.class);
	private Settings settings;
	private UserPreferences preferences;
	private @Inject ConfigSerializer config;
	
	@Before
	public void setUp() throws Exception {
		settings = new Settings();
		preferences = new UserPreferences();
		preferences.setUsername("alice");
		preferences.setPassword("pass");
		preferences.setBasedirectory("file:///C:/ProjectData/BHL-E-FTP");
		List<String> roles = new ArrayList<String>();
		roles.add("ROLE_USER");
		roles.add("ROLE_ADMIN");
		preferences.setRoles(roles);		
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testSetSettings() {
		settings.addUserSettingsByName(preferences.getUsername(), preferences);
		config.setSettings(settings);
		fail("Not yet implemented");
	}

	@Test
	public void testSaveSettings() {
		settings.addUserSettingsByName(preferences.getUsername(), preferences);
		config.setSettings(settings);
		try {
			config.saveSettings();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		fail("Not yet implemented");
	}

}
