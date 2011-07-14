package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.net.URLEncoder;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import at.co.ait.domain.integration.ITaxonFinderGateway;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.utils.ConfigUtils;

public class TaxonFinderService {

	private @Autowired
	ITaxonFinderGateway taxonfinderGateway;

	public DigitalObject enrich(DigitalObject obj) throws InterruptedException,
			ExecutionException, TimeoutException, IOException,
			ParserConfigurationException, SAXException,
			XPathExpressionException {
		String taxa = null;
		String text = FileUtils.readFileToString(obj.getOcr());
		taxa = taxonfinderGateway.requestTaxa(URLEncoder.encode(text, "UTF-8"))
				.get(2, TimeUnit.SECONDS);		
		Object o = XPathFactory
				.newInstance()
				.newXPath()
				.evaluate("/child::*/child::*",
						new InputSource(new StringReader(taxa)),
						XPathConstants.NODESET);
		NodeList nodes = (NodeList) o;
		System.out.println(nodes.getLength() + " "
				+ nodes.item(nodes.getLength() - 1));
		
		// if ANY names are in the taxon finder's reply
		if (nodes.getLength()>0) {			
			String tmpfile = ConfigUtils.getTmpFileName(obj.getSubmittedFile(),
			".taxa");			
			File output = new File(tmpfile);
			if (!output.exists()) {
				FileUtils.writeStringToFile(output, taxa, "UTF-8");
			}
			obj.setTaxa(output);
		}
		return obj;
	}

}