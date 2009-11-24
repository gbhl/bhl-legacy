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

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.PosixParser;

import gov.lanl.adore.djatoka.kdu.KduExtractExe;

/**
 * Extraction Application
 * @author Ryan Chute
 *
 */
public class DjatokaExtract {
	
	/**
	 * Uses apache commons cli to parse input args. Passes parsed
	 * parameters to IExtract implementation.
	 * @param args command line parameters to defined input,output,etc.
	 */
	public static void main(String[] args) {
		// create the command line parser
		CommandLineParser parser = new PosixParser();

		// create the Options
		Options options = new Options();
		options.addOption( "i", "input", true, "Filepath of the input file." );
		options.addOption( "o", "output", true, "Filepath of the output file." );
		options.addOption( "l", "level", true, "Resolution level to extract." );
		options.addOption( "d", "reduce", true, "Resolution levels to subtract from max resolution." );
		options.addOption( "r", "region", true, "Format: Y,X,H,W. " );
		options.addOption( "t", "rotate", true, "Number of degrees to rotate image (i.e. 90, 180, 270)." );
		options.addOption( "f", "format", true, "Mimetype of the image format to be provided as response. Default: image/jpeg" );
		options.addOption( "a", "AltImpl", true, "Alternate IExtract Implemenation" );
		
		try {
			if (args.length == 0) {
				HelpFormatter formatter = new HelpFormatter();
				formatter.printHelp("gov.lanl.adore.djatoka.DjatokaExtract", options);
				System.exit(0);
			}
			
		    // parse the command line arguments
		    CommandLine line = parser.parse(options, args);
		    String input = line.getOptionValue("i");
		    String output = line.getOptionValue("o");
		    
		    DjatokaDecodeParam p = new DjatokaDecodeParam();
		    String level = line.getOptionValue("l");
		    if (level != null)
		    	p.setLevel(Integer.parseInt(level));
		    String reduce = line.getOptionValue("d");
		    if (level == null && reduce != null)
		    	p.setLevelReductionFactor(Integer.parseInt(reduce));
		    String region = line.getOptionValue("r");
		    if (region != null)
		    	p.setRegion(region);
		    String rotate = line.getOptionValue("t");
		    if (rotate != null)
		    	p.setRotationDegree(Integer.parseInt(rotate));
		    String format = line.getOptionValue("f");
		    if (format == null)
		    	format = "image/jpeg";
		    String alt = line.getOptionValue("a");
		    if(output == null)
		    	output = input + ".jpg";
		    
			long x = System.currentTimeMillis();
			IExtract ex = new KduExtractExe();
			if (alt != null)
				ex = (IExtract) Class.forName(alt).newInstance();
			DjatokaExtractProcessor e = new DjatokaExtractProcessor(ex);
			e.extractImage(input, output, p, format);
			System.out.println("Extraction Time: " + ((double) (System.currentTimeMillis() - x) / 1000) + " seconds");
		    
		} catch( ParseException e ) {
		    System.out.println( "Parse exception:" + e.getMessage() );
		} catch (DjatokaException e) {
			System.out.println( "djatoka Extraction exception:" + e.getMessage() );
		} catch (InstantiationException e) {
			System.out.println( "Unable to initialize alternate implemenation:" + e.getMessage() );
		} catch (Exception e) {
			System.out.println( "Unexpected exception:" + e.getMessage() );
		}
	}
}
