package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.util.PDFTextStripper;
import org.springframework.integration.annotation.MessageEndpoint;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.utils.ConfigUtils;

@MessageEndpoint
public class PDFBoxService {

	public DigitalObject extract(DigitalObject obj) throws IOException {
		PDFTextStripper stripper = new PDFTextStripper();
		PDDocument doc = PDDocument.load(obj.getSubmittedFile());
		String text = stripper.getText(doc);
		if (!text.isEmpty()) {
			String tmpfile = ConfigUtils.getTmpFileName(obj.getSubmittedFile(),".txt");
			File output = new File(tmpfile);
			FileUtils.writeStringToFile(output, text, "UTF-8");
			obj.setOcr(output);
		}
		return obj;
	}

}