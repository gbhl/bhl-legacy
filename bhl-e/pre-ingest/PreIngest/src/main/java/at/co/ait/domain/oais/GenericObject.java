package at.co.ait.domain.oais;

import java.io.File;
import java.util.UUID;

public class GenericObject implements IGenericObject {
	
	public GenericObject() {
		this.setId(UUID.randomUUID());
	}

	/**
	 * A unique identifier.
	 */
	private UUID id;
	
	/* (non-Javadoc)
	 * @see at.co.ait.domain.oais.IGenericObject#getId()
	 */
	public UUID getId() {
		return id;
	}

	/* (non-Javadoc)
	 * @see at.co.ait.domain.oais.IGenericObject#setId(java.util.UUID)
	 */
	public void setId(UUID id) {
		this.id = id;
	}
	
	/**
	 * A submitted file.
	 */
	private File submittedFile;

	/* (non-Javadoc)
	 * @see at.co.ait.domain.oais.IGenericObject#getSubmittedFile(java.io.File)
	 */
	public File getSubmittedFile() {
		return submittedFile;
	}

	/* (non-Javadoc)
	 * @see at.co.ait.domain.oais.IGenericObject#setSubmittedFile(java.io.File)
	 */
	public void setSubmittedFile(File submittedFile) {
		this.submittedFile = submittedFile;
	}
}
