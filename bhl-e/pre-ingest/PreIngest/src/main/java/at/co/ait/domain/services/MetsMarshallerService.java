package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TimeZone;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.FileUtils;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.DOMOutputter;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;
import at.co.ait.utils.ConfigUtils;
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

	private METSWrapper createMETS(InformationPackageObject obj)
			throws JDOMException, ParserConfigurationException {
		METSWrapper mw = null;
		try {
			mw = new METSWrapper();

			mets = mw.getMETSObject();

			mets.setObjID(String.valueOf(obj.getIdentifier()));
			mets.setProfile("http://www.bhl-europe.eu/profiles/bhle-mets-profile-1.0");
			mets.setType("investigation");

			MetsHdr mh = mets.newMetsHdr();

			SimpleDateFormat df = new SimpleDateFormat(
					"yyyy-MM-dd'T'HH:mm:ss'Z'");
			Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT+1"));
			String currentTime = df.format(cal.getTime());
			mh.setCreateDate(currentTime);
			mh.setLastModDate(currentTime);

			Agent agent = mh.newAgent();
			agent.setRole("CREATOR");
			agent.setType("OTHER");
			agent.setName("SampleMETSBuild");

			mh.addAgent(agent);
			mets.setMetsHdr(mh);

			DmdSec dmd = mets.newDmdSec();
			dmd.setID("J-1");
			MdWrap mdw = dmd.newMdWrap();
			mdw.setMDType("MODS");

			SAXBuilder parser = new SAXBuilder();
			org.jdom.Document modsdoc = null;
			for (DigitalObject digobj : obj.getDigitalobjects()) {
				if (digobj.getSmtoutput() != null) {
					System.out.println("building mods");
					modsdoc = parser.build(digobj.getSmtoutput());
				}
			}
			DOMOutputter domOutputter = new DOMOutputter();
			org.w3c.dom.Document w3cDoc = domOutputter.output(modsdoc);
			mdw.setXmlData(w3cDoc.getDocumentElement());
			dmd.setMdWrap(mdw);

			mets.addDmdSec(dmd);
			FileSec fs = mets.newFileSec();
			FileGrp fg = fs.newFileGrp();
			int iter = 0;

			for (DigitalObject digobj : obj.getDigitalobjects()) {

				fg.setUse("original");

				au.edu.apsr.mtk.base.File f = fg.newFile();
				f.setID("F-" + (++iter));
				f.setSize(FileUtils.sizeOf(digobj.getSubmittedFile()));
				f.setMIMEType("application/octet-stream");
				f.setOwnerID("at.co.ait");
				f.setChecksum(digobj.getDigestValueinHex());
				f.setChecksumType("SHA-1");

				FLocat fl = f.newFLocat();
				fl.setHref(digobj.getSubmittedFile().getAbsolutePath());
				fl.setLocType("URL");

				f.addFLocat(fl);
				fg.addFile(f);

			}

			fs.addFileGrp(fg);
			mets.setFileSec(fs);

			StructMap sm = mets.newStructMap();
			mets.addStructMap(sm);

			Div d = sm.newDiv();
			d.setType("investigation");
			d.setDmdID("J-1");
			sm.addDiv(d);

			Fptr fp = d.newFptr();
			fp.setFileID("F-1");
			d.addFptr(fp);

			mw.validate();

		} catch (METSException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return mw;
	}

	/**
	 * Enriches the information package object by adding METS metadata
	 * 
	 * @param obj
	 * @return
	 * @throws ParserConfigurationException
	 * @throws JDOMException
	 * @throws IOException
	 */
	public InformationPackageObject marshal(InformationPackageObject obj)
			throws JDOMException, ParserConfigurationException, IOException {
		obj.setMets(createMETS(obj));
		String tmpfile = ConfigUtils.getTmpFileName(obj.getSubmittedFile(),
				".mets.xml");
		File metsfile = new File(tmpfile);
		Document doc = obj.getMets().getMETSDocument();
		OutputFormat format = new OutputFormat(doc);
		format.setLineWidth(65);
		format.setIndenting(true);
		format.setIndent(2);
		XMLSerializer serializer = new XMLSerializer(FileUtils.openOutputStream(metsfile), format);
		serializer.serialize(doc);
		return obj;
	}

}
