package at.co.ait.domain.services;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import at.co.ait.domain.integration.IReqVirusscanGateway;
import at.co.ait.domain.oais.DigitalObject;

public class VirusscanService {
	private static final Logger logger = LoggerFactory
			.getLogger(VirusscanService.class);

	private IReqVirusscanGateway virusscanGateway;

	@Resource(name = "virusscanRequestGateway")
	public void setVirusscanGateway(IReqVirusscanGateway virusscanGateway) {
		this.virusscanGateway = virusscanGateway;
	}

	public DigitalObject scan(DigitalObject obj) {
		// send virusscan request to PyClamAVStomp
		String virusscanResponse = null;
		try 
		{
			// TODO use urlencode. base64 was used due to
			// insane application/x-www-form-urlencoded python
			// implementation
			String encodedText = new String(Base64.encodeBase64(obj
					.getSubmittedFile().getAbsolutePath().getBytes()));
			virusscanResponse = virusscanGateway.requestVirusscan(encodedText)
					.get(1, TimeUnit.SECONDS);
		} 
		catch (InterruptedException e) 
		{
			logger.debug(e.getClass().getName() + ":" + e.getMessage());
		} 
		catch (ExecutionException e) 
		{
			logger.debug(e.getClass().getName() + ":" + e.getMessage());
		} 
		catch (TimeoutException e) 
		{
			logger.debug(e.getClass().getName() + ":" + e.getMessage());
		}
		finally
		{
			if (virusscanResponse==null) virusscanResponse="ERROR";
		}
		obj.setVirusscanResult(virusscanResponse);
		return obj;
	}
}
