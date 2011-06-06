package at.co.ait.domain.services;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.Configuration;

public class VirusscanService extends ProcessbuilderService {
	
	List<String> commands;
	
	private static final Logger logger = LoggerFactory
			.getLogger(VirusscanService.class);
		
	public InformationPackageObject scan(InformationPackageObject pkg) throws IOException, InterruptedException {
		logger.debug("creating virusscan command");
		commands = new ArrayList<String>();
		commands.add((new java.net.URL(Configuration.getString("VirusscanService.0"))).getPath()); //$NON-NLS-1$
		commands.add(Configuration.getString("VirusscanService.1")); //$NON-NLS-1$		
		commands.add(pkg.getSubmittedFile().getAbsolutePath());	
		process(commands);	
		pkg.setScanlog(stdout.toString());		
		return pkg;
	}

}