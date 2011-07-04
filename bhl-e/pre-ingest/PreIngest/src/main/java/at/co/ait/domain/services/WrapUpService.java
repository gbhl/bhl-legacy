package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.apache.commons.io.FileUtils;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.ConfigUtils;

public class WrapUpService {

	public InformationPackageObject wrapup(InformationPackageObject obj,
			String workdir) throws IOException {
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getSubmittedFile().isFile()) {
//				FileUtils.copyFile(digobj.getSubmittedFile(), new File(
//						destfolder + digobj.getSubmittedFile().getName()));

			}
		}
		return obj;
	}
}