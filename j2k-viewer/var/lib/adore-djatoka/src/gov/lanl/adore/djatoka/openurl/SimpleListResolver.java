/*
 * Copyright (c) 2008  Los Alamos National Security, LLC.
 *
 * Los Alamos National Laboratory
 * Research Library
 * Digital Library Research & Prototyping Team
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 * 
 */

package gov.lanl.adore.djatoka.openurl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.net.URI;
import java.net.URL;
import java.util.HashMap;
import java.util.Properties;

import gov.lanl.adore.djatoka.util.ImageRecord;
import info.openurl.oom.entities.Referent;

/**
 * Default IReferentResolver implementation that uses a tab delimited file to
 * define the association between rft_id and file path.  The imgIndexFile should
 * be defined in the OpenURLJP2KService.properties file as SimpleListResolver.imgIndexFile.
 * 
 * Property: SimpleListResolver.imgIndexFile=imgIndex.txt
 * Format: rft_id\tfile_path
 * 
 * @author Ryan Chute
 *
 */
public class SimpleListResolver implements IReferentResolver {
	private static final String PROP_IMGS_INDEX = "SimpleListResolver.imgIndexFile";
	private static HashMap<String, ImageRecord> imgs;
	private static DjatokaImageMigrator dim = new DjatokaImageMigrator();
	
	/**
	 * Referent Identifer to be resolved from Identifier Resolver. The returned
	 * ImageRecord need only contain the imageId and image file path.
	 * @param rft identifier of the image to be resolved
	 * @return ImageRecord instance containing resolvable metadata
	 * @throws ResolverException
	 */
	public ImageRecord getImageRecord(Referent rft) throws ResolverException {
        String id = ((URI)  rft.getDescriptors()[0]).toASCIIString();
        return getImageRecord(id);
	}
	
	/**
	 * Referent Identifer to be resolved from Identifier Resolver. The returned
	 * ImageRecord need only contain the imageId and image file path.
	 * @param rftId identifier of the image to be resolved
	 * @return ImageRecord instance containing resolvable metadata
	 * @throws ResolverException
	 */
	public ImageRecord getImageRecord(String rftId) throws ResolverException {
		ImageRecord ir = imgs.get(rftId);
		if (ir == null && (rftId.startsWith("http") || rftId.startsWith("file"))) {
			try {
				URI uri = new URI(rftId);
				if (dim.getProcessingList().contains(uri.toString())) {
					int i = 0;
					Thread.sleep(1000);
					while (dim.getProcessingList().contains(uri) && i < (5 * 60)){
						Thread.sleep(1000);
						i++;
					}
					if (imgs.containsKey(rftId))
					    return imgs.get(rftId);
				}
				File f = dim.convert(uri);
				ir = new ImageRecord(rftId, f.getAbsolutePath());
				if (f.length() > 0)
				    imgs.put(rftId, ir);
				else
					throw new ResolverException("An error occurred processing file:" + uri.toURL().toString());
			} catch (Exception e) {
				throw new ResolverException(e);
			}
		}
		return ir;
	}

	/**
	 * Sets a Properties object that may be used by underlying implementation
	 * @param props Properties object for use by implementation
	 * @throws ResolverException
	 */
	public void setProperties(Properties props) throws ResolverException {
		try {
			String prop = props.getProperty(PROP_IMGS_INDEX);
			if (prop != null) {
				URL url = Thread.currentThread().getContextClassLoader().getResource(props.getProperty(PROP_IMGS_INDEX));
			    imgs = getRecordMap(url.getFile());
			} else
				throw new ResolverException(PROP_IMGS_INDEX + " is not defined.");
		} catch (Exception e) {
			throw new ResolverException(e);
		}
	}
	
	private static HashMap<String, ImageRecord> getRecordMap(String f) throws Exception {
		HashMap<String, ImageRecord> map = new HashMap<String, ImageRecord>();
		BufferedReader reader = new BufferedReader(new FileReader(f));
		String row = null;
		for (int line = 0; true; line++) {
			row = reader.readLine();
            if (row == null)
                break;
			String[] v = row.split("\t");
			if (v.length < 2)
				System.out.println("Invalid format for Record Map; expects tab delimited id\tfilepath");
			ImageRecord r = new ImageRecord(v[0], v[1]);
			map.put(v[0], r);
		}
		return map;
	}
}
