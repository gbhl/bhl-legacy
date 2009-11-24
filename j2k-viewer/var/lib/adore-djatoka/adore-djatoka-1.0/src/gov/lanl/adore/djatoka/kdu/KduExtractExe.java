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

package gov.lanl.adore.djatoka.kdu;

import gov.lanl.adore.djatoka.DjatokaDecodeParam;
import gov.lanl.adore.djatoka.DjatokaException;
import gov.lanl.adore.djatoka.IExtract;
import gov.lanl.adore.djatoka.io.reader.ImageJReader;
import gov.lanl.adore.djatoka.io.reader.PNMReader;
import gov.lanl.adore.djatoka.util.IOUtils;
import gov.lanl.adore.djatoka.util.ImageProcessingUtils;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.StringTokenizer;

import kdu_jni.Jp2_family_src;
import kdu_jni.Jp2_locator;
import kdu_jni.Jp2_source;
import kdu_jni.KduException;
import kdu_jni.Kdu_channel_mapping;
import kdu_jni.Kdu_codestream;
import kdu_jni.Kdu_compressed_source;
import kdu_jni.Kdu_coords;
import kdu_jni.Kdu_dims;

/**
 * Java bridge for kdu_expand application
 * @author Ryan Chute
 *
 */
public class KduExtractExe implements IExtract {
	private static boolean isWindows = false;
	private static String env;
	private static String exe;
	private static String[] envParams;
	/** Extract App Name "kdu_expand" */
	public static final String KDU_EXPAND_EXE = "kdu_expand";
	/** UNIX/Linux Standard Out Path: "/dev/stdout" */
	public static String STDOUT = "/dev/stdout";

	private static final String escape(String path) {
		if (path.contains(" "))
			path = "\"" + path + "\"";
		return path;
	}

	static {
		env = System.getProperty("kakadu.home")
				+ System.getProperty("file.separator");
		exe = env
				+ ((System.getProperty("os.name").contains("Win")) ? KDU_EXPAND_EXE
						+ ".exe"
						: KDU_EXPAND_EXE);
		if (System.getProperty("os.name").startsWith("Mac")) {
			envParams = new String[] { "DYLD_LIBRARY_PATH="
					+ System.getProperty("DYLD_LIBRARY_PATH") };
		} else if (System.getProperty("os.name").startsWith("Win")) {
			isWindows = true;
		} else if (System.getProperty("os.name").startsWith("Linux")) {
			envParams = new String[] { "LD_LIBRARY_PATH="
					+ System.getProperty("LD_LIBRARY_PATH") };
		} else if (System.getProperty("os.name").startsWith("Solaris")) {
			envParams = new String[] { "LD_LIBRARY_PATH="
					+ System.getProperty("LD_LIBRARY_PATH") };
		}
	}

	/**
	 * Extracts region defined in DjatokaDecodeParam as BufferedImage
	 * @param input InputStream containing a JPEG 2000 image bitstream.
	 * @param params DjatokaDecodeParam instance containing region and transform settings.
	 * @return extracted region as a BufferedImage
	 * @throws DjatokaException
	 */
	public BufferedImage process(InputStream input, DjatokaDecodeParam params)
	        throws DjatokaException {
		File in;
		// Copy to tmp file
		try {
			in = File.createTempFile("tmp", ".jp2");
			FileOutputStream fos = new FileOutputStream(in);
			in.deleteOnExit();
			IOUtils.copyStream(input, fos);
		} catch (IOException e) {
			throw new DjatokaException(e);
		}
		
		BufferedImage bi = process(in.getAbsolutePath(), params);
		
		if (in != null)
			in.delete();
		
		return bi;
	}

	/**
	 * Extracts region defined in DjatokaDecodeParam as BufferedImage
	 * @param input absolute file path of JPEG 2000 image file.
	 * @param params DjatokaDecodeParam instance containing region and transform settings.
	 * @return extracted region as a BufferedImage
	 * @throws DjatokaException
	 */
	public BufferedImage process(String input, DjatokaDecodeParam params)
			throws DjatokaException {
		String output = STDOUT;
		File winOut = null;
		if (isWindows) {
			try {
				winOut = File.createTempFile("pipe_", ".ppm");
				winOut.deleteOnExit();
			} catch (IOException e) {
				throw new DjatokaException(e);
			}
			output = winOut.getAbsolutePath();
		}
		Runtime rt = Runtime.getRuntime();
		try {
			ArrayList<Double> dims = getRegionMetadata(input, params);
			String command = getKduCompressCommand(input, output, dims, params);
			Process process = rt.exec(command, envParams, new File(env));
			
			if (output != null) {
				try {
					if (output.equals(STDOUT)) {
						return new PNMReader().open(new BufferedInputStream(
								process.getInputStream()));
					} else if (isWindows) {
						// Windows tests indicated need for delay (< 100ms failed)
						Thread.sleep(100);
						BufferedImage bi = null;
						try {
							bi = new PNMReader().open(new BufferedInputStream(new FileInputStream(new File(output))));
						} catch (Exception e) {
						    if (winOut != null)
								winOut.delete();
						    throw e;
						}
						if (winOut != null)
							winOut.delete();
						return bi;
				    } 
				} catch (Exception e) {
					e.printStackTrace();
					throw new DjatokaException(e);
				} 
			}
		} catch (IOException e) {
			e.printStackTrace();
		} 
		return null;
	}

