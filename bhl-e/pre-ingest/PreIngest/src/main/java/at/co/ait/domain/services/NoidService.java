package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.domain.integration.IReqNoidGateway;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.utils.Configuration;

public class NoidService {
	
	private static final Logger logger = LoggerFactory
	.getLogger(NoidService.class);
	
	@Resource(name = "noidRequestGateway")
	public void setNoidGateway(IReqNoidGateway noidGateway) {
		this.noidGateway = noidGateway;
	}

	private IReqNoidGateway noidGateway;

	public InformationPackageObject enrich(InformationPackageObject pkg)
			throws InterruptedException, ExecutionException, TimeoutException, IOException {
		String tmpfile = ConfigUtils.getTmpFileName(pkg.getSubmittedFile(),".guid.txt");
		String identifier = null;
		
		File out = new File(tmpfile);
		if (out.exists()) {
			logger.debug("reading identifier from file");
			identifier = FileUtils.readFileToString(out);
		} else {
			logger.debug("requesting identifer from noid minting service");
			// request new NOID mint from PlNoidStomp			
			identifier = noidGateway.requestNoid("mint").get(10, TimeUnit.SECONDS);
			FileUtils.writeStringToFile(out, identifier);			
		}
		
		pkg.setIdentifier(identifier);
		return pkg;
	}

}