package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.InformationPackageObject;
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

public class MetsMarshallerService {
	
	private List<DigitalObject> packagedFiles = new ArrayList<DigitalObject>();
	private static final Logger logger = LoggerFactory.getLogger(MetsMarshallerService.class);
	private METS mets = null;
	
    static private Document createMODS(String title, String genre) throws ParserConfigurationException
    {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.newDocument();
        Element root = doc.createElementNS("http://www.loc.gov/mods/v3", "mods");
        doc.appendChild(root);
        
        Element ti = doc.createElement("titleInfo");
        Element t = doc.createElement("title");
        t.setTextContent(title);
        ti.appendChild(t);
        root.appendChild(ti);
        
        Element g = doc.createElement("genre");
        g.setTextContent(genre);
        root.appendChild(g);
        
        return doc;
    }
    
    private METSWrapper createMETS(InformationPackageObject obj) {
    	METSWrapper mw = null;
    	try {
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
			mdw.setXmlData(createMODS("demo", "experiment").getDocumentElement());
			dmd.setMdWrap(mdw);
			
			mets.addDmdSec(dmd);
			FileSec fs = mets.newFileSec();
			FileGrp fg = fs.newFileGrp();
			int iter = 0;
			
			synchronized(obj.getDigitalobjects()) {
				for (DigitalObject digobj : obj.getDigitalobjects()) {	
					
					fg.setUse("original");
					
					au.edu.apsr.mtk.base.File f = fg.newFile();
					f.setID("F-"+(++iter));				
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
		} catch (ParserConfigurationException e) {
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
     * @param obj
     * @return
     */
    public InformationPackageObject enrichInformationPackageObject(InformationPackageObject obj) {
    	obj.setMets(createMETS(obj));
    	return obj;
    }
		
	
}
