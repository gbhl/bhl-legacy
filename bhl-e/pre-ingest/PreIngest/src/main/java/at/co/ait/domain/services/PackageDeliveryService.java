package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.annotation.Resource;
import javax.inject.Inject;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import at.co.ait.domain.integration.ILoadingGateway;
import at.co.ait.domain.integration.IPrepDigObjGateway;
import at.co.ait.domain.integration.IPrepInfPkgGateway;
import at.co.ait.domain.integration.IReqNoidGateway;
import at.co.ait.domain.integration.IReqVirusscanGateway;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;

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

	/**
	 * Keep a physical reference to all package objects for later usage. At any
	 * time new information packages could be created.
	 */
	private Set<InformationPackageObject> packages = new HashSet<InformationPackageObject>();

	public Set<InformationPackageObject> getPackageInfo() {
		return packages;
	}

	private IReqNoidGateway noidGateway;
	private @Autowired ILoadingGateway loading;
	@Resource(name = "noidRequestGateway")
	public void setNoidGateway(IReqNoidGateway noidGateway) {
		this.noidGateway = noidGateway;
	}

	/**
	 * Iterates all files in the folder and prepares an information package.
	 * 
	 * @param folderLocat
	 *            String containing the information package's folder.
	 * @return
	 */
	public void preparePackage(File folderFileObj) {
		InformationPackageObject infopackage = new InformationPackageObject();
		// keep track of all package objects
		packages.add(infopackage);
		infopackage.setSubmittedFile(folderFileObj);
		// TODO integrity check of external identifier
		infopackage.setExternalIdentifier(folderFileObj.getName());
		// request new NOID mint from PlNoidStomp
		String identifier = null;
		try {
			identifier = noidGateway.requestNoid("mint").get(1,
					TimeUnit.SECONDS);
		} catch (InterruptedException e1) {
			logger.info(e1.getClass().getName() + ":" + e1.getMessage());
		} catch (ExecutionException e1) {
			logger.info(e1.getClass().getName() + ":" + e1.getMessage());
		} catch (TimeoutException e1) {
			logger.info(e1.getClass().getName() + ":" + e1.getMessage());
		}
		logger.info(identifier);
		infopackage.setIdentifier(identifier);
		UUID infopackageUUID = infopackage.getId();
		for (File fileObj : folderFileObj.listFiles()) {
			DigitalObject obj = new DigitalObject();
			obj.setInformationPackageUUID(infopackageUUID);
			obj.setSubmittedFile(fileObj);
			// calculate hash directly in Digital Object
			// TODO create hash value service
			try {
				obj.calculateHash(fileObj);
			} catch (IOException e) {
				e.printStackTrace();
			} catch (NoSuchAlgorithmException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// set the external identifier from information package
			obj.setExternalIdentifier(infopackage.getExternalIdentifier());

			// call gateway proxy and send the digital object to service
			loading.load(obj, "digitalobject");
		}
	}
	
	/**
	 * Put DigitalObject into the box for further packaging and wrap-up.
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
				logger.info("info package found for "
						+ value.getExternalIdentifier());
				pkg = value;
			}
		}
		pkg.addDigitalObject(obj);
		pkg.removeDigitalObjectUUID(obj.getId());
		// invoke message to further process the information package
		if (pkg.isReadyForDelivering())
			// prepInfPkgGateway.prepareInformationPackage(pkg);
			loading.load(pkg, "informationpackage");
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
