package at.co.ait.domain.services;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TimeZone;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.FileUtils;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.DOMOutputter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.DigitalObjectType;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.utils.TikaUtils;
import at.co.ait.web.common.UserPreferences;
import au.edu.apsr.mtk.base.Agent;
import au.edu.apsr.mtk.base.Div;
import au.edu.apsr.mtk.base.DmdSec;
import au.edu.apsr.mtk.base.FLocat;
import au.edu.apsr.mtk.base.FileGrp;
import au.edu.apsr.mtk.base.FileSec;
import au.edu.apsr.mtk.base.METS;
import au.edu.apsr.mtk.base.METSException;
import au.edu.apsr.mtk.base.METSWrapper;
import au.edu.apsr.mtk.base.MdWrap;
import au.edu.apsr.mtk.base.MetsHdr;
import au.edu.apsr.mtk.base.StructMap;

import com.sun.org.apache.xml.internal.serialize.OutputFormat;
import com.sun.org.apache.xml.internal.serialize.XMLSerializer;

public class FedoraMetsMarshallerService {

	private static final Logger logger = LoggerFactory.getLogger(MetsMarshallerService.class);
	
	private METS mets = null;

	private METSWrapper createMETS(InformationPackageObject obj,
			UserPreferences prefs) throws JDOMException,
			ParserConfigurationException, METSException, IOException,
			SAXException {

		METSWrapper mw = null;
		mw = new METSWrapper();

		mets = mw.getMETSObject();
		//FIXME BHLE in config file.
		mets.setObjID("BHLE" + obj.getIdentifier().replace('/', ':'));
		mets.setProfile("http://www.bhl-europe.eu/profiles/bhle-mets-profile-1.0"); //$NON-NLS-1$
		mets.setType("FedoraObject"); //$NON-NLS-1$		
		mets.setLabel("External ID: " + obj.getExternalIdentifier() + ", " +
				      "Collection: " + prefs.getOrganization() + ", " + 
				      "ID: " + obj.getIdentifier());

		MetsHdr mh = mets.newMetsHdr();

		mh.setRecordStatus("A"); //$NON-NLS-1$		

		Agent agent = mh.newAgent();
		agent.setRole("IPOWNER"); //$NON-NLS-1$
		agent.setType("ORGANIZATION"); //$NON-NLS-1$
		agent.setName(prefs.getOrganization());
		agent.setNote("BHL-Europe Content Provider"); //$NON-NLS-1$
		mh.addAgent(agent);
		
		mets.setMetsHdr(mh);

		DmdSec dmd = null;

		// create dmd entry for each METADATA file
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getObjecttype().equals(DigitalObjectType.METADATA)) {
				dmd = newDmdEntry(digobj.getOrder(), "OTHER", "derivative", //$NON-NLS-1$ //$NON-NLS-2$
						digobj.getSmtoutput());
				mets.addDmdSec(dmd);
			}
		}

		FileSec fs = mets.newFileSec();
		FileGrp datastream = fs.newFileGrp();
		String id = "DATASTREAMS";
		datastream.setID(id);

		// create filegroup for each digitalobjecttype such as METADATA, IMAGE
		for (DigitalObjectType value : DigitalObjectType.values()) {
			for (DigitalObject digobj : obj.getDigitalobjects()) {
				if (digobj.getObjecttype().equals(value)) {
					FileGrp fg = fs.newFileGrp();
					fg.setID(value.name() + "." + digobj.getOrder());
					au.edu.apsr.mtk.base.File f = fg.newFile();
					f.setID(value.name() + "." + digobj.getOrder() + ".FILE"); //$NON-NLS-1$
					f.setSize(FileUtils.sizeOf(digobj.getSubmittedFile()));
					f.setMIMEType(digobj.getMimetype());
					f.setChecksum(digobj.getDigestValueinHex());
					f.setChecksumType("SHA-1"); //$NON-NLS-1$
					f.setOwnerID("M");
					FLocat loc = createLocat(digobj.getSubmittedFile(),
							prefs.getBasedirectory(), f);
					f.addFLocat(loc);
					fg.addFile(f);
					datastream.addFileGrp(fg);
				}
			}
		}

		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getTaxa() != null) {
				FileGrp fg = fs.newFileGrp();
				fg.setID("TAXA." + digobj.getOrder()); //$NON-NLS-1$
				au.edu.apsr.mtk.base.File f = fg.newFile();
				f.setID("TAXA." + digobj.getOrder() + ".FILE"); //$NON-NLS-1$
				f.setSize(FileUtils.sizeOf(digobj.getTaxa()));
				f.setMIMEType(TikaUtils
						.detectedMimeType(digobj.getTaxa()));
				f.setOwnerID("M");
				FLocat loc = createLocat(digobj.getTaxa(),
						prefs.getBasedirectory(), f);
				f.addFLocat(loc);
				fg.addFile(f);
				datastream.addFileGrp(fg);
			}
		}

		// add ocr files to filesection
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getOcr() != null) {
				FileGrp fg = fs.newFileGrp();
				fg.setID("OCR." + digobj.getOrder()); //$NON-NLS-1$
				au.edu.apsr.mtk.base.File f = fg.newFile();
				f.setID("OCR." + digobj.getOrder() + ".FILE"); //$NON-NLS-1$
				f.setSize(FileUtils.sizeOf(digobj.getOcr()));
				f.setMIMEType(TikaUtils
						.detectedMimeType(digobj.getOcr()));
				f.setOwnerID("M");
				FLocat loc = createLocat(digobj.getOcr(),
						prefs.getBasedirectory(), f);
				f.addFLocat(loc);
				fg.addFile(f);
				datastream.addFileGrp(fg);
			}				
		}

		// add jhove files to filesection
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getTechMetadata() != null) {
				FileGrp fg = fs.newFileGrp();
				fg.setID("JHOVE." + digobj.getOrder()); //$NON-NLS-1$
				au.edu.apsr.mtk.base.File f = fg.newFile();
				f.setID("JHOVE." + digobj.getOrder() + ".FILE"); //$NON-NLS-1$
				f.setSize(FileUtils.sizeOf(digobj.getTechMetadata()));
				f.setOwnerID("M");
				f.setMIMEType(TikaUtils
						.detectedMimeType(digobj.getTechMetadata()));
				FLocat loc = createLocat(digobj.getTechMetadata(),
						prefs.getBasedirectory(), f);
				f.addFLocat(loc);
				fg.addFile(f);
				datastream.addFileGrp(fg);
			}
		}

		// add rdf nfo file to filesection
		FileGrp fg = fs.newFileGrp();
		fg.setID("NFO"); //$NON-NLS-1$
		au.edu.apsr.mtk.base.File f = fg.newFile();
		f.setID("NFO.FILE"); //$NON-NLS-1$
		f.setSize(FileUtils.sizeOf(obj.getNepomukFileOntology()));
		f.setOwnerID("M");
		f.setMIMEType(TikaUtils.detectedMimeType(obj
				.getNepomukFileOntology()));
		FLocat loc = createLocat(obj.getNepomukFileOntology(),
				prefs.getBasedirectory(), f);
		f.addFLocat(loc);
		fg.addFile(f);
		datastream.addFileGrp(fg);

		fs.addFileGrp(datastream);
		mets.setFileSec(fs);

		StructMap sm = mets.newStructMap();

		Div d = sm.newDiv();
		sm.addDiv(d);

		mets.addStructMap(sm);

		mw.validate();

		return mw;
	}

	private DmdSec newDmdEntry(int id, String type, String lbl, File metadata)
			throws METSException, JDOMException, IOException {
		SAXBuilder parser = new SAXBuilder();
		org.jdom.Document modsdoc = parser.build(metadata);
		DmdSec dmd = mets.newDmdSec();
		dmd.setID(lbl + "-" + id); //$NON-NLS-1$
		MdWrap mdw = dmd.newMdWrap();
		mdw.setMDType(type);
		mdw.setLabel(lbl);
		DOMOutputter domOutputter = new DOMOutputter();
		org.w3c.dom.Document w3cDoc = domOutputter.output(modsdoc);
		mdw.setXmlData(w3cDoc.getDocumentElement());
		dmd.setMdWrap(mdw);
		return dmd;
	}

	private FLocat createLocat(File file, String basedir,
			au.edu.apsr.mtk.base.File f) throws METSException, IOException {
		String fileurl = ConfigUtils.createFileURL(file);
		FLocat loc = f.newFLocat();
		loc.setHref(fileurl);
		loc.setLocType("URL"); //$NON-NLS-1$		
		return loc;
	}

	/**
	 * Enriches the information package object by adding METS metadata
	 * 
	 * @param obj
	 * @return
	 * @throws ParserConfigurationException
	 * @throws JDOMException
	 * @throws IOException
	 * @throws SAXException
	 * @throws METSException
	 */
	public InformationPackageObject marshal(InformationPackageObject obj,
			UserPreferences prefs) throws JDOMException,
			ParserConfigurationException, IOException, METSException,
			SAXException {
		logger.info("Fedora METS Marshaller");
		
		obj.setMets(createMETS(obj, prefs));
		File metsfile = ConfigUtils.getAipFile(prefs.getBasedirectoryFile(),
				obj.getSubmittedFile(), ".mets.xml"); //$NON-NLS-1$
		obj.setMetsfileurl(ConfigUtils.createFileURL(metsfile));
		Document doc = obj.getMets().getMETSDocument();

		Element element = (Element) doc.getElementsByTagName("mets").item(0);
		element.setAttribute("EXT_VERSION", "1.1");
		element.setAttribute("xmlns", "http://www.loc.gov/METS/");
		element.setAttribute("xmlns:xlink", "http://www.w3.org/1999/xlink");
		element.setAttribute("xmlns:xsi",
				"http://www.w3.org/2001/XMLSchema-instance");
		element.setAttribute(
				"xmlns:schemaLocation",
				"http://www.loc.gov/METS/ http://www.fedora.info/definitions/1/0/mets-fedora-ext1-1.xsd");

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"); //$NON-NLS-1$
		df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"); //$NON-NLS-1$
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT+1")); //$NON-NLS-1$
		String currentTime = df.format(cal.getTime());

		NodeList nodeList = doc.getElementsByTagName("dmdSec");
		for (int i = 0; i < nodeList.getLength(); i++) {
			Node node = nodeList.item(i);			
			Node content = node.getChildNodes().item(0).cloneNode(true);
			Element add = doc.createElement("descMD");
			add.setAttribute("ID", "DESC." + String.valueOf(i));
			node.replaceChild(add, node.getChildNodes().item(0));
			add.appendChild(content);
			doc.renameNode(node, "", "dmdSecFedora");
		}
		
		String remElement = "structMap";		
		element = (Element)doc.getElementsByTagName(remElement).item(0);
		element.getParentNode().removeChild(element);
		doc.normalize();

		OutputFormat format = new OutputFormat(doc);
		format.setLineWidth(65);
		format.setIndenting(true);
		format.setIndent(2);
		FileOutputStream out = FileUtils.openOutputStream(metsfile);
		XMLSerializer serializer = new XMLSerializer(out, format);
		serializer.serialize(doc);
		out.close();
		return obj;
	}

}
