package at.co.ait.domain.services;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import org.springframework.beans.factory.annotation.Autowired;

import at.co.ait.domain.integration.ITaxonFinderGateway;
import at.co.ait.domain.oais.DigitalObject;

public class TaxonFinderService {

	private @Autowired
	ITaxonFinderGateway taxonfinderGateway;

	public DigitalObject enrich(DigitalObject obj) throws InterruptedException,
			ExecutionException, TimeoutException, UnsupportedEncodingException {
		String taxa = null;	
		taxa = taxonfinderGateway.requestTaxa(URLEncoder.encode(obj.getOcr(),"UTF-8"))
				.get(1, TimeUnit.SECONDS);
		obj.setTaxa(taxa);
		return obj;
	}

}