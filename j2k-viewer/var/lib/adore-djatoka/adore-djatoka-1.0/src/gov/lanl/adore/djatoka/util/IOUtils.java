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

package gov.lanl.adore.djatoka.util;

import gov.lanl.adore.djatoka.io.reader.ImageJReader;
import gov.lanl.adore.djatoka.io.writer.TIFWriter;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Properties;

import ij.ImagePlus;
import ij.io.FileSaver;

/**
 * General Utilities for i/o operations in djatoka
 * @author Ryan Chute
 *
 */
public class IOUtils {
	
	public static File createTempTiff(String input) throws Exception {
		ImagePlus imp = new ImageJReader().getImagePlus(input);
		File tmp = File.createTempFile("tmp", ".tif");
		new FileSaver(imp).saveAsTiff(tmp.getAbsolutePath());
		return tmp;
	}
	
	public static File createTempImage(InputStream input) {
		File output = null;
    	OutputStream out = null;
        try {
        	output = File.createTempFile("tmp", ".img");
        	output.deleteOnExit();
        	out = new BufferedOutputStream(new FileOutputStream(output));
        	copyStream(input, out);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (out != null)
                    try {
                        out.close();
                    } catch (Exception e) {
                    }
        }
		return output;
	}
	
	public static File createTempTiff(BufferedImage bi) throws Exception {
		TIFWriter w = new TIFWriter();
		File f = File.createTempFile("tmp", ".tif");
		FileOutputStream fos = new FileOutputStream(f);
		BufferedOutputStream bos = new BufferedOutputStream(fos);
		w.write(bi, bos);
		bos.close();
		return f;
	}
	
    public static InputStream getInputStream(URL location) throws Exception {
        InputStream in;
        try {
            HttpURLConnection huc = (HttpURLConnection) (location.openConnection());
            int code = huc.getResponseCode();
            if (code == 200) {
                in = huc.getInputStream();
            } else
                throw new Exception("Cannot get " + location.toString());
        } catch (MalformedURLException e) {
            throw new Exception("A MalformedURLException occurred for " + location.toString());
        } catch (IOException e) {
            throw new Exception("An IOException occurred attempting to connect to " + location.toString());
        }
        return in;
    }
    
    public static OutputStream getOutputStream(URL location) throws Exception {
        return getOutputStream(getInputStream(location));    
    }
    
    public static OutputStream getOutputStream(InputStream ins) throws java.io.IOException, Exception {
        return getOutputStream(ins, 4096);
    }
    
    public static OutputStream getOutputStream(InputStream ins, int bufferSize) throws java.io.IOException, Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[bufferSize];
        int count = 0; 
        BufferedInputStream bis = new BufferedInputStream(ins);
        while  ((count = bis.read(buffer)) != -1) {
                    baos.write(buffer, 0, count);
        } 
        baos.close();
        return baos;
    }
    
    public static boolean copyFile(File src, File dest) {
        InputStream in = null;
        OutputStream out = null;
        byte[] buf = null;
        int bufLen = 20000 * 1024;
        try {
            in = new BufferedInputStream(new FileInputStream(src));
            out = new BufferedOutputStream(new FileOutputStream(dest));
            buf = new byte[bufLen];
            byte[] tmp = null;
            int len = 0;
            while ((len = in.read(buf, 0, bufLen)) != -1) {
                tmp = new byte[len];
                System.arraycopy(buf, 0, tmp, 0, len);
                out.write(tmp);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (in != null)
                try {
                    in.close();
                } catch (Exception e) {
                }
            if (out != null)
                    try {
                        out.close();
                    } catch (Exception e) {
                    }
        }
        return true;
    }
    
    public static boolean copyStream(InputStream src, OutputStream dest) {
    	InputStream in = null;
    	OutputStream out = null;
    	byte[] buf = null;
        int bufLen = 20000 * 1024;
        try {
            in = new BufferedInputStream(src);
            out = new BufferedOutputStream(dest);
            buf = new byte[bufLen];
            byte[] tmp = null;
            int len = 0;
            while ((len = in.read(buf, 0, bufLen)) != -1) {
                tmp = new byte[len];
                System.arraycopy(buf, 0, tmp, 0, len);
                out.write(tmp);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (in != null)
                try {
                    in.close();
                } catch (Exception e) {
                }
            if (out != null)
                    try {
                        out.close();
                    } catch (Exception e) {
                    }
        }
        return true;
    }
    
    public static byte[] getByteArray(InputStream ins) throws java.io.IOException, Exception {
        return ((ByteArrayOutputStream) getOutputStream(ins)).toByteArray();
    }
    
	public static Properties loadConfigByPath(String path) throws Exception {
		FileInputStream fi = new FileInputStream(path);
		return loadProperty(fi);
	}

	public static Properties loadProperty(InputStream in) throws IOException {
		Properties prop;
		try {
			prop = new java.util.Properties();
			prop.load(in);
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (Exception ex) {
				}
			}
		}
		return prop;
	}

	public static byte[] getBytesFromFile(File file) throws IOException {
	    InputStream is = new FileInputStream(file);
	
	    // Get the size of the file
	    long length = file.length();
	
	    byte[] bytes = new byte[(int)length];
	
	    int offset = 0;
	    int numRead = 0;
	    while (offset < bytes.length
	           && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
	        offset += numRead;
	    }
	    
	    if (offset < bytes.length) {
	        throw new IOException("Could not completely read file "+file.getName());
	    }
	
	    is.close();
	    return bytes;
	}
	
    public static Properties loadConfigByCP(String name) throws Exception {

        // Get our class loader
        ClassLoader cl = IOUtils.class.getClassLoader();

        // Attempt to open an input stream to the configuration file.
        // The configuration file is considered to be a system
        // resource.
        java.io.InputStream in;

        if (cl != null) {
            in = cl.getResourceAsStream(name);
        } else {
            in = ClassLoader.getSystemResourceAsStream(name);
        }

        // If the input stream is null, then the configuration file
        // was not found
        if (in == null) {
            throw new Exception("configuration file '" + name + "' not found");
        } else {
            return loadProperty(in);
        }

    }
}
