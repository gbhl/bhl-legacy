package at.co.ait.domain.oais;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Observable;
import java.util.Observer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.utils.DateUtils;

public class LogGenericObject implements Observer {

	private static final Logger logger = LoggerFactory
			.getLogger(LogGenericObject.class);

	private List<Map<String, String>> bag = new ArrayList<Map<String, String>>();

	public List<Map<String, String>> getBag() {
		return bag;
	}

	public void update(Observable o, Object arg) {

		Map<String, String> info = null;		
		final int MAX = 100;
		String user = null;
		String filename = null;
		String parentfoldername = null;

		int hashcode = 0;

		if (o instanceof DigitalObject) {
			user = ((DigitalObject) o).getPrefs().getUsername();
			hashcode = ((DigitalObject) o).getSubmittedFile().hashCode();
			filename = ((DigitalObject) o).getSubmittedFile().getName();
			parentfoldername = ((DigitalObject) o).getSubmittedFile()
					.getParentFile().getName();
		}
		if (o instanceof InformationPackageObject) {
			user = ((InformationPackageObject) o).getPrefs().getUsername();
			hashcode = ((InformationPackageObject) o).getSubmittedFile()
					.hashCode();
			filename = ((InformationPackageObject) o).getSubmittedFile()
					.getName();
			parentfoldername = ((InformationPackageObject) o)
					.getSubmittedFile().getParentFile().getName();
		}

		info = new HashMap<String, String>();
		info.put("timestamp", new Date().toString());
		info.put("displaydate",DateUtils.now());
		info.put("parentfolder", parentfoldername);
		info.put("filename", filename);
		info.put("hashcode", String.valueOf(hashcode));
		info.put("username", user);
		info.put("observation", arg.toString());
		bag.add(info);
		
		if (bag.size() > MAX) {
			// delete first entry to keep size at MAX
			bag.remove(0);
		}		
	}

}