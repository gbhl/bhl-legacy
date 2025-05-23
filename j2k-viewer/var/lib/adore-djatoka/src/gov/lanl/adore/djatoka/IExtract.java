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

package gov.lanl.adore.djatoka;

import java.awt.image.BufferedImage;
import java.io.InputStream;

/**
 * Abstract extraction interface. Allows use of common input method
 * (e.g. String path, InputStream). The underlying implementations are 
 * responsible for handling a file path or InputStream and returning 
 * a BufferedImage.
 * @author Ryan Chute
 *
 */
public interface IExtract {

	/**
	 * Extracts region defined in DjatokaDecodeParam as BufferedImage
	 * @param input InputStream containing a JPEG 2000 image bitstream.
	 * @param params DjatokaDecodeParam instance containing region and transform settings.
	 * @return extracted region as a BufferedImage
	 * @throws DjatokaException
	 */
	public BufferedImage process(InputStream input, DjatokaDecodeParam params) throws DjatokaException;
	
	/**
	 * Extracts region defined in DjatokaDecodeParam as BufferedImage
	 * @param input absolute file path of JPEG 2000 image file.
	 * @param params DjatokaDecodeParam instance containing region and transform settings.
	 * @return extracted region as a BufferedImage
	 * @throws DjatokaException
	 */
	public BufferedImage process(String input, DjatokaDecodeParam params) throws DjatokaException;

	/**
	 * Returns JPEG 2000 width, height, resolution levels in Integer[]
	 * 		int[0] = Image Width;
	 *		int[1] = Image Height;
     *		int[2] = Number of Resolution Levels;
	 * @param input absolute file path of JPEG 2000 image file.
	 * @return width,height,DWT levels of image
	 * @throws DjatokaException
	 */
	public Integer[] getMetadata(String input) throws DjatokaException;

}