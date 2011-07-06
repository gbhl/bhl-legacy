package at.co.ait.web.common;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.security.core.userdetails.UserDetails;

public class UserPreferences implements UserDetails {
	private String username;
	private String password;
	private String basedirectory;
	private String workdirectory;
	private String organization;
	private List<String> roles;
	private List<GrantedAuthority> AUTHORITIES;
	private String smtparams;
	
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	
	public String getSmtparams() {
		return smtparams;
	}
	public void setSmtparams(String smtparams) {
		this.smtparams = smtparams;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public List<String> getRoles() {
		return roles;
	}
	public void setRoles(List<String> roles) {
		this.roles = roles;
	}
	public String getBasedirectory() {
		return basedirectory;
	}	
	public void setBasedirectory(String basedirectory) {
		this.basedirectory = basedirectory;
	}
	public String getWorkdirectory() {
		return workdirectory;
	}
	public void setWorkdirectory(String workdirectory) {
		this.workdirectory = workdirectory;
	}
	
	public Collection<GrantedAuthority> getAuthorities() {
		// XStream doesn't serialize AUTHORITIES so it needs to be initialized
		if (AUTHORITIES==null || AUTHORITIES.isEmpty()) {
			AUTHORITIES = new ArrayList<GrantedAuthority>();
			for (String role: this.roles) {
				AUTHORITIES.add(new GrantedAuthorityImpl(role));
			}
		}
		return AUTHORITIES;
	}
	
	public boolean isAccountNonExpired() {
		return true;
	}
	public boolean isAccountNonLocked() {
		return true;
	}
	public boolean isCredentialsNonExpired() {
		return true;
	}
	public boolean isEnabled() {
		return true;
	}
}
