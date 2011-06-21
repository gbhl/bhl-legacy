package at.co.ait.domain.services;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.domain.oais.TrackingObject;
import at.co.ait.utils.DateUtils;

public class ObjectTrackingService {
	
	private @Autowired TrackingObject trackingobject;
	
	private static final Logger logger = LoggerFactory.getLogger(ObjectTrackingService.class);
	
	public void log(Object payload, Map<String, Object> headers, String username) {
		List<String> line = new ArrayList<String>();
		line.add(DateUtils.toDate((Long) headers.get("timestamp")));
		if (payload instanceof DigitalObject) {
			line.add(((DigitalObject) payload).getSubmittedFile().getPath());
			line.add(((DigitalObject) payload).getId().toString());	
		};
		if (payload instanceof InformationPackageObject) {
			line.add(((InformationPackageObject) payload).getSubmittedFile().getName());
			line.add(((InformationPackageObject) payload).getId().toString());	
		};
		if (payload instanceof File) {
			line.add(((File) payload).getPath());
		};		
		line.add(username);	
		line.add(headers.get("history").toString());		
		String[] channels = headers.get("history").toString().split(",");	
		trackingobject.store(line,channels[channels.length-2]);
	}

}