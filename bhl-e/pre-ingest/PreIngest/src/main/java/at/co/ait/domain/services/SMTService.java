package at.co.ait.domain.services;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.domain.oais.DigitalObject;
import at.co.ait.utils.ConfigUtils;
import at.co.ait.utils.Configuration;
import at.co.ait.web.common.UserPreferences;

public class SMTService extends ProcessbuilderService {

	private static final Logger logger = LoggerFactory
			.getLogger(SMTService.class);

	private List<String> commands;
	private UserPreferences prefs;

	public DigitalObject map(DigitalObject obj, String params)
			throws MalformedURLException, IOException, InterruptedException {

		String tmpfile = ConfigUtils.getTmpFileName(obj.getSubmittedFile(),
				Configuration.getString("SMTService.tmpfilepostifx")); //$NON-NLS-1$
		String srcfile = obj.getSubmittedFile().getAbsolutePath();
		URL smtexec = new URL(Configuration.getString("SMTService.smt")); //$NON-NLS-1$

		commands = new ArrayList<String>();
		commands.add(Configuration.getString("SMTService.javaexec")); //$NON-NLS-1$
		commands.add(Configuration.getString("SMTService.javaparam")); //$NON-NLS-1$
		commands.add(smtexec.getPath());
		for (String param : params.split(Configuration
				.getString("SMTService.smtparam_splitstring"))) { //$NON-NLS-1$
			commands.add(param);
		}
		commands.add(Configuration.getString("SMTService.smtparam_inputfile")); //$NON-NLS-1$
		commands.add(srcfile);
		commands.add(Configuration.getString("SMTService.smtparam_outputfile")); //$NON-NLS-1$
		commands.add(tmpfile);
		File out = new File(tmpfile);
		if (!out.exists()) {
			process(commands);
			obj.setSmtServiceLog(stdout.toString());
		}
		obj.setSmtoutput(out);		
		return obj;
	}

}
