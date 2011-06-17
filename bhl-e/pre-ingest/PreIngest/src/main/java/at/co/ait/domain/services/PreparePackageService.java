package at.co.ait.domain.services;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import at.co.ait.domain.integration.ILoadingGateway;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.TrackingObject;
import at.co.ait.web.common.UserPreferences;

public class PreparePackageService {
	
	private @Autowired ILoadingGateway loading;
	private DigitalObject digitalobject;

	public List<DigitalObject> prepare(File folderFileObj, UserPreferences prefs) {
		List<DigitalObject> objlist = new ArrayList<DigitalObject>();
		Integer order = 0;
		for (File fileObj : folderFileObj.listFiles()) {
			DigitalObject obj = new DigitalObject();
			objlist.add(obj);
			obj.setFolder(folderFileObj);
			obj.setOrder(order++);
			obj.setSubmittedFile(fileObj);
			obj.setPrefs(prefs);
		}	
		return objlist;
	}
}
