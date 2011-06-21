package at.co.ait.domain.oais;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.web.FileBrowser;

public class TrackingObject {	
	private Map<String,List<List<String>>> queues = new HashMap<String,List<List<String>>>();
	private static final Logger logger = LoggerFactory.getLogger(TrackingObject.class);
	
	public Map<String, List<List<String>>> getQueues() {
		return queues;
	}
	
	public List<List<String>> getQueue(String channel) {
		logger.debug(channel);
		return queues.get(channel);
	}

	public void store(List<String> line, String lastchannel) {
		logger.debug(line.toString());
		if (!queues.containsKey(lastchannel)) {
			queues.put(lastchannel, new ArrayList<List<String>>());						
		}		
		queues.get(lastchannel).add(line);
		logger.debug(queues.toString());
	}
}
