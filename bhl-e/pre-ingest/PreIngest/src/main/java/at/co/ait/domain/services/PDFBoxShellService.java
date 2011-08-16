package at.co.ait.domain.services;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import org.apache.commons.io.filefilter.FileFilterUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.annotation.MessageEndpoint;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.LogGenericObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.utils.Configuration;
import at.co.ait.utils.TikaUtils;

@MessageEndpoint
public class PDFBoxShellService {
	private static final Logger logger = LoggerFactory.getLogger(PDFBoxShellService.class);

	private @Autowired LogGenericObject loggenericobject;
	
	public List<DigitalObject> extract(List<DigitalObject> doList) throws IOException {
		ArrayList<DigitalObject> ret = new ArrayList<DigitalObject>();
        DigitalObject prev = null;
		for(DigitalObject obj : doList) {
			if("application/pdf".equals(TikaUtils.detectedMimeType(obj.getSubmittedFile()))) {
				logger.debug("PDFBoxShell on " + obj.getSubmittedFile().getAbsolutePath());
				
				
	            String prefix = obj.getSubmittedFile().getName().replace(".pdf", "_pdf");
				File outputDir = new File(obj.getSubmittedFile().getParentFile(), ".aip");
				if(!outputDir.exists()) {
					outputDir.mkdirs();
				}
				// pdftoppm -r 300 xy.pdf .aip/xy_pdf
				SystemCommandExecutor pdftoppm = new SystemCommandExecutor(Arrays.asList(
						new String[] {
								 new URL(Configuration.getString("PDFConvert.pdftoppm")).getPath(),
								 Configuration.getString("PDFConvert.pdftoppm.resolutionSwitch"),
								 Configuration.getString("PDFConvert.pdftoppm.resolution"),
								 obj.getSubmittedFile().getAbsolutePath(),
								 new File(outputDir, prefix).getAbsolutePath(),
								 
						}));
				try {
					int havePPM = 0;
					int haveTIF = 0;
					for(File existing: outputDir.listFiles((FilenameFilter) 
							FileFilterUtils.prefixFileFilter(prefix))) {
						if(existing.getName().endsWith(".ppm")) havePPM++;
						if(existing.getName().endsWith(".tif")) haveTIF++;
					}
					if(haveTIF == 0) {
						int pdftoppmRet = pdftoppm.executeCommand();
						if(pdftoppmRet != 0) {
							logger.warn("pdftoppm " + Configuration.getString("PDFConvert.pdftoppm")
									+ " exits with status " + pdftoppmRet 
									+ " stderr: " + pdftoppm.getStandardErrorFromCommand());
						}
						havePPM = Integer.MAX_VALUE;
					}
					
					List<File> ppmFiles = Arrays.asList(outputDir.listFiles((FilenameFilter) 
							FileFilterUtils.prefixFileFilter(prefix)));
					Collections.sort(ppmFiles);
					for(File ppm: ppmFiles) {
						if(!ppm.getName().endsWith(".ppm")) continue;
						File tifName = new File(ppm.getAbsolutePath().replace(".ppm", "") + ".tif");
						// convert .aip/xy_pdf-001.ppm .aip/xy_pdf-001.tif
						SystemCommandExecutor convert = new SystemCommandExecutor(Arrays.asList(
								new String[] {
										 new URL(Configuration.getString("PDFConvert.convert")).getPath(),
										 Configuration.getString("PDFConvert.convert.compressionSwitch"),
										 Configuration.getString("PDFConvert.convert.compression"),
										 ppm.getAbsolutePath(),
										 tifName.getAbsolutePath(),
								}));
						
						int convertRet = convert.executeCommand();
						if(convertRet != 0) {
							logger.warn("convert " + Configuration.getString("PDFConvert.pdftoppm")
									+ " exits with status " + convertRet 
									+ " stderr: " + convert.getStandardErrorFromCommand());
						}
						// delete intermediary ppm
						ppm.delete();
					}
					List<File> tifFiles = Arrays.asList(outputDir.listFiles((FilenameFilter) 
							FileFilterUtils.prefixFileFilter(prefix)));
					Collections.sort(tifFiles);
					for(File tif: tifFiles) {
						if(!tif.getName().endsWith(".tif")) continue;
						if(tif.isFile()) {
							DigitalObject dobj = new DigitalObject(loggenericobject);
			    			dobj.setPrefs(obj.getPrefs());			
			    			dobj.setFolder(outputDir);
			    			dobj.setPrev(prev);
			    			dobj.setSubmittedFile(tif);			
			    			dobj.setFileurl(ConfigUtils.createFileURL(tif));
			    			ret.add(dobj);
			    			prev = dobj;
						}
						
					}
				} catch (InterruptedException e) {
					logger.warn("PDFBoxShellSerivce was interupted.", e);
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