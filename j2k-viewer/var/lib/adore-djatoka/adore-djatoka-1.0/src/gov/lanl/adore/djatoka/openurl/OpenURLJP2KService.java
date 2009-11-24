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

import gov.lanl.adore.djatoka.DjatokaDecodeParam;
import gov.lanl.adore.djatoka.DjatokaExtractProcessor;
import gov.lanl.adore.djatoka.io.FormatConstants;
import gov.lanl.adore.djatoka.kdu.KduExtractExe;
import gov.lanl.adore.djatoka.plugin.ITransformPlugIn;
import gov.lanl.adore.djatoka.util.IOUtils;
import gov.lanl.adore.djatoka.util.ImageRecord;
import gov.lanl.util.HttpDate;
import info.openurl.oom.ContextObject;
import info.openurl.oom.OpenURLRequest;
import info.openurl.oom.OpenURLRequestProcessor;
import info.openurl.oom.OpenURLResponse;
import info.openurl.oom.Service;
import info.openurl.oom.config.ClassConfig;
import info.openurl.oom.config.OpenURLConfig;
import info.openurl.oom.entities.ServiceType;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Properties;

import javax.servlet.http.HttpServletResponse;

import org.oclc.oomRef.descriptors.ByValueMetadataImpl;

/**
 * The OpenURLJP2KService OpenURL Service
 * 
 * @author Ryan Chute
 */
public class OpenURLJP2KService implements Service, FormatConstants {
    private static final String DEFAULT_IMPL_CLASS = SimpleListResolver.class.getCanonicalName();
    private static final String PROPS_REQUESTER = "requester";
    private static final String PROPS_REFERRING_ENTITY = "referringEntity";
    private static final String PROPS_KEY_IMPL_CLASS = "OpenURLJP2KService.referentResolverImpl";
    private static final String PROPS_KEY_CACHE_ENABLED = "OpenURLJP2KService.cacheEnabled";
    private static final String PROPS_KEY_CACHE_TMPDIR = "OpenURLJP2KService.cacheTmpDir";
    private static final String PROPS_KEY_TRANSFORM = "OpenURLJP2KService.transformPlugin";
    private static final String PROPS_KEY_CACHE_SIZE = "OpenURLJP2KService.cacheSize";
    private static final String PROP_KEY_CACHE_MAX_PIXELS = "OpenURLJP2KService.cacheImageMaxPixels";
	private static final String SVC_ID = "info:lanl-repo/svc/getRegion";
	private static final String DEFAULT_CACHE_SIZE = "1000";
	private static final int DEFAULT_CACHE_MAXPIXELS = 100000;

	private static String implClass = null;
	private static IReferentResolver referentResolver;
	private static Properties props  = new Properties();
	private static boolean init = false;
	private static boolean cacheTiles = true;
	private static boolean transformCheck = false;
	private static ITransformPlugIn transform;
	private static String cacheDir = null;
	private static TileCacheManager<String, String> tileCache;
	private static DjatokaExtractProcessor extractor;
	private static int maxPixels = DEFAULT_CACHE_MAXPIXELS;
	
