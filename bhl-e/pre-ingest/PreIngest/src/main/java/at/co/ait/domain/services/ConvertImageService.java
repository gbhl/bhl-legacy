package at.co.ait.domain.services;

import java.io.File;

import org.im4java.core.ConvertCmd;
import org.im4java.core.IMOperation;

import at.co.ait.domain.oais.DigitalObject;

public class ConvertImageService {
	private DigitalObject digitalobject;
	private String imPath="C:\\Utilities\\ImageMagick-6.6.7-Q16";
	private File inputimage;
	private File outputimage;
	
	public void transform() throws Exception {

		IMOperation op = new IMOperation();
		op.addImage(); //place holder for input file
		op.resize(800,600);
		op.addImage(); //place holder for output file
		
		ConvertCmd convert = new ConvertCmd();
		convert.setSearchPath(imPath);
		convert.run(op, 
				new Object[]{
				inputimage.getAbsolutePath(),
				outputimage.getAbsolutePath()});
	}
	
	public DigitalObject convert(DigitalObject digObj) {
		return digObj;
	}
	
	public DigitalObject getDigitalobject() {
		return digitalobject;
	}

	public void setDigitalobject(DigitalObject digitalobject) {
		this.inputimage = digitalobject.getSubmittedFile();
		this.digitalobject = digitalobject;
	}
	
	public File getOutputimage() {
		return outputimage;
	}

	public void setOutputimage(File outputimage) {
		this.outputimage = outputimage;
	}
	
	public void setOutputimage(String outputimagepath) {
		this.outputimage = new File(outputimagepath);
	}
	
}
