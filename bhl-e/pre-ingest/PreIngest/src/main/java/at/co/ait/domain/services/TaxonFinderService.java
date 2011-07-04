package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;

import at.co.ait.domain.integration.ITaxonFinderGateway;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.utils.ConfigUtils;

public class TaxonFinderService {

	private @Autowired
	ITaxonFinderGateway taxonfinderGateway;

	public DigitalObject enrich(DigitalObject obj) throws InterruptedException,
			ExecutionException, TimeoutException, IOException {
		String taxa = null;
		String text = FileUtils.readFileToString(obj.getOcr());
		taxa = taxonfinderGateway.requestTaxa(URLEncoder.encode(text,"UTF-8"))
				.get(2, TimeUnit.SECONDS);
		String tmpfile = ConfigUtils.getTmpFileName(obj.getSubmittedFile(),".taxa");
		File output = new File(tmpfile);
		FileUtils.writeStringToFile(output, taxa, "UTF-8");
		obj.setTaxa(output);
		return obj;
	}

}