	/**
	 * Construct an info:lanl-repo/svc/getRegion web service class. Initializes 
	 * Referent Resolver instance using OpenURLJP2KService.referentResolverImpl property.
	 * 
	 * @param openURLConfig OOM Properties forwarded from OpenURLServlet
	 * @param classConfig Implementation Properties forwarded from OpenURLServlet
	 * @throws ResolverException 
	 */
	public OpenURLJP2KService(OpenURLConfig openURLConfig, ClassConfig classConfig) throws ResolverException {
        try {
        	if (!init) {
                props = IOUtils.loadConfigByCP(classConfig.getArg("props"));
                implClass = props.getProperty(PROPS_KEY_IMPL_CLASS,DEFAULT_IMPL_CLASS);
                referentResolver = (IReferentResolver) Class.forName(implClass).newInstance();
                
                cacheDir = props.getProperty(PROPS_KEY_CACHE_TMPDIR);
                if (props.getProperty(PROPS_KEY_CACHE_ENABLED) != null) 
                	cacheTiles = Boolean.parseBoolean(props.getProperty(PROPS_KEY_CACHE_ENABLED));
                if (cacheTiles) {
                	int cacheSize = Integer.parseInt(props.getProperty(PROPS_KEY_CACHE_SIZE,DEFAULT_CACHE_SIZE));
                    tileCache = new TileCacheManager<String, String>(cacheSize);
                }
                if (props.getProperty(PROPS_KEY_TRANSFORM) != null) {
                	transformCheck = true;
                	String transClass = props.getProperty(PROPS_KEY_TRANSFORM);
                	transform = (ITransformPlugIn) Class.forName(transClass).newInstance();
                	transform.setup(props);
                }
                if (props.getProperty(PROP_KEY_CACHE_MAX_PIXELS) != null)
                	maxPixels = Integer.parseInt(props.getProperty(PROP_KEY_CACHE_MAX_PIXELS));
                extractor = new DjatokaExtractProcessor(new KduExtractExe());
                init = true;
                if (referentResolver != null)
                	referentResolver.setProperties(props);
                else
            	    throw new ResolverException("Unable to inititalize implementation: " + props.getProperty(implClass));
        	}
        } catch (IOException e) {
            throw new ResolverException("Error attempting to open props file from classpath, disabling " + SVC_ID + " : " + e.getMessage());
        } catch (Exception e) {
        	throw new ResolverException("Unable to inititalize implementation: " + props.getProperty(implClass) + " - " + e.getMessage());
		}
	}

	/**
	 * Returns the OpenURL service identifier for this implementation of
	 * info.openurl.oom.Service
	 */
	public URI getServiceID() throws URISyntaxException {
		return new URI(SVC_ID);
	}

