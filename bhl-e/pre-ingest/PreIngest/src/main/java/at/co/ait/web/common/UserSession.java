package at.co.ait.web.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContextHolder;

public class UserSession implements IUserSession {
	private static final Logger logger = LoggerFactory.getLogger(UserSession.class);
	private UserPreferences prefs;
	private String smtparams;
	private String username;
	
	/* (non-Javadoc)
	 * @see at.co.ait.web.common.IUserSession#init()
	 */
	public void init() {
		logger.debug("init usersession");
	}

	/* (non-Javadoc)
	 * @see at.co.ait.web.common.IUserSession#getPrefs()
	 */
	public UserPreferences getPrefs() {
		return (UserPreferences) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	}

	/* (non-Javadoc)
	 * @see at.co.ait.web.common.IUserSession#setPrefs(at.co.ait.web.common.UserPreferences)
	 */
	public void setPrefs(UserPreferences prefs) {
		this.prefs = prefs;
	}
	
	/* (non-Javadoc)
	 * @see at.co.ait.web.common.IUserSession#getSmtparams()
	 */
	public String getSmtparams() {
		logger.debug("getting smtparams");
		logger.debug(getPrefs().getSmtparams());
		return getPrefs().getSmtparams();
	}
	
	/* (non-Javadoc)
	 * @see at.co.ait.web.common.IUserSession#getUsername()
	 */
	public String getUsername() {
		return getPrefs().getUsername();
	}
	
}
