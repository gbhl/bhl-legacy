package at.co.ait.web.common;

import static org.junit.Assert.fail;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration
public class TestConfigSerializer {
	
	private static final Logger logger = LoggerFactory.getLogger(TestConfigSerializer.class);
	private @Autowired Settings settings;
	private UserPreferences preferences;
	private @Autowired ConfigSerializer config;
	
	@Before
	public void setUp() throws Exception {	
		preferences = new UserPreferences();
	}

	@After
	public void tearDown() throws Exception {
		preferences=null;
	}

	@Test
	public void testSetSettings() {
		preferences.setUsername("alice");
		preferences.setPassword("pass");
		preferences.setBasedirectory("file:///C:/temp");
		preferences.setWorkdirectory("file:///C:/temp");
		List<String> roles = new ArrayList<String>();
		roles.add("ROLE_USER");
		roles.add("ROLE_ADMIN");
		preferences.setRoles(roles);		
		settings.addUserSettingsByName(preferences.getUsername(), preferences);
		config.setSettings(settings);
		fail("Not yet implemented");
	}

	@Test
	public void testSaveSettings() {
		preferences.setUsername("alice");
		preferences.setPassword("pass");
		preferences.setBasedirectory("file:///C:/ProjectData/BHL-E-FTP");
		preferences.setWorkdirectory("file:///C:/temp");
		// add roles
		List<String> roles = new ArrayList<String>();
		roles.add("ROLE_USER");
		roles.add("ROLE_ADMIN");
		preferences.setRoles(roles);
		settings.addUserSettingsByName(preferences.getUsername(), preferences);
		// add external commands
		logger.debug("settings: create new array ");
		List<String> commands = new ArrayList<String>();
		logger.debug("settings: created ");
		logger.debug("settings: add string to array ");
		commands.add("file:///C:/Program Files (x86)/ClamWin/bin/clamscan.exe");
		logger.debug("settings: added ");
		logger.debug("settings: add string to array ");
		commands.add("--no-summary");
		logger.debug("settings: added ");
		logger.debug("settings: add command to settings ");
		settings.addExternalCommand("scan", commands);		
		logger.debug("settings: added ");
		logger.debug("settings: set config settings");
		config.setSettings(settings);
		logger.debug("settings: set ");
		try {
			config.saveSettings();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		fail("Not yet implemented");
	}

}
