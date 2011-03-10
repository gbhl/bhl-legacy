package at.co.ait.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import at.co.ait.domain.DirectoryListing;
import at.co.ait.domain.PackageDeliveryService;
import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping(value="/filebrowser/*")
public class FileBrowser {

	private static final Logger logger = LoggerFactory.getLogger(FileBrowser.class);
	private DirectoryListing myFiles;

	@RequestMapping(value="index", method=RequestMethod.GET)
	@ModelAttribute("fileList")
	public List<String> getMyFiles() {
		Collection<File> files = this.myFiles.getFiles();
		List<String> filelist = new ArrayList<String>();
		for (File file : files) {
			
			filelist.add(file.toString());
		}
		return filelist;
	}
	
	@RequestMapping(value="status/infopackageobjects", method=RequestMethod.GET, headers="Accept=application/json")
	public @ResponseBody List<String> getInfoPackageObjectsStatus() {
		List<String> reply = new ArrayList<String>();
		for (Iterator<InformationPackageObject> it=service.getPackageInfo().iterator(); it.hasNext(); ) {
			reply.add(it.next().toString());
		}
		return reply;
	}
	
	@RequestMapping(value="status/digitalobjects", method=RequestMethod.GET, headers="Accept=application/json")
	public @ResponseBody List<String> getDigitalObjectsStatus() {
		List<String> reply = new ArrayList<String>();
		for (Iterator<InformationPackageObject> it=service.getPackageInfo().iterator(); it.hasNext(); ) {
			InformationPackageObject tempinfpkg = it.next();
			for (Iterator<DigitalObject> digobj=tempinfpkg.getDigitalobjects().iterator(); digobj.hasNext(); ) {				
				reply.add(digobj.next().toString());
			}
		}
		return reply;
	}
	
	@RequestMapping(value="ajaxTree", method=RequestMethod.GET, headers="Accept=application/json")
	public @ResponseBody List<Map<String,Object>> getAjaxTree() {
		return this.myFiles.buildJSONMsgFromDir(null);
	}
	
	@RequestMapping(value="sendData", method=RequestMethod.GET, headers="Accept=application/json")
	public @ResponseBody List<Map<String,Object>> getLazyNode(@RequestParam String key) {
		return this.myFiles.buildJSONMsgFromDir(key);
	}
	
	@RequestMapping(value="submitNodes", method=RequestMethod.POST)
	public @ResponseBody String submitNodes(@RequestParam(value="selNodes", required=false) String nodes) {
		logger.info(nodes);
		return "submitted";
	}
	
	private PackageDeliveryService service;
	@Resource(name="PackageDeliveryService")
	public void setService(PackageDeliveryService service) {
		this.service = service;
	}

	@RequestMapping(value="sendNodes", method=RequestMethod.POST)
	public @ResponseBody String sendNodes(@RequestParam(value="selNodes", required=true) List<String> keys) {
		for (String key : keys) {
			service.preparePackage(this.myFiles.getFileByKey(Integer.valueOf(key)));			
		}
		return "done";
	}

	@Resource(name="SIPFiles2")
	public void setMyFiles(DirectoryListing myFiles) {
		this.myFiles = myFiles;
	}
	
	
}

