package at.co.ait.domain.oais;

import java.io.File;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Observable;
import java.util.UUID;

import org.apache.commons.codec.binary.Hex;

import at.co.ait.web.common.UserPreferences;

import com.google.common.io.Files;

public class GenericObject extends Observable {

	public GenericObject() {
		this.setId(UUID.randomUUID());	
	}

	/**
	 * A unique identifier.
	 */
	private UUID id;

	/*
	 * (non-Javadoc)
	 * 
	 * @see at.co.ait.domain.oais.IGenericObject#getId()
	 */
	public UUID getId() {
		return id;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see at.co.ait.domain.oais.IGenericObject#setId(java.util.UUID)
	 */
	public void setId(UUID id) {
		this.id = id;
	}

	/**
	 * A submitted file.
	 */
	private File submittedFile;

	/*
	 * (non-Javadoc)
	 * 
	 * @see at.co.ait.domain.oais.IGenericObject#getSubmittedFile(java.io.File)
	 */
	public File getSubmittedFile() {
		return submittedFile;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see at.co.ait.domain.oais.IGenericObject#setSubmittedFile(java.io.File)
	 */
	public void setSubmittedFile(File submittedFile) {
		this.submittedFile = submittedFile;
		if (!submittedFile.isDirectory()) {
			// calculate Hash Value
			try {
				digestValueinHex = calculateHash(submittedFile);
			} catch (NoSuchAlgorithmException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		setChanged();
		notifyObservers("SUBMITTED: " + getSubmittedFile().getName());
	}

	/**
	 * Secure hash (SHA-1) of the submitted file.
	 */
	private String digestValueinHex;

	public String getDigestValueinHex() {
		return digestValueinHex;
	}

	/**
	 * Calculate SHA-1 hash value for submitted file
	 * 
	 * @param fileObj
	 *            Submitted File.
	 * @throws IOException
	 * @throws NoSuchAlgorithmException
	 */
	private static final String calculateHash(File fileObj) throws IOException,
			NoSuchAlgorithmException {

		byte[] digest = Files.getDigest(fileObj,
				MessageDigest.getInstance("SHA-1"));

		return (new String(Hex.encodeHex(digest)));

	}

	/**
	 * Contains any user-defined and/or user-specific information used for
	 * preservation.
	 */
	private UserPreferences prefs;

	public UserPreferences getPrefs() {
		return prefs;
	}

	public void setPrefs(UserPreferences prefs) {
		this.prefs = prefs;
	}
	
	/**
	 * Contains reference to this file as URL.
	 */
	private String fileurl;
	
	public void setFileurl(String fileurl) {
		this.fileurl = fileurl;
	}

	public String getFileurl() {
		return fileurl;
	}
	
	
	public void dispose() {
		setChanged();
		notifyObservers("DISPOSED: " + getSubmittedFile().getName());
		deleteObservers();		
	}
	
}
