/**
 * 
 */
package at.co.ait.utils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import at.co.ait.web.FileBrowser;

/**
 * @author dodo
 *
 */
public class DOM {
	private static final Logger logger = LoggerFactory
	.getLogger(DOM.class);

	public static final NamespaceContext GLOBAL_NS_CTX = new NamespaceContext() {
		HashMap<String, String> aliasToURI = new HashMap<String, String>();
		HashMap<String, ArrayList<String>> uriToAlias = 
			new HashMap<String, ArrayList<String>>();
		{
			add("marc", "http://www.loc.gov/MARC21/slim");
		}
		private void add(String alias, String uri) {
			aliasToURI.put(alias, uri);
			ArrayList<String> alia = uriToAlias.get(uri);
			if(alia == null) {
				alia = new ArrayList<String>(); 
				uriToAlias.put(uri, alia);
			}
			alia.add(alias);
		}
		public Iterator<?> getPrefixes(String namespaceURI) {
			ArrayList<String> alia = uriToAlias.get(namespaceURI);
			return alia == null? null : alia.iterator();
		}
		
		public String getPrefix(String namespaceURI) {
			ArrayList<String> alia = uriToAlias.get(namespaceURI);
			return alia == null? null : alia.get(0);
		}
		
		public String getNamespaceURI(String prefix) {
			return aliasToURI.get(prefix);
		}
	};
	
	public static DocumentBuilder getDocBuilder() {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		try {
			return dbf.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
			logger.warn("DOM config invalid.", e);
			throw new RuntimeException(e);
		}
	}
	
	public static XPath getXPath() {
		XPathFactory xpf = XPathFactory.newInstance();
		javax.xml.xpath.XPath xp = xpf.newXPath();
		xp.setNamespaceContext(GLOBAL_NS_CTX);
		return xp;
	}

	public static XPathExpression getXPath(String xpath) throws XPathExpressionException {
		XPathFactory xpf = XPathFactory.newInstance();
		javax.xml.xpath.XPath xp = xpf.newXPath();
		xp.setNamespaceContext(GLOBAL_NS_CTX);
		return xp.compile(xpath);
	}

	/** Errors will be logged.
	 * 
	 * @param content XML File.
	 * @return null when an error occured
	 */
	public static Document parse(File content) {
		try {
			return getDocBuilder().parse(content);
		} catch (SAXException e) {
			logger.warn(content.getAbsolutePath() + " XML error: " + e.getMessage());
		} catch (IOException e) {
			logger.warn(content.getAbsolutePath() + " read error: " + e.getMessage());
		}
		return null;
	}
}
