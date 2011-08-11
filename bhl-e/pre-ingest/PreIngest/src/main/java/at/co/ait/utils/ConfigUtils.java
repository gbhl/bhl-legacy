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

	
	public static File getAipFile(File basedir, File file, String postfix) {
		String outprefix = file.getName();
		File indir = file.isDirectory()? file : file.getParentFile();
		if(file.isDirectory()) {
			// add parent folder to name.
			for(File parentdir = indir.getParentFile();
					parentdir != null && !parentdir.equals(basedir);
					parentdir = parentdir.getParentFile()) {
				outprefix = parentdir.getName() + "_" + outprefix;
			}
		}
		File basename = new File(new File(indir, TMP_PROCESSING), outprefix + postfix);
		return basename;
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
