package at.co.ait.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import at.co.ait.domain.integration.ProcessingQueue;
import at.co.ait.domain.oais.LogGenericObject;

@Controller
@RequestMapping(value="/packages/*")
public class PackagesController {	
	
	private static final Logger logger = LoggerFactory.getLogger(PackagesController.class);	
	private @Autowired LogGenericObject loggenericobject;
	private @Autowired ProcessingQueue packagequeue;
    
	@RequestMapping(value="all", method=RequestMethod.GET)
	@ModelAttribute("packageMap")
	public Map<String,List<String>> getChannels() {
		return loggenericobject.getBag();
	}
	
	@RequestMapping(value="queue", method=RequestMethod.GET)
	@ModelAttribute("packagequeue")
	public List<Map<String,String>> getPackagequeue() {
		return packagequeue.getQueue();
	}
	
	@RequestMapping(value="queue/json", method=RequestMethod.GET, headers="Accept=application/json")
	public @ResponseBody List<Map<String,String>> getPackagequeue1() {
		return packagequeue.getQueue();
	}
}