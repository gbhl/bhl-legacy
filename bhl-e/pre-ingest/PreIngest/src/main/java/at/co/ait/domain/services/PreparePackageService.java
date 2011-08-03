package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import at.co.ait.domain.integration.ILoadingGateway;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.LogGenericObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.web.common.UserPreferences;

public class PreparePackageService {
	
	private @Autowired ILoadingGateway loading;
	private @Autowired LogGenericObject loggenericobject;
	private DigitalObject digitalobject;

	public List<DigitalObject> prepare(File folderFileObj, UserPreferences prefs) throws IOException {
		List<DigitalObject> objlist = new ArrayList<DigitalObject>();
		Integer order = 0;
		List<File> files = Arrays.asList(folderFileObj.listFiles());
		Collections.sort(files);
		
		for (File fileObj : files) {
			System.out.println(fileObj.getName());
			DigitalObject obj = new DigitalObject(loggenericobject);
			// warn: prefs needs to be the first setter
			obj.setPrefs(prefs);			
			obj.setFolder(folderFileObj);
			obj.setOrder(order++);
			obj.setSubmittedFile(fileObj);			
			obj.setFileurl(ConfigUtils.createFileURL(fileObj));
			objlist.add(obj);
		}	
		return objlist;
	}
}
