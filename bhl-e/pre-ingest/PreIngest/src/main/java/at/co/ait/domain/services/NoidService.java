package at.co.ait.domain.services;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.annotation.Resource;

import at.co.ait.domain.integration.IReqNoidGateway;
import at.co.ait.domain.oais.InformationPackageObject;

public class NoidService {
	
	@Resource(name = "noidRequestGateway")
	public void setNoidGateway(IReqNoidGateway noidGateway) {
		this.noidGateway = noidGateway;
	}

	private IReqNoidGateway noidGateway;

	public InformationPackageObject enrich(InformationPackageObject pkg)
			throws InterruptedException, ExecutionException, TimeoutException {
		// request new NOID mint from PlNoidStomp
		String identifier = null;
		identifier = noidGateway.requestNoid("mint").get(10, TimeUnit.SECONDS);
		pkg.setIdentifier(identifier);
		return pkg;
	}

}