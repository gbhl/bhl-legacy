package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.util.PDFTextStripper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.annotation.MessageEndpoint;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.LogGenericObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.utils.PDFPageImageWriter;
import at.co.ait.utils.TikaUtils;

@MessageEndpoint
public class PDFBoxService {
	private static final Logger logger = LoggerFactory.getLogger(PDFBoxService.class);

	private @Autowired LogGenericObject loggenericobject;
	
	public List<DigitalObject> extract(List<DigitalObject> doList) throws IOException {
		ArrayList<DigitalObject> ret = new ArrayList<DigitalObject>();
        DigitalObject prev = null;
		for(DigitalObject obj : doList) {
			if("application/pdf".equals(TikaUtils.detectedMimeType(obj.getSubmittedFile()))) {
				logger.debug("PDFBox on " + obj.getSubmittedFile().getAbsolutePath());
				
				PDDocument doc = PDDocument.load(obj.getSubmittedFile());
				
								
				int resolution = 96; // TODO add default DPI to User options.
	            String prefix = obj.getSubmittedFile().getName().replace(".pdf", "_pdf_");
				File outputDir = new File(obj.getSubmittedFile().getParentFile(), ".aip");
				if(!outputDir.exists()) {
					outputDir.mkdirs();
				}
				
				List<?> pages = doc.getDocumentCatalog().getAllPages();
				PDFPageImageWriter pageImgWr = new PDFPageImageWriter();
				for(int pageNo = 1; pageNo <= pages.size(); ++pageNo ) {
					logger.debug("Extracting page " + pageNo + 
								" from " + obj.getSubmittedFile().getName());
					File targetImg = new File(outputDir, prefix + pageNo + ".jpg");
					File targetTxt = new File(outputDir, prefix + pageNo + ".jpg.txt");
					PDPage page = (PDPage) pages.get(pageNo - 1);
					pageImgWr.pageToImage(page, targetImg, "JPEG", resolution);
					
					PDFTextStripper stripper = new PDFTextStripper();
					stripper.setStartPage(pageNo);
					stripper.setEndPage(pageNo);
					String text = stripper.getText(doc);
					FileUtils.writeStringToFile(targetTxt, text, "UTF-8");
					
					if(targetImg.isFile()) {
						DigitalObject dobj = new DigitalObject(loggenericobject);
		    			dobj.setPrefs(obj.getPrefs());			
		    			dobj.setFolder(outputDir);
		    			dobj.setPrev(prev);
		    			dobj.setSubmittedFile(targetImg);			
		    			dobj.setFileurl(ConfigUtils.createFileURL(targetImg));
		    			ret.add(dobj);
		    			prev = dobj;
					}
				}
				
			} else {
				logger.debug("PDFBox passing on " + obj.getSubmittedFile().getAbsolutePath());
				ret.add(obj);
				obj.setPrev(prev);
				prev = obj;
			}
			if(prev == null) prev = obj;
		}
		return ret;
	}
	
}