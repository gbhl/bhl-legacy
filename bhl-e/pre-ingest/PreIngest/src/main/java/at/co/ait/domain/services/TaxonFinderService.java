package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import at.co.ait.domain.integration.ITaxonFinderGateway;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.web.FileBrowser;

public class TaxonFinderService {

	private @Autowired
	ITaxonFinderGateway taxonfinderGateway;
	private static final Logger logger = LoggerFactory
	.getLogger(TaxonFinderService.class);

	public DigitalObject enrich(DigitalObject obj) {
		if (obj.getOcr() != null) {
			String taxa = null;
			String text = null;
			
			// read OCR from file
			try {
				text = FileUtils.readFileToString(obj.getOcr());
			} catch (IOException e) {
				logger.error("Couldn't read OCR file.");
			}
			
			// URL encode OCR text
			String enc = null;
			try {
				enc = URLEncoder.encode(text, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				logger.error("Couldn't find UTF-8 encoding to encode taxa string.");
			}
			
			// send URL encoded OCR text to Taxon Finder gateway
			try {
				taxa = taxonfinderGateway.requestTaxa(enc).get(10, TimeUnit.SECONDS);
			} catch (InterruptedException e) {
				logger.error("Taxonfinder gateway call was interrupted.");
			} catch (ExecutionException e) {
				logger.error("Taxonfinder gateway call wasn't executed properly.");
			} catch (TimeoutException e) {
				logger.error("Taxonfinder gateway call has timed out (max. 10 sec).");
			}
			
			// Taxonfinder reply is XML formatted, check here if it has content 
			Object o = null;
			try {
				o = XPathFactory
						.newInstance()
						.newXPath()
						.evaluate("/child::*/child::*",
								new InputSource(new StringReader(taxa)),
								XPathConstants.NODESET);
			} catch (XPathExpressionException e) {
				logger.error("Couldn't apply XPath Expression to Taxonfinder's reply.");
			}
			
			NodeList nodes = (NodeList) o;
			// if ANY names are in the taxon finder's reply, save it to file
			if (nodes.getLength() > 0) {
				String tmpfile = ConfigUtils.getTmpFileName(
						obj.getSubmittedFile(), ".taxa.txt");
				File output = new File(tmpfile);
				if (!output.exists()) {
					
					try {
						FileUtils.writeStringToFile(output, taxa, "UTF-8");
					} catch (IOException e) {
						logger.error("Couldn't write Taxa file.");
					}
				}
				obj.setTaxa(output);
			}
		}
		return obj;
	}

}