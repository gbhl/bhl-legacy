package at.co.ait.utils;

import java.io.File;

public class ConfigUtils {
	public static final String TMP_PROCESSING = ".aip";

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

}
