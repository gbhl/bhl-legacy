package at.co.ait.domain.integration;

import at.co.ait.domain.oais.DigitalObject;

public class HiddenFolderFilter {
	
	public boolean filter(DigitalObject obj) {
		boolean select;
		if (obj.getSubmittedFile().getName().startsWith(".")) {
			select = Boolean.FALSE;
		} 
		else
		{
			select = Boolean.TRUE;
		}
		return select;		
	}

}
