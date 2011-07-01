package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.apache.commons.io.FileUtils;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;

public class WrapUpService {

	public InformationPackageObject wrapup(InformationPackageObject obj,
			String workdir) throws IOException {
		String destfolder = "C:/ProjectData/BHL-Tests/archive/"
				+ obj.getIdentifier() + "/";
		synchronized (obj.getDigitalobjects()) {
			for (DigitalObject digobj : obj.getDigitalobjects()) {
				if (digobj.getSubmittedFile().isFile()) {
					FileUtils.copyFile(digobj.getSubmittedFile(), new File(
							destfolder + digobj.getSubmittedFile().getName()));
					File metsfname = new File(destfolder + "mets.xml");
					obj.getMets().write(FileUtils.openOutputStream(metsfname));
				}
			}
		}
		return obj;
	}
}