package at.co.ait.utils;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;

public class ConfigUtils {
	public static final String TMP_PROCESSING = ".aip";
	private static final String WEBAPP_ROOT = Configuration
	.getString("ConfigUtils.0"); //$NON-NLS-1$

	public static String getTmpFileName(File file, String postfix) {
		String name = null;
		if (file.isFile()) {
			name = file.getParent() + File.separator + TMP_PROCESSING
					+ File.separator + file.getName() + postfix;
		}
		if (file.isDirectory()) {
			name = file.getAbsolutePath() + File.separator + TMP_PROCESSING
			+ File.separator + file.getName() + postfix;
		}
		return name;
	}
	
	public static String createFileURL(File file, String basedir) throws IOException {
		File[] files = new File[1];
		files[0] = file;
		String fileurl = WEBAPP_ROOT
				+ StringUtils.remove(FileUtils.toURLs(files)[0].toString(),
						basedir);
		return fileurl;
	}

}
