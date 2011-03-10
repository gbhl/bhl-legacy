package at.co.ait.domain;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DirectoryListing {
	private Collection<File> files = null;
	private String basedir = null; 
	//FIXXME: allFilesAndFolders needs to be split up, get rid of String[]
	private Map<Integer,String> allFilesAndFolders = new HashMap<Integer,String>();
	private static final Logger logger = LoggerFactory.getLogger(DirectoryListing.class);
	
	public Collection<File> getFiles() {
		return files;
	}
	
	public void setFiles(Collection<File> files) {
		this.files = files;
	}
	
	public String getBasedir() {
		return basedir;
	}
	
	public void setBasedir(String basedir) {
		this.basedir = basedir;
		this.files = readFilesAndFoldersFromDir(basedir);	
		this.simpleDirectoryWalker(new File(basedir));
	}
	
	public File getFileByKey(Integer key) {
		return new File(allFilesAndFolders.get(key));
	}
	
	/**
	 * Invokes recursive listing of input directory.
	 * @param fileObject Root directory's File object.
	 */
    private void simpleDirectoryWalker(File fileObject){		
        if (fileObject.isDirectory()){
        	allFilesAndFolders.put(fileObject.hashCode(),
        			fileObject.getAbsolutePath());
            File allFiles[] = fileObject.listFiles();
            for(File aFile : allFiles){
                simpleDirectoryWalker(aFile);
        }
        }else if (fileObject.isFile()){
        	allFilesAndFolders.put(fileObject.hashCode(), 
        			fileObject.getAbsolutePath());
        }		
    }
	
	/**
	 * Read all files and folders from a directory.
	 * @param dir AbsolutePath of directory.
	 * @return Collection of Files.
	 */
	public Collection<File> readFilesAndFoldersFromDir(String dir) {
		File[] filesAndFolders = (new File(dir)).listFiles();
		Collection<File> coll = new ArrayList<File>();
		for (File f : filesAndFolders) {
			coll.add(f);
		}
		return coll;
	}
	
	/**
	 * A directory tree contains a list of files and folders where each
	 * list's entry contains a map with specific entries used by Dynatree.
	 * @param key 32-bit Integer hashcode of a fileobject which returns the selected directory
	 * @return list of maps which can be serialized into JSON
	 */
	public List<Map<String,Object>> buildJSONMsgFromDir(String key) {
		String dir;
		// lookup key in a list of all files and folders to retrieve the
		// corresponding folder
		if (key==null) {
			dir=allFilesAndFolders.get(new File(this.getBasedir()).hashCode());
		} else {			
			dir=allFilesAndFolders.get(Integer.valueOf(key));
		}
		
		// build list of files and folders to be returned
		List<Map<String,Object>> elements = new ArrayList<Map<String,Object>>();
		Collection<File> files = readFilesAndFoldersFromDir(dir);		
		for (File file : files) {
			Map<String,Object> map = new HashMap<String, Object>();
			// subtract the basedir from the current dir
//			map.put("title", StringUtils.remove(file.toString(), dir[0] + "\\") + " | " + identify(file));
			map.put("title", StringUtils.remove(file.toString(), dir + "\\"));
			// assign folder properties for dynatree
			if(file.isDirectory()) {
				map.put("isFolder", file.isDirectory());	
				map.put("isLazy", true);				
			} else {	
				map.put("unselectable", true);
				map.put("hideCheckbox", true);				
			}
			// assign 32-bit integer hashcode of absolute pathname
			map.put("key", String.valueOf(file.hashCode()));
			elements.add(map);
		}
		return elements;
	}
	

	
}
