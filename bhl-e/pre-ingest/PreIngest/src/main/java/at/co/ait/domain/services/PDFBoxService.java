package at.co.ait.domain.services;

import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.util.PDFTextStripper;
import org.springframework.integration.annotation.MessageEndpoint;

import at.co.ait.domain.oais.DigitalObject;

@MessageEndpoint
public class PDFBoxService {

	public DigitalObject extract(DigitalObject obj) throws IOException {
		PDFTextStripper stripper = new PDFTextStripper();
		PDDocument doc = PDDocument.load(obj.getSubmittedFile());
		String text = stripper.getText(doc);
		if (!text.isEmpty())
			obj.setOcr(stripper.getText(doc));		
		return obj;
	}

}