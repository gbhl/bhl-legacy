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
		String tmpfile = ConfigUtils.getTmpFileName(pkg.getSubmittedFile(),".scan.log");
		File output = new File(tmpfile);
		FileUtils.writeStringToFile(output, stdout.toString(), "UTF-8");
		pkg.setScanlog(output);		
		return pkg;
	}

}