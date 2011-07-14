package at.co.ait.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import at.co.ait.domain.integration.ILoadingGateway;
import at.co.ait.domain.oais.LogGenericObject;
import at.co.ait.domain.services.DirectoryListingService;
import at.co.ait.web.common.UserPreferences;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping(value = "/filebrowser/*")
public class FileBrowser {

	private static final Logger logger = LoggerFactory
			.getLogger(FileBrowser.class);
	private @Autowired DirectoryListingService directorylist;
	private @Autowired ILoadingGateway loading;

	@RequestMapping(value = "index", method = RequestMethod.GET)
	@ModelAttribute("fileList")
	public List<String> getMyFiles() {
		return null;
	}

	@RequestMapping(value = "ajaxTree", method = RequestMethod.GET, headers = "Accept=application/json")
	public @ResponseBody List<Map<String, Object>> getAjaxTree() {
		return directorylist.buildJSONMsgFromDir(null);
	}

	@RequestMapping(value = "sendData", method = RequestMethod.GET, headers = "Accept=application/json")
	public @ResponseBody List<Map<String, Object>> getLazyNode(@RequestParam String key) {
		return directorylist.buildJSONMsgFromDir(key);
	}

	@RequestMapping(value = "submitNodes", method = RequestMethod.POST)
	public @ResponseBody String submitNodes(
			@RequestParam(value = "selNodes", required = false) String nodes) {
		logger.info(nodes);
		return "submitted";
	}

	@RequestMapping(value = "sendNodes", method = RequestMethod.POST)
	public @ResponseBody String sendNodes(
			@RequestParam(value = "selNodes", required = true) List<String> keys,
			@RequestParam(value = "lang", required = false) String language) {
		// create new map with optional user input to add to the message header
		HashMap<String, String> options = new HashMap<String,String>();
		options.put("lang", language);
		// aquire user preferences object to add to the message header
		UserPreferences prefs = (UserPreferences) SecurityContextHolder
		.getContext().getAuthentication().getPrincipal();
		// only folders are submitted, no files
		for (String key : keys) {
			loading.loadfolder(directorylist.getFileByKey(Integer.valueOf(key)), prefs, options);
		}
		return "done";
	}

}
