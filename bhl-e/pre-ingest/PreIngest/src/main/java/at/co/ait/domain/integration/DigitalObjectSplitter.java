package at.co.ait.domain.integration;

import java.util.ArrayList;
import java.util.List;

import at.co.ait.domain.oais.DigitalObject;

public class DigitalObjectSplitter {
	
	public List<DigitalObject> split(List<DigitalObject> objlist) {
		// remove hidden folder from list since they must not be processed
		List<DigitalObject> newList = new ArrayList<DigitalObject>();
		for (DigitalObject obj : objlist) {
			if (!obj.getSubmittedFile().getName().startsWith(".")) newList.add(obj);
		}
		return newList;		
	}

}
