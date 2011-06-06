package at.co.ait.domain.services;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;

public class LabellingService {
	
	public InformationPackageObject enrich (InformationPackageObject pkg) {		
		DigitalObject idol = pkg.getDigitalobjects().get(0);		
		pkg.setPrefs(idol.getPrefs());
		pkg.setSubmittedFile(idol.getSubmittedFile().getParentFile());
		return pkg;
	}
	
}
