package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TimeZone;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.DOMOutputter;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.DigitalObjectType;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.web.common.UserPreferences;
import au.edu.apsr.mtk.base.Agent;
import au.edu.apsr.mtk.base.Div;
import au.edu.apsr.mtk.base.DmdSec;
import au.edu.apsr.mtk.base.FLocat;
import au.edu.apsr.mtk.base.FileGrp;
import au.edu.apsr.mtk.base.FileSec;
import au.edu.apsr.mtk.base.Fptr;
import au.edu.apsr.mtk.base.METS;
import au.edu.apsr.mtk.base.METSException;
import au.edu.apsr.mtk.base.METSWrapper;
import au.edu.apsr.mtk.base.MdWrap;
import au.edu.apsr.mtk.base.MetsHdr;
import au.edu.apsr.mtk.base.StructMap;

import com.sun.org.apache.xml.internal.serialize.OutputFormat;
import com.sun.org.apache.xml.internal.serialize.XMLSerializer;

public class MetsMarshallerService {

	private METS mets = null;

	private METSWrapper createMETS(InformationPackageObject obj,
			UserPreferences prefs) throws JDOMException,
			ParserConfigurationException, METSException, IOException,
			SAXException {
		METSWrapper mw = null;
		mw = new METSWrapper();

		mets = mw.getMETSObject();

		mets.setObjID(String.valueOf(obj.getIdentifier()));
		mets.setProfile("http://www.bhl-europe.eu/profiles/bhle-mets-profile-1.0");
		mets.setType("investigation");

		MetsHdr mh = mets.newMetsHdr();

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT+1"));
		String currentTime = df.format(cal.getTime());
		mh.setCreateDate(currentTime);
		mh.setRecordStatus("Complete");

		Agent agent = mh.newAgent();
		agent.setRole("ARCHIVIST");
		agent.setType("ORGANIZATION");
		agent.setName(prefs.getOrganization());
		agent.setNote("BHL-Europe Content Provider");
		mh.addAgent(agent);

		agent = mh.newAgent();
		agent.setRole("ARCHIVIST");
		agent.setType("OTHER");
		agent.setName("BHL-Europe Pre-Ingest Tool");
		agent.setNote("Automatic processing of submitted content");
		mh.addAgent(agent);
		mets.setMetsHdr(mh);		

		// unique sequence number for each dmd section
		int iter = 0;		
		DmdSec dmd = null;
		// create dmd entry for each METADATA file
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getObjecttype().equals(DigitalObjectType.METADATA)) {
				iter++;
				dmd = newDmdEntry(iter, "MODS", "derivative", digobj.getSmtoutput());
				mets.addDmdSec(dmd);
			}
		}
		iter++;
		dmd = newDmdEntry(iter, "OTHER", "derivative", obj.getNepomukFileOntology());
		mets.addDmdSec(dmd);
		

		FileSec fs = mets.newFileSec();

		// unique sequence number for each file
		iter = 0;
		// create filegroup for each digitalobjecttype such as METADATA, IMAGE
		for (DigitalObjectType value : DigitalObjectType.values()) {
			FileGrp fg = fs.newFileGrp();
			fg.setUse(value.name());

			for (DigitalObject digobj : obj.getDigitalobjects()) {
				if (digobj.getObjecttype().equals(value)) {
					au.edu.apsr.mtk.base.File f = fg.newFile();
					f.setID("F-" + (++iter));
					f.setSize(FileUtils.sizeOf(digobj.getSubmittedFile()));
					f.setMIMEType(digobj.getMimetype());
					f.setChecksum(digobj.getDigestValueinHex());
					f.setChecksumType("SHA-1");

					FLocat fl = f.newFLocat();
					fl.setHref(digobj.getSubmittedFile().getAbsolutePath());
					fl.setLocType("OTHER");
					f.addFLocat(fl);
					fg.addFile(f);
				}
			}
			// if filegroup contains any files, add to filesection
			if (fg.getFiles().size() > 0)
				fs.addFileGrp(fg);
		}
		
		// add taxa files to filesection
		FileGrp fg = fs.newFileGrp();
		fg.setUse("TAXA");
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getTaxa() != null) {
				au.edu.apsr.mtk.base.File f = fg.newFile();
				f.setID("F-" + (++iter));
				f.setSize(FileUtils.sizeOf(digobj.getTaxa()));
				FLocat fl = f.newFLocat();
				fl.setHref(digobj.getTaxa().getAbsolutePath());
				fl.setLocType("OTHER");
				f.addFLocat(fl);
				fg.addFile(f);
			}
			// if filegroup contains any files, add to filesection
			if (fg.getFiles().size() > 0)
				fs.addFileGrp(fg);			
		}
		
		// add ocr files to filesection
		fg = fs.newFileGrp();
		fg.setUse("OCR");
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getOcr() != null) {
				au.edu.apsr.mtk.base.File f = fg.newFile();
				f.setID("F-" + (++iter));
				f.setSize(FileUtils.sizeOf(digobj.getOcr()));
				FLocat fl = f.newFLocat();
				fl.setHref(digobj.getOcr().getAbsolutePath());
				fl.setLocType("OTHER");
				f.addFLocat(fl);
				fg.addFile(f);
			}
			// if filegroup contains any files, add to filesection
			if (fg.getFiles().size() > 0)
				fs.addFileGrp(fg);			
		}
		
		// add jhove files to filesection
		fg = fs.newFileGrp();
		fg.setUse("JHOVE");
		for (DigitalObject digobj : obj.getDigitalobjects()) {
			if (digobj.getTechMetadata() != null) {
				au.edu.apsr.mtk.base.File f = fg.newFile();
				f.setID("F-" + (++iter));
				f.setSize(FileUtils.sizeOf(digobj.getTechMetadata()));
				FLocat fl = f.newFLocat();
				fl.setHref(digobj.getTechMetadata().getAbsolutePath());
				fl.setLocType("OTHER");
				f.addFLocat(fl);
				fg.addFile(f);
			}
			// if filegroup contains any files, add to filesection
			if (fg.getFiles().size() > 0)
				fs.addFileGrp(fg);			
		}

		mets.setFileSec(fs);

		StructMap sm = mets.newStructMap();
		mets.addStructMap(sm);

		Div d = sm.newDiv();
		d.setType("investigation");
		d.setDmdID("dmd1");
		sm.addDiv(d);

		Fptr fp = d.newFptr();
		fp.setFileID("F-1");
		d.addFptr(fp);

		mw.validate();

		return mw;
	}
	
	private DmdSec newDmdEntry(int iter, String type, String lbl, File metadata)
			throws METSException, JDOMException, IOException {
		SAXBuilder parser = new SAXBuilder();
		org.jdom.Document modsdoc = parser.build(metadata);
		DmdSec dmd = mets.newDmdSec(); 
		dmd.setID("dmd" + iter);
		MdWrap mdw = dmd.newMdWrap();
		mdw.setMDType(type);
		mdw.setLabel(lbl);
		DOMOutputter domOutputter = new DOMOutputter();
		org.w3c.dom.Document w3cDoc = domOutputter.output(modsdoc);
		mdw.setXmlData(w3cDoc.getDocumentElement());
		dmd.setMdWrap(mdw);
		return dmd;
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
			ParserConfigurationException, IOException, METSException, SAXException {
		obj.setMets(createMETS(obj, prefs));
		String tmpfile = ConfigUtils.getTmpFileName(obj.getSubmittedFile(),
				".mets.xml");
		File metsfile = new File(tmpfile);
		Document doc = obj.getMets().getMETSDocument();
		OutputFormat format = new OutputFormat(doc);
		format.setLineWidth(65);
		format.setIndenting(true);
		format.setIndent(2);
		XMLSerializer serializer = new XMLSerializer(
				FileUtils.openOutputStream(metsfile), format);
		serializer.serialize(doc);
		return obj;
	}

}