package at.co.ait.domain.oais;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

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
	private Set<DigitalObject> digitalobjects = Collections
			.synchronizedSet(new HashSet<DigitalObject>());

	public Set<DigitalObject> getDigitalobjects() {
		return digitalobjects;
	}
	
	private Set<UUID> digitalObjectUUID = new HashSet<UUID>();
	
	public void addDigitalObjectUUID(UUID id) {
		digitalObjectUUID.add(id);
	}
	
	public void removeDigitalObjectUUID(UUID id) {
		digitalObjectUUID.remove(id);
	}
	
	public Boolean isReadyForDelivering() {		
		Boolean returnVal = false;
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

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		// TODO use getClass() to build toString()
		return "noid identifer: " + getIdentifier() + "\n"
				+ "external identifier: " + getExternalIdentifier() + "\n"
				+ "digitalobject count: " + digitalobjects.size() + "\n";
	}

}
