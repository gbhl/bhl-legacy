/**
 * PreIngest - Metadata preparation tool before archival ingest.
 * Copyright (C) 2011 AIT Forschungsgesellschaft mbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, 
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice, 
 * this list of conditions and the following disclaimer in the documentation 
 * and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF 
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */
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
		String identifier = null;
		
		File out = ConfigUtils.getAipFile(pkg.getPrefs().getBasedirectoryFile(),
				pkg.getSubmittedFile(),".guid.txt");
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