package at.co.ait.web.common;

import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;


public class UserServiceImpl implements UserDetailsService {

	private ConfigSerializer config;
	private Settings settings;
	
	public void setSettings(Settings settings) {
		this.settings = settings;
	}

	public void setConfig(ConfigSerializer config) {
		this.config = config;
		settings = config.getSettings();
	}

	public UserDetails loadUserByUsername(String name)
			throws UsernameNotFoundException, DataAccessException {		
		if (settings.getUserSettingsByName(name)==null) throw new UsernameNotFoundException("User unknown");
		UserPreferences usr = settings.getUserSettingsByName(name);
		return usr;
	}

}