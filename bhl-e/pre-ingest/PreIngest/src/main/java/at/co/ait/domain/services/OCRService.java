package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.web.common.UserPreferences;

public class OCRService extends ProcessbuilderService {

	private static final Logger logger = LoggerFactory
			.getLogger(OCRService.class);

	private List<String> commands;
	private UserPreferences prefs;

	public DigitalObject scan(DigitalObject obj) throws MalformedURLException,
			IOException, InterruptedException {
		commands = new ArrayList<String>();
		commands.add((new java.net.URL(
				"file://C:/Utilities/Tesseract-OCR/tesseract.exe")).getPath());
		commands.add(obj.getSubmittedFile().getAbsolutePath());
		// create temporary file
		commands.add(obj.getSubmittedFile().getAbsolutePath() + ".ocr");
		commands.add("-lang");
		commands.add("eng");
		process(commands);
		// read temporary file contents
		File output = new File(obj.getSubmittedFile()
				.getAbsolutePath() + ".ocr.txt");
		// set ocr on digitalobject
		obj.setOcr(FileUtils.readFileToString(output));
		// deleted temporary file
		output.delete();
		return obj;
	}
}
