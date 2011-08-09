package at.co.ait.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import at.co.ait.domain.integration.ProcessingQueue;
import at.co.ait.domain.oais.LogGenericObject;

@Controller
@RequestMapping(value="/packages/*")
public class PackagesController {	
	
	//unused: private static final Logger logger = LoggerFactory.getLogger(PackagesController.class);	
	private @Autowired LogGenericObject loggenericobject;
	private @Autowired ProcessingQueue packagequeue;
	
	@RequestMapping(value="monitor")
	public void monitorHandler() {
	}
    
	@RequestMapping(value="monitor/json", method=RequestMethod.GET, headers="Accept=application/json")
	public @ResponseBody Map<String,List<Map<String,String>>> getObserver(
			@RequestParam String show) {
		Map<String,List<Map<String,String>>> map = 
			new HashMap<String,List<Map<String,String>>>();
		List<Map<String,String>> list = new ArrayList<Map<String,String>>(loggenericobject.getBag());
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

}