	/**
	 * Returns the OpenURLResponse consisting of an image bitstream to be
	 * rendered on the client. Having obtained a result, this method is then
	 * responsible for transforming it into an OpenURLResponse that acts as a
	 * proxy for HttpServletResponse.
	 */
	public OpenURLResponse resolve(ServiceType serviceType,
			ContextObject contextObject, OpenURLRequest openURLRequest,
			OpenURLRequestProcessor processor) {

		String responseFormat = null;
		String format = "image/jpeg";
		int status = HttpServletResponse.SC_OK;
		HashMap<String, String> kev = setServiceValues(contextObject);
		DjatokaDecodeParam params = new DjatokaDecodeParam();
		if (kev.containsKey("region"))
			params.setRegion(kev.get("region"));		
		if (kev.containsKey("format")) {
			format = kev.get("format");
			if (!format.startsWith("image")) {
				//ignoring invalid format identifier
				format = "image/jpeg";
			}
		}
        if (kev.containsKey("level"))
			params.setLevel(Integer.parseInt(kev.get("level")));
		if (kev.containsKey("rotate"))
			params.setRotationDegree(Integer.parseInt(kev.get("rotate")));
		responseFormat = format;

		byte[] bytes = null;
		if (responseFormat == null) {
			try {
				bytes = ("Output Format Not Supported").getBytes("UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			} 
			responseFormat = "text/plain";
			status = HttpServletResponse.SC_NOT_FOUND;
		} else if (params.getRegion() != null && params.getRegion().contains("-")) {
			try {
				bytes = ("Negative Region Arguments are not supported.").getBytes("UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			} 
			responseFormat = "text/plain";
			status = HttpServletResponse.SC_NOT_FOUND;
		} else {
			try {
				ImageRecord r = referentResolver.getImageRecord(contextObject.getReferent());
				if (transformCheck && transform != null) {
					HashMap<String, String> instProps = new HashMap<String, String>();
				    if (r.getInstProps() != null)
				    	instProps.putAll(r.getInstProps());
					if (contextObject.getRequesters().length > 0 && contextObject.getRequesters()[0].getDescriptors().length > 0)
					    instProps.put(PROPS_REQUESTER, contextObject.getRequesters()[0].getDescriptors()[0].toString());
				    if (contextObject.getReferringEntities().length > 0 && contextObject.getReferringEntities()[0].getDescriptors().length > 0)
					    instProps.put(PROPS_REFERRING_ENTITY, contextObject.getReferringEntities()[0].getDescriptors()[0].toString());
					if (instProps.size() > 0)
					    transform.setInstanceProps(instProps);
					params.setTransform(transform);	
				}
				if (!cacheTiles || !isCacheable(params)) {
					ByteArrayOutputStream baos = new ByteArrayOutputStream();
					extractor.extractImage(r.getImageFile(), baos, params, format);
				    bytes = baos.toByteArray();
				    baos.close();
				} else {
					String hash = getTileHash(r.getIdentifier(), params.getLevel(), params.getRegion(), params.getRotationDegree());
					String file = null;
					if ((file = tileCache.get(hash)) == null) {
						File f;
						if (cacheDir != null)
							f = File.createTempFile("cache" + hash.hashCode() + "-", ".jpg", new File(cacheDir));
						else
						    f = File.createTempFile("cache" + hash.hashCode() + "-", ".jpg");
						f.deleteOnExit();
						file = f.getAbsolutePath();
						extractor.extractImage(r.getImageFile(), file, params, format);
						bytes = IOUtils.getBytesFromFile(f);
						tileCache.put(hash, file);
					} else {
						bytes = IOUtils.getBytesFromFile(new File(file));
					}
				}
			} catch (Exception e) {
				try {
					bytes = e.getMessage().getBytes("UTF-8");
				} catch (UnsupportedEncodingException e1) {
					e1.printStackTrace();
				}
				responseFormat = "text/plain";
				status = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
			}
		}
		HashMap<String, String> header_map = new HashMap<String, String>();
		header_map.put("Content-Length", bytes.length + "");
		header_map.put("Date", HttpDate.getHttpDate());
		return new OpenURLResponse(status, responseFormat, bytes, header_map);
	}
	
	private boolean isCacheable(DjatokaDecodeParam params) {
		if (transformCheck && params.getTransform().isTransformable())
			return false;
		if (params.getRegion() != null) {
			String[] r = params.getRegion().split(",");
			if (r.length == 4) {
				int h = Integer.parseInt(r[2]);
				int w = Integer.parseInt(r[3]);
				if ((h * w) >= maxPixels)
					return false;
			}	
		}
			
		return true;
	}
	
	private static final String getTileHash(String rft_id, int level, String region, int rotateDegree) throws Exception {
		rft_id = rft_id + level + region + rotateDegree; 
	    MessageDigest complete = MessageDigest.getInstance("SHA1");
		return new String(complete.digest(rft_id.getBytes()));
    }
	
    private static HashMap<String, String> setServiceValues(ContextObject co) {
		HashMap<String, String> map = new HashMap<String, String>();
		Object[] svcData = (Object[]) co.getServiceTypes()[0].getDescriptors();
		if (svcData != null && svcData.length > 0) {
			for (int i = 0; i < svcData.length; i++) {
				Object tmp = svcData[i];
				if (tmp.getClass().getSimpleName().equals("ByValueMetadataImpl")) {
					ByValueMetadataImpl kev = ((ByValueMetadataImpl) tmp);
					if (kev.getFieldMap().size() > 0) {
						if (kev.getFieldMap().containsKey("svc.region")
								&& ((String[]) kev.getFieldMap().get(
										"svc.region"))[0] != "")
							map.put("region", ((String[]) kev.getFieldMap()
									.get("svc.region"))[0]);
						if (kev.getFieldMap().containsKey("svc.format")
								&& ((String[]) kev.getFieldMap().get(
										"svc.format"))[0] != "")
							map.put("format", ((String[]) kev.getFieldMap()
									.get("svc.format"))[0]);
						if (kev.getFieldMap().containsKey("svc.level")
								&& ((String[]) kev.getFieldMap().get(
										"svc.level"))[0] != "")
							map.put("level", ((String[]) kev.getFieldMap()
									.get("svc.level"))[0]);
						if (kev.getFieldMap().containsKey("svc.rotate")
								&& ((String[]) kev.getFieldMap().get(
										"svc.rotate"))[0] != "")
							map.put("rotate", ((String[]) kev.getFieldMap()
									.get("svc.rotate"))[0]);
					}
				}
			}
		}
		return map;
	}
}
