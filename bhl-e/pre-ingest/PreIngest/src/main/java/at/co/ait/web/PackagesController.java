package at.co.ait.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import at.co.ait.domain.integration.ArchivingQueue;
import at.co.ait.domain.integration.ProcessingQueue;
import at.co.ait.domain.oais.LogGenericObject;

@Controller
@RequestMapping(value="/packages/*")
public class PackagesController {	
	
	private static final Logger logger = LoggerFactory.getLogger(PackagesController.class);	
	private @Autowired LogGenericObject loggenericobject;
	private @Autowired ProcessingQueue packagequeue;
	private @Autowired ArchivingQueue archivingqueue;
	
	@RequestMapping(value="monitor")
	public void monitorHandler() {
	}
    
	@RequestMapping(value="monitor/json", method=RequestMethod.GET, headers="Accept=application/json")
	public @ResponseBody Map<String,Object> getObserver(@RequestParam String show) {
		Map<String,Object> map = new HashMap<String,Object>();
		List<?> list = new ArrayList(loggenericobject.getBag());
		Collections.reverse(list);
		map.put("Result",list);
		return map;
	}
	
	@RequestMapping(value="queue")
	public void queueHandler() {
	}
	
	@RequestMapping(value="queue/json", method=RequestMethod.GET, headers="Accept=application/json")
	public @ResponseBody Map<String,Object> getQueue(@RequestParam String show) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("Result",packagequeue.getQueue());
		return map;
	}
	
	@RequestMapping(value="/archivingqueue")
	@ModelAttribute(value="ArchivingQueue")
	public ArchivingQueue archivingqueueHandler() {
		return archivingqueue;
	}
	
	@RequestMapping(value="/archivingqueue/retrieve")
	public @ResponseBody
	String archivingqueueRetrieveHandler() throws JsonMappingException, JsonGenerationException, IOException {
		return archivingqueue.toJson(true);
	}
	
	@RequestMapping(value="/archivingqueue/reset")
	public @ResponseBody String archivingqueueResetHandler() {
		archivingqueue.clear();
		return "ACK";
	}
}