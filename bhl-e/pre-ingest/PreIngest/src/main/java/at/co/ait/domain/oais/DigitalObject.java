package at.co.ait.domain.oais;

import java.io.File;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.apache.commons.codec.binary.Hex;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.google.common.io.Files;

public class DigitalObject extends GenericObject {

	/**
	 * Submitted file is immediately scanned for viruses.
	 */
	private String virusscanResult;

	public String getVirusscanResult() {
		return virusscanResult;
	}

	public void setVirusscanResult(String virusscanResult) {
		this.virusscanResult = virusscanResult;
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
	}

	/**
	 * Extracted technical metadata of the submitted file. Generated using JHOVE
	 * library.
	 */
	private String techMetadata;

	public String getTechMetadata() {
		return techMetadata;
	}

	public void setTechMetadata(String techMetadata) {
		this.techMetadata = techMetadata;
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
	}

	// needed for SpEL evaluation
	public Integer getObjecttypeIdx() {
		return objecttype.getIndex();
	}

	// mods SMT
	private String smtoutput;

	public String getSmtoutput() {
		return smtoutput;
	}

	public void setSmtoutput(String mods) {
		this.smtoutput = mods;
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

	private String smtServiceLog;

	public String getSmtServiceLog() {
		return smtServiceLog;
	}

	public void setSmtServiceLog(String smtServiceLog) {
		this.smtServiceLog = smtServiceLog;
	}
	
	private String ocr;

	public String getOcr() {
		return ocr;
	}

	public void setOcr(String ocr) {
		this.ocr = ocr;
	}
	
	private String taxa;

	public String getTaxa() {
		return taxa;
	}

	public void setTaxa(String taxa) {
		this.taxa = taxa;
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
