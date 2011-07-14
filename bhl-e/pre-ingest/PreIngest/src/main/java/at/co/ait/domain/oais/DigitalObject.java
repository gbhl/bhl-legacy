package at.co.ait.domain.oais;

import java.io.File;
import java.util.Observer;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;

public class DigitalObject extends GenericObject {
	
	public DigitalObject(LogGenericObject loggenericobject) {		
		addObserver((Observer)loggenericobject);
	}

	/**
	 * Identifier used by content producers to identify the uploaded information
	 * package. Doesn't identify the file.
	 */
	private String externalIdentifier;

	public String getExternalIdentifier() {
		return externalIdentifier;
	}

	public void setExternalIdentifier(String externalIdentifier) {
		this.externalIdentifier = externalIdentifier;
		notifyObservers(externalIdentifier);
	}

	/**
	 * Extracted technical metadata of the submitted file. Generated using JHOVE
	 * library.
	 */
	private File techMetadata;


	public File getTechMetadata() {
		return techMetadata;
	}

	public void setTechMetadata(File techMetadata) {
		this.techMetadata = techMetadata;
		setChanged();
		notifyObservers(techMetadata.getName());
	}

	/**
	 * DigitalObjectType is primarily used to route message, e.g. only metadata
	 * objects are passed alond to the descriptive mapping service.
	 */
	private DigitalObjectType objecttype;

	public DigitalObjectType getObjecttype() {
		return objecttype;
	}

	public void setObjecttype(DigitalObjectType objecttype) {
		this.objecttype = objecttype;
		setChanged();
		notifyObservers(objecttype.name());
	}

	// needed for SpEL evaluation
	public Integer getObjecttypeIdx() {
		return objecttype.getIndex();
	}

	/**
	 * File reference to output of SMTService
	 */
	private File smtoutput;

	public File getSmtoutput() {
		return smtoutput;
	}
	public void setSmtoutput(File smtoutput) {
		this.smtoutput = smtoutput;
		setChanged();
		notifyObservers(smtoutput.getName());
	}

	private UUID informationPackageUUID;

	public UUID getInformationPackageUUID() {
		return informationPackageUUID;
	}

	public void setInformationPackageUUID(UUID informationPackageUUID) {
		this.informationPackageUUID = informationPackageUUID;
	}

	private File folder;

	public File getFolder() {
		return folder;
	}

	public void setFolder(File folder) {
		this.folder = folder;
	}

	private Integer order;

	public Integer getOrder() {
		return order;
	}

	public void setOrder(Integer order) {
		this.order = order;
	}

	/**
	 * SMT generated stderr/stdout.
	 */
	private String smtServiceLog;

	public String getSmtServiceLog() {
		return smtServiceLog;
	}

	public void setSmtServiceLog(String smtServiceLog) {
		this.smtServiceLog = smtServiceLog;
	}
	
	/**
	 * OCR'ed text - can be dirty.
	 */
	private File ocr;

	public File getOcr() {
		return ocr;
	}

	public void setOcr(File ocr) {
		this.ocr = ocr;
		setChanged();
		notifyObservers(ocr.getName());
	}

	/**
	 * File reference to taxon finder generated output
	 */
	private File taxa;

	public File getTaxa() {
		return taxa;
	}

	public void setTaxa(File taxa) {
		this.taxa = taxa;
		setChanged();
		notifyObservers(taxa.getName());
	}
	
	/**
	 * Mimetype of current submittedFile
	 */
	private String mimetype;
	

	public String getMimetype() {
		return mimetype;
	}

	public void setMimetype(String mimetype) {
		this.mimetype = mimetype;
		setChanged();
		notifyObservers(mimetype);
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		// TODO use getClass() to build toString()
		return "submitted file: " + getSubmittedFile().getName() + "\n"
				+ "external identifier: " + getExternalIdentifier() + "\n"
				+ "order: " + getOrder() + "\n" + "by: "
				+ getPrefs().getUsername() + "\n";
	}

}
