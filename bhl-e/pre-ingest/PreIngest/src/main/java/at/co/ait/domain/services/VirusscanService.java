package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.utils.Configuration;

public class VirusscanService extends ProcessbuilderService {
	
	private static final Logger logger = LoggerFactory
	.getLogger(VirusscanService.class);
	
	List<String> commands;
		
	public InformationPackageObject scan(InformationPackageObject pkg) throws IOException, InterruptedException {
		commands = new ArrayList<String>();
		commands.add((new java.net.URL(Configuration.getString("VirusscanService.0"))).getPath()); //$NON-NLS-1$	
		commands.add(pkg.getSubmittedFile().getAbsolutePath());		
		File output = ConfigUtils.getAipFile(pkg.getPrefs().getBasedirectoryFile(),
				pkg.getSubmittedFile(),".scan.log.txt");
		if (!output.exists()) {
			logger.debug("starting scan on " + pkg.getSubmittedFile().getName());
			process(commands);
			FileUtils.writeStringToFile(output, stdout.toString(), "UTF-8");
			logger.debug("SMT: " + output.getName() + "STDERR: " + stderr.toString());
		}
		pkg.setScanlog(output);		
		return pkg;
	}

}