package at.co.ait.web;

import java.io.IOException;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import at.co.ait.domain.integration.ArchivingQueue;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MainController {
	
	private @Autowired ArchivingQueue archivingqueue;

	private static final Logger logger = LoggerFactory.getLogger(MainController.class);

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String home() {
		logger.info("Welcome home!");
		return "home";
	}
	
	@RequestMapping(value="/guidelines")
	public void guidelinesHandler() {
	}
	
	@RequestMapping(value="/archivingqueue")
	@ModelAttribute(value="ArchivingQueue")
	public @ResponseBody String archivingqueueHandler() {
		return "Archivingqueue shows are AIP which are ready for ingest.";
	}
	
	@RequestMapping(value="/archivingqueue/retrieve")
	public @ResponseBody String archivingqueueRetrieveHandler() throws JsonMappingException, JsonGenerationException, IOException {
		return archivingqueue.toJson(true);
	}
	
	@RequestMapping(value="/archivingqueue/reset")
	public @ResponseBody String archivingqueueResetHandler() {
		archivingqueue.clear();
		return "ACK";
	}
	
}

