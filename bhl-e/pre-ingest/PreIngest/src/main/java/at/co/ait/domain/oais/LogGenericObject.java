package at.co.ait.domain.oais;

import java.io.File;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Observable;
import java.util.Observer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LogGenericObject implements Observer {

	private static final Logger logger = LoggerFactory
			.getLogger(LogGenericObject.class);

	private Map<String, List<String>> bag = new LinkedHashMap<String, List<String>>();

	public Map<String, List<String>> getBag() {
		return bag;
	}

	public void update(Observable o, Object arg) {

		List<String> info = new ArrayList<String>();
		String user = null;
		String filename = null;
		String parentkey = null;
		int key = 0;

		if (o instanceof DigitalObject) {
			user = ((DigitalObject) o).getPrefs().getUsername();
			key = ((DigitalObject) o).getSubmittedFile().hashCode();
			filename = ((DigitalObject) o).getSubmittedFile().getName();
			parentkey = String.valueOf(((DigitalObject) o).getSubmittedFile().getParentFile().hashCode());
		}
		if (o instanceof InformationPackageObject) {
			user = ((InformationPackageObject) o).getPrefs().getUsername();
			key = ((InformationPackageObject) o).getSubmittedFile().hashCode();
			filename = ((InformationPackageObject) o).getSubmittedFile()
					.getName();
			parentkey = String.valueOf(((InformationPackageObject) o).getSubmittedFile().getParentFile().hashCode());
		}

		if (bag.containsKey(String.valueOf(key))) {
			info = bag.get(String.valueOf(key));
			info.add(arg.toString());
		} else {
			info.add(filename);
			info.add(user);
			info.add(arg.toString());
		}

		if (arg.toString().equals("disposed")) {
			bag.remove(String.valueOf(key));
		} else {
			bag.put(String.valueOf(key), info);
		}
	}
}