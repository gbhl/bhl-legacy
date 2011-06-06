package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;

import at.co.ait.domain.integration.ILoadingGateway;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.web.common.UserPreferences;

/**
 * Entrypoint to start packaging of information packages which contain digital
 * objects.
 * 
 * @author sprogerb
 * 
 */
public class PackageDeliveryService {

	private static final Logger logger = LoggerFactory
			.getLogger(PackageDeliveryService.class);
	private UserPreferences prefs;

	/**
	 * Keep a physical reference to all package objects for later usage. At any
	 * time new information packages could be created.
	 */
	private Set<InformationPackageObject> packages = new HashSet<InformationPackageObject>();

	public Set<InformationPackageObject> getPackageInfo() {
		return packages;
	}

	private @Autowired ILoadingGateway loading;

	/**
	 * Iterates all files in the folder and prepares an information package.
	 * 
	 * @param folderLocat
	 *            String containing the information package's folder.
	 * @return
	 */
	public void preparePackage(File folderFileObj) {		
		InformationPackageObject infopackage = new InformationPackageObject();
		infopackage.setSubmittedFile(folderFileObj);
		// TODO integrity check of external identifier
		infopackage.setExternalIdentifier(folderFileObj.getName());

		UUID infopackageUUID = infopackage.getId();
		List<DigitalObject> objlist = new ArrayList<DigitalObject>();
		for (File fileObj : folderFileObj.listFiles()) {
			DigitalObject obj = new DigitalObject();
			objlist.add(obj);
			obj.setInformationPackageUUID(infopackageUUID);
			infopackage.addDigitalObjectUUID(obj.getId());
			obj.setSubmittedFile(fileObj);
			// set the external identifier from information package
			obj.setExternalIdentifier(infopackage.getExternalIdentifier());
		}
		// keep track of all package objects
		packages.add(infopackage);
		for (DigitalObject obj : objlist) {
			// call gateway proxy and send the digital object to service
			// FIXME
			// Problem with async operations
			// loading.load(obj, "digitalobject");		
			prefs = (UserPreferences) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			loading.loaddigitalobject(obj, "digitalobject", infopackage.getId().toString(), prefs.getUsername());
		}
	}

	/**
	 * Put DigitalObject into the box for further packaging and wrap-up.
	 * 
	 * @param obj
	 */
	public void box(DigitalObject obj) {
		// add digital object to information package and deliver the package
		InformationPackageObject pkg = null;
		// iterate all information packages to find the one which holds the
		// digital object UUID
		for (Iterator<InformationPackageObject> it = packages.iterator(); it
				.hasNext();) {
			InformationPackageObject value = it.next();
			if (value.getId() == obj.getInformationPackageUUID()) {
				pkg = value;
			}
		}
		pkg.addDigitalObject(obj);
		pkg.removeDigitalObjectUUID(obj.getId());
		// invoke message to further process the information package
		if (pkg.isReadyForDelivering()) {
			// prepInfPkgGateway.prepareInformationPackage(pkg);
			loading.load(pkg, "informationpackage");
		}
	}

	public void wrapup(InformationPackageObject obj) {
		String destfolder = "C:/ProjectData/BHL-Tests/archive/"
				+ obj.getIdentifier() + "/";
		synchronized (obj.getDigitalobjects()) {
			for (DigitalObject digobj : obj.getDigitalobjects()) {
				try {
					FileUtils.copyFile(digobj.getSubmittedFile(), new File(
							destfolder + digobj.getSubmittedFile().getName()));
					File metsfname = new File(destfolder + "mets.xml");
					obj.getMets().write(FileUtils.openOutputStream(metsfname));
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}

}
