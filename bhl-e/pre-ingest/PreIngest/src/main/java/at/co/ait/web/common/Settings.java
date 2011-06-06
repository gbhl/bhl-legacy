package at.co.ait.web.common;

import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Settings {
	private static final Logger logger = LoggerFactory.getLogger(Settings.class);
	private HashMap<String,UserPreferences> userprefs = new HashMap<String, UserPreferences>();	
	private HashMap<String,List<String>> externalcommands = new HashMap<String, List<String>>();	
	
	public void addExternalCommand(String cmd, List<String> params) {
		externalcommands.put(cmd, params);
	}
	
	public List<String> getExternalCommand(String cmd) {
		return externalcommands.get(cmd);
	}

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
