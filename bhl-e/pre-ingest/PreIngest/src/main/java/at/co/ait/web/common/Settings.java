package at.co.ait.web.common;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Settings {
	private HashMap<String,UserPreferences> settings = new HashMap<String, UserPreferences>();
	private static final Logger logger = LoggerFactory.getLogger(Settings.class);

	public UserPreferences getUserSettingsByName(String username) {
		UserPreferences usrpref = null;
		if (settings.containsKey(username))
			usrpref = settings.get(username);
		return usrpref;
	}
	
	public void addUserSettingsByName(String username, UserPreferences preferences) {
		settings.put(username, preferences);
	}
}