	/**
	 * 
	 * @param input absolute file path of JPEG 2000 image file.
	 * @param output absolute file path of PGM output image
	 * @param dims array of region parameters (i.e. y,x,h,w)
	 * @param params contains rotate and level extraction information
	 * @return command line string to extract region using kdu_extract
	 */
	public final String getKduCompressCommand(String input, String output,
			ArrayList<Double> dims, DjatokaDecodeParam params) {
		StringBuffer command = new StringBuffer(exe);
		command.append(" -quiet -i ").append(escape(new File(input).getAbsolutePath()));
		command.append(" -o ").append(escape(new File(output).getAbsolutePath()));
		command.append(" ").append(toKduCompressArgs(params));
		if (dims != null && dims.size() == 4) {
			StringBuffer region = new StringBuffer();
			region.append("{").append(dims.get(0)).append(",").append(
					dims.get(1)).append("}").append(",");
			region.append("{").append(dims.get(2)).append(",").append(
					dims.get(3)).append("}");
			command.append("-region ").append(region.toString()).append(" ");
		}
		return command.toString();
	}

	/**
	 * Returns JPEG 2000 width, height, resolution levels in Integer[]
	 * 		int[0] = Image Width;
	 *		int[1] = Image Height;
     *		int[2] = Number of Resolution Levels;
	 * @param input absolute file path of JPEG 2000 image file.
	 * @return width,height,DWT levels of image
	 * @throws DjatokaException
	 */
	public final Integer[] getMetadata(String input) throws DjatokaException {
		if (!new File(input).exists())
			throw new DjatokaException("Image Does Not Exist");
		if (!checkIfJp2(input))
			throw new DjatokaException("Not a JP2 image.");
		
		Jp2_source inputSource = new Jp2_source();
		Kdu_compressed_source kduIn = null;
		Jp2_family_src jp2_family_in = new Jp2_family_src();
		Jp2_locator loc = new Jp2_locator();
		Integer[] dims = new Integer[3];
		try {
			jp2_family_in.Open(input, true);
			inputSource.Open(jp2_family_in, loc);
			inputSource.Read_header();
			kduIn = inputSource;
			Kdu_codestream codestream = new Kdu_codestream();
			codestream.Create(kduIn);
			Kdu_channel_mapping channels = new Kdu_channel_mapping();
			if (inputSource.Exists())
				channels.Configure(inputSource, false);
			else
				channels.Configure(codestream);
			int ref_component = channels.Get_source_component(0);
			int minLevels = codestream.Get_min_dwt_levels();
			Kdu_dims image_dims = new Kdu_dims();
			codestream.Get_dims(ref_component, image_dims);
			Kdu_coords imageSize = image_dims.Access_size();

			dims[0] = imageSize.Get_x();
			dims[1] = imageSize.Get_y();
			dims[2] = minLevels;

			channels.Native_destroy();
			if (codestream.Exists())
				codestream.Destroy();
			kduIn.Native_destroy();
			inputSource.Native_destroy();
			jp2_family_in.Native_destroy();
		} catch (KduException e) {
			throw new DjatokaException(e);
		}

		return dims;
	}

	private final String magic = "000c6a502020da87a";
	private final boolean checkIfJp2(String input) {
    	InputStream in = null;
    	byte[] buf = new byte[12];
        try {
            in = new BufferedInputStream(new FileInputStream(new File(input)));
            in.read(buf, 0, 12);
        } catch (IOException e) {
                e.printStackTrace();
                return false;
        } 
	    StringBuffer sb = new StringBuffer(buf.length * 2);
	    for(int x = 0 ; x < buf.length ; x++) {
	       sb.append((Integer.toHexString(0xff & buf[x])));
	    }
	    String hexString = sb.toString();
	    return hexString.equals(magic);
	}
	
	private final ArrayList<Double> getRegionMetadata(String input, DjatokaDecodeParam params)
			throws DjatokaException {
		Integer[] d = getMetadata(input);

		if (params.getLevel() >= 0) {
			int levels = ImageProcessingUtils.getLevelCount(d[0], d[1]);
			levels = (d[2] < levels) ? d[2] : levels;
			int reduce = levels - params.getLevel();
			params.setLevelReductionFactor((reduce >= 0) ? reduce : 0);
		}

		int reduce = 1 << params.getLevelReductionFactor();
		ArrayList<Double> dims = new ArrayList<Double>();

		if (params.getRegion() != null) {
			StringTokenizer st = new StringTokenizer(params.getRegion(), "{},");
			String token;
			// top
			if ((token = st.nextToken()).contains("."))
				dims.add(Double.parseDouble(token));
			else
				dims.add(Double.parseDouble(token) / d[1]);
			// left
			if ((token = st.nextToken()).contains(".")) {
				dims.add(Double.parseDouble(token));
			} else
				dims.add(Double.parseDouble(token) / d[0]);
			// height
			if ((token = st.nextToken()).contains(".")) {
				dims.add(Double.parseDouble(token));
			} else
				dims.add(Double.parseDouble(token)
						/ (Double.valueOf(d[1]) / Double
								.valueOf(reduce)));
			// width
			if ((token = st.nextToken()).contains(".")) {
				dims.add(Double.parseDouble(token));
			} else
				dims.add(Double.parseDouble(token)
						/ (Double.valueOf(d[0]) / Double
								.valueOf(reduce)));
		}

		return dims;
	}
	
	private static String toKduCompressArgs(DjatokaDecodeParam params) {
		StringBuffer sb = new StringBuffer();
	    if (params.getLevelReductionFactor() > 0)
	        sb.append("-reduce ").append(params.getLevelReductionFactor()).append(" ");
	    if (params.getRotationDegree() > 0)
	    	sb.append("-rotate ").append(params.getRotationDegree()).append(" ");
		return sb.toString();
	}
}
