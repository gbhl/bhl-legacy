package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.FileFilterUtils;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;

public class WrapUpService {

	public InformationPackageObject wrapup(InformationPackageObject obj,
			String workdir) throws IOException {
		String aip_dir = workdir + "/" + obj.getIdentifier().split("/")[1];
		File destfolder = FileUtils.toFile(new URL(aip_dir));
		FileUtils.copyDirectory(obj.getSubmittedFile(), destfolder,
				FileFilterUtils.fileFileFilter());
		File tmp_aip = new File(obj.getSubmittedFile().getAbsolutePath() + File.separator + ".aip");
		FileUtils.copyDirectory(tmp_aip, destfolder);
		FileUtils.deleteDirectory(tmp_aip);
		return obj;
	}
}