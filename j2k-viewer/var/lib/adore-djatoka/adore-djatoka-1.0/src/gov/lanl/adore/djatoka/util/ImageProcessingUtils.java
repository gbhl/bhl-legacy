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

import java.awt.image.BufferedImage;

/**
 * Image Processing Utilities
 * @author Ryan Chute
 *
 */
public class ImageProcessingUtils {
	
    /**
     * Perform a rotation of the provided BufferedImage using degrees of
     * 90, 180, or 270.
     * @param bi BufferedImage to be rotated
     * @param degree 
     * @return rotated BufferedImage instance
     */
	public static BufferedImage rotate(BufferedImage bi, int degree) {
		int width = bi.getWidth();
		int height = bi.getHeight();

		BufferedImage biFlip;
		if (degree == 90 || degree == 270)
		    biFlip = new BufferedImage(height, width, bi.getType());
		else if (degree == 180)
			biFlip = new BufferedImage(width, height, bi.getType());
		else 
			return bi;

		if (degree == 90) {
			for (int i = 0; i < width; i++)
				for (int j = 0; j < height; j++)
					biFlip.setRGB(height- j - 1, i, bi.getRGB(i, j));
		}
		
		if (degree == 180) {
			for (int i = 0; i < width; i++)
				for (int j = 0; j < height; j++)
					biFlip.setRGB(width - i - 1, height - j - 1, bi.getRGB(i, j));
		}

		if (degree == 270) {
			for (int i = 0; i < width; i++)
				for (int j = 0; j < height; j++)
					biFlip.setRGB(j, width - i - 1, bi.getRGB(i, j));
		}
		
		bi.flush();
		bi = null;
		
		return biFlip;
	}
	
	/**
	 * Return the number of resolution levels the djatoka API will generate
	 * based on the provided pixel dimensions.
	 * @param w max pixel width
	 * @param h max pixel height
	 * @return number of resolution levels
	 */
	public static int getLevelCount(int w, int h) {
		int l = Math.max(w, h);
		int m = 96;
		int r = 0;
		int i;
		if (l > 0) {
			for (i = 1; l >= m; i++) {
				l = l / 2;
				r = i;
			}
		}
		return r;
	}
}
