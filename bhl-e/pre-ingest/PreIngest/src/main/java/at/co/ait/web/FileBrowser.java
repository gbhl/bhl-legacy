package at.co.ait.web;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.swing.filechooser.FileFilter;
import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.io.filefilter.FileFilterUtils;
import org.jdom.xpath.XPath;
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
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import at.co.ait.domain.integration.ILoadingGateway;
import at.co.ait.domain.oais.LogGenericObject;
import at.co.ait.domain.services.DirectoryListingService;
import at.co.ait.utils.DOM;
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
	
	private HashMap<String, String> marcLang2TesseractLang;
	{
		//http://www.loc.gov/marc/languages/language_code.html#f
		marcLang2TesseractLang = new HashMap<String, String>();
		marcLang2TesseractLang.put("bul", "bul");
		marcLang2TesseractLang.put("", "cat");
		marcLang2TesseractLang.put("", "ces");
		marcLang2TesseractLang.put("dan", "dan");
		marcLang2TesseractLang.put("", "dan-frak");
		marcLang2TesseractLang.put("", "data");
		marcLang2TesseractLang.put("ger", "deu");
		marcLang2TesseractLang.put("", "deu-f");
		marcLang2TesseractLang.put("", "ell");
		marcLang2TesseractLang.put("eng", "eng");
		marcLang2TesseractLang.put("fin", "fin");
		marcLang2TesseractLang.put("fre", "fra");
		marcLang2TesseractLang.put("hun", "hun");
		marcLang2TesseractLang.put("", "ind");
		marcLang2TesseractLang.put("", "ita");
		marcLang2TesseractLang.put("", "lav");
		marcLang2TesseractLang.put("", "lit");
		marcLang2TesseractLang.put("", "nld");
		marcLang2TesseractLang.put("", "nor");
		marcLang2TesseractLang.put("", "pol");
		marcLang2TesseractLang.put("", "por");
		marcLang2TesseractLang.put("", "ron");
		marcLang2TesseractLang.put("", "rus");
		marcLang2TesseractLang.put("", "slk");
		marcLang2TesseractLang.put("", "slv");
		marcLang2TesseractLang.put("", "spa");
		marcLang2TesseractLang.put("", "srp");
		marcLang2TesseractLang.put("", "swe");
		marcLang2TesseractLang.put("", "tgl");
		marcLang2TesseractLang.put("", "tur");
		marcLang2TesseractLang.put("", "ukr");
		marcLang2TesseractLang.put("", "vie");

	}
	
	/**
	 * MARC doc {@link http://www.loc.gov/marc/bibliographic/ecbdlist.html}
	 * @param node
	 * @return
	 */
	@RequestMapping(value = "detectLanguage", method = RequestMethod.GET)
	public @ResponseBody String detectLanguage(
			@RequestParam(value = "node", required = true) String node) {
		File file = directorylist.getFileByKey(Integer.valueOf(node));
		XPathExpression getCtrlFld8;
		try {
			getCtrlFld8 = DOM.getXPath("//marc:controlfield[@tag='008']");
		} catch (XPathExpressionException e1) {
			logger.error("XPATH invalid", e1);
			return "ERROR - see log";
		}
		for(File inspect : file.listFiles((FilenameFilter) 
				FileFilterUtils.suffixFileFilter(".xml"))) {
			logger.debug(inspect.getAbsolutePath());
			try {
				Document doc = DOM.parse(inspect);
				NodeList nl = (NodeList) getCtrlFld8
					.evaluate(doc, XPathConstants.NODESET);
				logger.debug("008: " +nl.getLength());
				for(int i = 0; i < nl.getLength(); ++i) {
					Element e = (Element) nl.item(i);
					String val = e.getTextContent();
					if(val.length() > 37) {
						String marcLangCode = val.substring(35, 38).trim();
						String tessLang = marcLang2TesseractLang.get(marcLangCode);
						return tessLang == null? "" : tessLang;
					}
				}
			} catch (XPathExpressionException e) {
				logger.error(file.getAbsolutePath() + " XPath eval error.", e);
			}
		}
		return "";
	}

}
