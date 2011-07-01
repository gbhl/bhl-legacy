package at.co.ait.domain.oais;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import au.edu.apsr.mtk.base.METSWrapper;

/**
 * An OAIS Information Package (IP) contains all relevant data that needs to be
 * preserved together as one entity.
 * 
 * @author sprogerb
 * 
 */
public class InformationPackageObject extends GenericObject {

	/**
	 * IP holds all submitted files.
	 */
	private List<DigitalObject> digitalobjects = new ArrayList<DigitalObject>();

	public List<DigitalObject> getDigitalobjects() {
		return digitalobjects;
	}

	public void setDigitalobjects(List<DigitalObject> digitalobjects) {
		this.digitalobjects = digitalobjects;
	}

	private Set<UUID> digitalObjectUUID = new HashSet<UUID>();
	
	public void addDigitalObjectUUID(UUID id) {
		logger.debug(id.toString());
		digitalObjectUUID.add(id);
	}
	
	public void removeDigitalObjectUUID(UUID id) {
		digitalObjectUUID.remove(id);
	}
	
	private static final Logger logger = LoggerFactory
	.getLogger(InformationPackageObject.class);
	
	public Boolean isReadyForDelivering() {		
		Boolean returnVal = false;
		logger.debug(String.valueOf(digitalObjectUUID.size()));
		if (digitalObjectUUID.size() == 0) returnVal = true;
		return returnVal;
	}
	
	/**
	 * Identifier stores minted nice opaque id (NOID).
	 */
	private String identifier;

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	/**
	 * An external identifier is created based on the containing digital
	 * objects' parent folder name.
	 */
	private String externalIdentifier;

	public String getExternalIdentifier() {
		return externalIdentifier;
	}

	public void setExternalIdentifier(String externalIdentifier) {
		this.externalIdentifier = externalIdentifier;
	}

	/**
	 * IP stores all information in METS.
	 */
	private METSWrapper mets;

	public METSWrapper getMets() {
		return mets;
	}

	public void setMets(METSWrapper mets) {
		this.mets = mets;
	}

	public void addDigitalObject(DigitalObject obj) {
		getDigitalobjects().add(obj);
	}
	
	/**
	 * Store virusscan results for folder
	 */
	private File scanlog;
	
	public File getScanlog() {
		return scanlog;
	}

	public void setScanlog(File scanlog) {
		this.scanlog = scanlog;
	}

	private File nepomukFileOntology;

	public File getNepomukFileOntology() {
		return nepomukFileOntology;
	}

	public void setNepomukFileOntology(File nepomukFileOntology) {
		this.nepomukFileOntology = nepomukFileOntology;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		// TODO use getClass() to build toString()
		return "noid identifer: " + getIdentifier() + "\n"
				+ "external identifier: " + getExternalIdentifier() + "\n"
				+ "digitalobject count: " + digitalobjects.size() + "\n";
	}

}
