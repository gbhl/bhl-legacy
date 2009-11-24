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

import java.util.HashMap;

/**
 * Image Record Metadata. Used to transfer image properties.
 * @author Ryan Chute
 *
 */
public class ImageRecord {
	private String identifier;
	private String imageFile;
	private int width;
	private int height;
	private int levels;
	private HashMap<String, String> instProps;
	
	/**
	 * Default Constructor
	 */
	public ImageRecord(){};
	
	/**
	 * Constructor used to prime imageFile value
	 * @param imageFile the absolute file path of the image
	 */
	public ImageRecord(String imageFile) {
		this.imageFile = imageFile;
	}
	
	/**
	 * Constructor used to prime identifier and imageFile value
	 * @param identifier unique identifier of image
	 * @param imageFile the absolute file path of the image
	 */
	public ImageRecord(String identifier, String imageFile) {
		this.identifier = identifier;
		this.imageFile = imageFile;
	}
	
	/**
	 * Returns the unique identifier of image
	 * @return unique identifier of image
	 */
	public String getIdentifier() {
		return identifier;
	}
	
	/**
	 * Sets the unique identifier of image
	 * @param identifier unique identifier of image
	 */
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
	
	/**
	 * Returns the absolute file path of the image
	 * @return the absolute file path of the image
	 */
	public String getImageFile() {
		return imageFile;
	}
	
	/**
	 * Returns the absolute file path of the image
	 * @param imageFile the absolute file path of the image
	 */
	public void setImageFile(String imageFile) {
		this.imageFile = imageFile;
	}
	
	/**
	 * Returns the pixel width of the image
	 * @return the pixel width of the image
	 */
	public int getWidth() {
		return width;
	}
	
	/**
	 * Sets the pixel width of the image
	 * @param width the pixel width of the image
	 */
	public void setWidth(int width) {
		this.width = width;
	}
	
	/**
	 * Returns the pixel height of the image
	 * @return the pixel height of the image
	 */
	public int getHeight() {
		return height;
	}
	
	/**
	 * Sets the pixel height of the image
	 * @param height the pixel height of the image
	 */
	public void setHeight(int height) {
		this.height = height;
	}
	
	/**
	 * Returns the number of resolution levels
	 * @return the number of resolution levels
	 */
	public int getLevels() {
		return levels;
	}
	
	/**
	 * Sets the number of resolution levels
	 * @param levels the number of resolution levels
	 */
	public void setLevels(int levels) {
		this.levels = levels;
	}

	/**
	 * Returns a map of properties associated with the image. The properties may
	 * be used transformation processes down the line.
	 * @return a map of properties associated with the image. 
	 */
	public HashMap<String, String> getInstProps() {
		return instProps;
	}

	/**
	 * Sets a map of properties associated with the image. The properties may
	 * be used transformation processes down the line.
	 * @param instProps a map of properties associated with the image. 
	 */
	public void setInstProps(HashMap<String, String> instProps) {
		this.instProps = instProps;
	}
}
