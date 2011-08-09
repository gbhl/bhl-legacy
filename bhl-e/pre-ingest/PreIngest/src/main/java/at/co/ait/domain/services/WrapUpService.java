package at.co.ait.domain.services;

import java.util.LinkedHashMap;

import org.springframework.beans.factory.annotation.Autowired;

import at.co.ait.domain.integration.ArchivingQueue;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.DateUtils;

public class WrapUpService {

	private @Autowired ArchivingQueue archivingqueue;

	public InformationPackageObject wrapup(InformationPackageObject obj) {

		// store aip information in queue for further archive
		// can be retrieved by 3rd party
		String path = obj.getSubmittedFile().getAbsolutePath();
		LinkedHashMap<String, String> line = new LinkedHashMap<String, String>();
		line.put("date", DateUtils.now());
		line.put("path", path);
		line.put("user", obj.getPrefs().getUsername());
		line.put("metsfile", obj.getMetsfileurl());
		archivingqueue.add(line);

		// clean up & remove all observers by disposing
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			digobj.dispose();
		}
		obj.dispose();
		return obj;
	}
}