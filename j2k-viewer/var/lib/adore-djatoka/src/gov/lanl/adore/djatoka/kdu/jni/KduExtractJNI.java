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

package gov.lanl.adore.djatoka.kdu.jni;

import gov.lanl.adore.djatoka.DjatokaDecodeParam;
import gov.lanl.adore.djatoka.DjatokaException;
import gov.lanl.adore.djatoka.IExtract;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.InputStream;

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
 * Uses Kakadu Java Native Interface to extract JP2 regions.  
 * This is modified port of the kdu_expand app.
 * @author Ryan Chute
 *
 */
public class KduExtractJNI implements IExtract {

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

	/**
	 * Extracts region defined in DjatokaDecodeParam as BufferedImage
	 * @param input absolute file path of JPEG 2000 image file.
	 * @param params DjatokaDecodeParam instance containing region and transform settings.
	 * @return extracted region as a BufferedImage
	 * @throws DjatokaException
	 */
	public BufferedImage process(String input, DjatokaDecodeParam params)
			throws DjatokaException {
		KduExtractProcessorJNI decoder = new KduExtractProcessorJNI(input, params);
		return decoder.extract();
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
		KduExtractProcessorJNI decoder = new KduExtractProcessorJNI(input, params);
		return decoder.extract();
	}
}
