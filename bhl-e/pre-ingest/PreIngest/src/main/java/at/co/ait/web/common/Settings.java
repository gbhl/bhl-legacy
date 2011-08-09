package at.co.ait.web.common;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Settings {
	private static final Logger logger = LoggerFactory.getLogger(Settings.class);
	private HashMap<String,UserPreferences> userprefs = new HashMap<String, UserPreferences>();	

	public UserPreferences getUserSettingsByName(String username) {
		UserPreferences usrpref = null;
		if (userprefs.containsKey(username))
			usrpref = userprefs.get(username);
		return usrpref;
	}
	
	public void addUserSettingsByName(String username, UserPreferences preferences) {
		userprefs.put(username, preferences);
	}
}
