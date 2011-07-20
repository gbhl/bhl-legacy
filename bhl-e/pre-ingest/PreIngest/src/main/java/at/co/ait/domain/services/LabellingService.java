package at.co.ait.domain.services;

import java.io.IOException;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.ConfigUtils;

public class LabellingService {
	
	public InformationPackageObject enrich(InformationPackageObject pkg, String basedir) throws IOException {		
		DigitalObject idol = pkg.getDigitalobjects().get(0);		
		pkg.setPrefs(idol.getPrefs());
		pkg.setSubmittedFile(idol.getSubmittedFile().getParentFile());
		pkg.setFileurl(ConfigUtils.createFileURL(idol.getSubmittedFile().getParentFile(), basedir));
		return pkg;
	}
	
}
