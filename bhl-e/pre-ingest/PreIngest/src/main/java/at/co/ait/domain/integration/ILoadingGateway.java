package at.co.ait.domain.integration;

import java.util.Map;

import org.springframework.integration.annotation.Header;

import at.co.ait.web.common.UserPreferences;

public interface ILoadingGateway {
	void load(Object object, @Header("OBJECT_TYPE") String type);

	void loaddigitalobject(Object object, 
			@Header("OBJECT_TYPE") String type,
			@Header("INFPKG_UUID") String uuid,
			@Header("USERNAME") String username);
	
	void loadfolder(Object object,
			@Header("PREFERENCES") UserPreferences prefs,
			@Header("OPTIONS") Map<String,String> options);
	
	void loadfile(Object object,
			@Header("PREFERENCES") UserPreferences prefs);

}
