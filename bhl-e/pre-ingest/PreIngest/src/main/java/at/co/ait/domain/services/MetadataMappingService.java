package at.co.ait.domain.services;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.domain.integration.IReqDescrMappingGateway;
import at.co.ait.domain.oais.DigitalObject;

public class MetadataMappingService {
	
	private static final Logger logger = LoggerFactory.getLogger(MetadataMappingService.class);
	private IReqDescrMappingGateway descrMappingGateway;
	
	@Resource(name="descrMappingGateway")
	public void setDescrMappingGateway(IReqDescrMappingGateway descrMappingGateway) {
		this.descrMappingGateway = descrMappingGateway;
	}
	
    /**
     * Enriches the digtal object by adding descriptive metadata
     * @param obj DigitalObject is getting enriched by descriptive metadata.
     * @return
     */
    public DigitalObject map(DigitalObject obj) {
		String metadata = null; 
    	try {
    		// TODO read the config string out of User preferences
    		String params = "-m c -cm 5 -if ";
    		logger.info("initiate the descr metadata mapper");
    		params += obj.getSubmittedFile().getAbsolutePath();
    		logger.info(params);
    		params = new String(Base64.encodeBase64(params.getBytes()));
			metadata = descrMappingGateway.requestDescrMapping(
					params).get(1, TimeUnit.SECONDS);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TimeoutException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	obj.setDescrMappedMetadata(metadata);
    	return obj;
    }

}
