package at.co.ait.domain.oais;

import java.io.File;
import java.util.UUID;

public interface IGenericObject {

	public UUID getId();

	public void setId(UUID id);
	
	public File getSubmittedFile();
	
	public void setSubmittedFile(File submittedFile);

}