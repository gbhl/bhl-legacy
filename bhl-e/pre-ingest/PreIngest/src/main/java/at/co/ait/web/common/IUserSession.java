package at.co.ait.web.common;

public interface IUserSession {

	public void init();

	public UserPreferences getPrefs();

	public void setPrefs(UserPreferences prefs);

	public String getSmtparams();

	public String getUsername();

}