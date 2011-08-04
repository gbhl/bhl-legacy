package at.co.ait.domain.services;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.io.filefilter.SuffixFileFilter;
import org.apache.tika.Tika;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.domain.oais.DigitalObjectType;

public class TikaService {

	private static final Tika tika = new Tika();
	static private List<String> imageMimeTypes = new ArrayList<String>();
	static private List<String> metadataMimeTypes = new ArrayList<String>();
	static private List<String> pdfMimeTypes = new ArrayList<String>();
	static {
		imageMimeTypes.add("image/tiff");
		imageMimeTypes.add("image/jpeg");
		// FIXME: maybe not every text or xml file is metadata
		metadataMimeTypes.add("text/xml");
		metadataMimeTypes.add("application/xml");		
		pdfMimeTypes.add("application/pdf");
		pdfMimeTypes.add("application/octet-stream");
	}

	/**
	 * Detect MIME type of file.
	 */
	public static String detectedMimeType(File fileObj) {
		String mimeType = null;
		try {
			mimeType = tika.detect(fileObj);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return mimeType;
	}

	/**
	 * Identifies the DigitalObject and decides the DigitalObjectType.
	 * 
	 * @param fileObj
	 *            Submitted File.
	 * @return DigitalObjectType
	 */
	public DigitalObjectType detectObjectType(File fileObj) {
		if (fileObj.isFile())
			return decideImageOrMetadata(fileObj);
		if (fileObj.isDirectory())
			return DigitalObjectType.INFORMATIONPACKAGE;
		return null;
	}

	private DigitalObjectType decideImageOrMetadata(File fileObj) {
		String mimeType = detectedMimeType(fileObj);
		if (imageMimeTypes.contains(mimeType))
			return DigitalObjectType.IMAGE;
		// FIXME metadataMimeTypes isn't particularly needed, but startsWith("text") seems 
		// not too much reliable
		if (metadataMimeTypes.contains(mimeType) ||
			mimeType.startsWith("text"))
			return DigitalObjectType.METADATA;
		if (pdfMimeTypes.contains(mimeType))
				return DigitalObjectType.PDF;
		return DigitalObjectType.UNKNOWN;
	}

	/**
	 * Enriches the digtal object by adding technical metadata
	 * 
	 * @param obj
	 *            DigitalObject is getting enriched by technical metadata.
	 * @return
	 */
	public DigitalObject enrich(DigitalObject obj) {
		obj.setObjecttype(detectObjectType(obj.getSubmittedFile()));
		obj.setMimetype(detectedMimeType(obj.getSubmittedFile()));
		return obj;
	}

	// FIXME unreliable detection based on Suffix, soon @deprecated.
	public String identify(File fileObject) {

		IOFileFilter content = new SuffixFileFilter(new String[] { "tif",
				"tiff", "jpg", "jpeg" });
		IOFileFilter metadata = new SuffixFileFilter(new String[] { "txt",
				"xml", "mrc", "mrk" });

		String ident = "?";

		// File[] list = fileObject.listFiles((FilenameFilter) new
		// OrFileFilter(content,metadata));
		// for (File i : list) {
		// logger.info(i.getName());
		// }

		if (fileObject.isDirectory()) {

			if ((fileObject.listFiles((FilenameFilter) content).length > 0)
					&& (fileObject.listFiles((FilenameFilter) metadata).length > 0))
				ident = "I";

			if ((fileObject.listFiles((FilenameFilter) content).length == 0)
					&& (fileObject.listFiles((FilenameFilter) metadata).length > 0))
				ident = "T";

		} else {

			ident = "F";

		}
		return ident;
	}

}
