package at.co.ait.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import at.co.ait.domain.services.ConvertImageService;
import at.co.ait.domain.services.DirectoryListingService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class SubmittedFilesController {

	private static final Logger logger = LoggerFactory.getLogger(SubmittedFilesController.class);
	
	private @Inject DirectoryListingService directorylist;
	private ConvertImageService myTransformer;

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value="/submittedfiles/",method=RequestMethod.GET)
	@ModelAttribute("fileList")
	public List<String> populateFileList() {
		// convert collection of files into list of strings appropriate for JSP view
//		Collection<File> files = this.directorylist.getFiles();
//		List<String> filelist = new ArrayList<String>();
//		for (File file : files) {
//			filelist.add(file.toString());
//		}
		return null;
	}
	

}

