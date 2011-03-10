package at.co.ait.domain.oais;

import java.io.File;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

import org.apache.commons.codec.binary.Hex;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.io.Files;

public class DigitalObject extends GenericObject {

	private static final Logger logger = LoggerFactory
			.getLogger(DigitalObject.class);

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
	 * Secure hash (SHA-1) of the submitted file.
	 */
	private String digestValueinHex;

	public String getDigestValueinHex() {
		return digestValueinHex;
	}

	public void setDigestValueinHex(String digestValueinHex) {
		this.digestValueinHex = digestValueinHex;
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
		logger.info(String.valueOf(objecttype.getIndex()));
		return objecttype.getIndex();
	}

	// FIXXME: mapped metadata using SMT
	private String descrMappedMetadata;

	public String getDescrMappedMetadata() {
		return descrMappedMetadata;
	}

	public void setDescrMappedMetadata(String descrMappedMetadata) {
		this.descrMappedMetadata = descrMappedMetadata;
	}

	// FIXXME: structure info is optional;
	// e.g. articles belonging to other DigitalObjects
	private String addedStructureInformation;

	public String getAddedStructureInformation() {
		return addedStructureInformation;
	}

	public void setAddedStructureInformation(String addedStructureInformation) {
		this.addedStructureInformation = addedStructureInformation;
	}

	private UUID informationPackageUUID;


	public UUID getInformationPackageUUID() {
		return informationPackageUUID;
	}

	public void setInformationPackageUUID(UUID informationPackageUUID) {
		this.informationPackageUUID = informationPackageUUID;
	}

	/**
	 * Calculate SHA-1 hash value for submitted file
	 * 
	 * @param fileObj
	 *            Submitted File.
	 * @throws IOException
	 * @throws NoSuchAlgorithmException
	 */
	public void calculateHash(File fileObj) throws IOException,
			NoSuchAlgorithmException {

		byte[] digest = Files.getDigest(fileObj,
				MessageDigest.getInstance("SHA"));

		this.setDigestValueinHex(new String(Hex.encodeHex(digest)));

	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		// TODO use getClass() to build toString()
		return "submitted file: " + getSubmittedFile() + "\n"
				+ "external identifier: " + getExternalIdentifier() + "\n"
				+ "secure hash: " + getDigestValueinHex() + "\n"
				+ "virusscan: " + getVirusscanResult() + "\n"
				+ "technical metadata: " + getTechMetadata().substring(0, 200)
				+ "\n" + "descriptive metadata: " + getDescrMappedMetadata()
				+ "\n";
	}

}
