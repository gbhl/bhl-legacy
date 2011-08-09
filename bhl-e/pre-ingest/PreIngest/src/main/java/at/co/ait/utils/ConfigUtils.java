package at.co.ait.utils;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;

public class ConfigUtils {
	public static final String TMP_PROCESSING = ".aip";
	private static final String WEBAPP_ROOT = Configuration
	.getString("ConfigUtils.0"); //$NON-NLS-1$
	private static final String DATA_ROOT = Configuration
	.getString("DataRoot"); //$NON-NLS-1$

	public static String getTmpFileName(File file, String postfix) {
		String name = null;
		if (file.isFile()) {
			File parent = file.getParentFile();
			if(parent.getName().equals(TMP_PROCESSING)) {
				name = file.getAbsolutePath() + postfix;
			} else {
				name = file.getParent() + File.separator + TMP_PROCESSING
						+ File.separator + file.getName() + postfix;
			}
		}
		if (file.isDirectory()) {
			if(file.getName().equals(TMP_PROCESSING) 
					|| file.getParentFile().getName().equals(TMP_PROCESSING)) {
				name = file.getAbsolutePath() + File.separator + postfix;
			} else {
				name = file.getAbsolutePath() + File.separator + TMP_PROCESSING
				+ File.separator + file.getName() + postfix;
			}
		}
		return name;
	}
	
	public static String createFileURL(File file) throws IOException {
		File[] files = new File[1];
		files[0] = file;
		String fileurl = WEBAPP_ROOT
				+ StringUtils.remove(FileUtils.toURLs(files)[0].toString(),
						DATA_ROOT);
		return fileurl;
	}

}
