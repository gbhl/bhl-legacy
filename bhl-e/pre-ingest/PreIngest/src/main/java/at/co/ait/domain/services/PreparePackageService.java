package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
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
		for (File fileObj : folderFileObj.listFiles()) {
			DigitalObject obj = new DigitalObject(loggenericobject);
			objlist.add(obj);
			obj.setFolder(folderFileObj);
			obj.setOrder(order++);
			obj.setSubmittedFile(fileObj);
			obj.setPrefs(prefs);
			obj.setFileurl(ConfigUtils.createFileURL(fileObj, prefs.getBasedirectory()));
		}	
		return objlist;
	}
}
