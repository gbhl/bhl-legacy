package at.co.ait.domain.integration;

import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Map;

import org.codehaus.jackson.JsonFactory;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * ArchivingQueue contains all generated and ready-to-be ingested AIPs.
 * @author sprogerb
 *
 */
public class ArchivingQueue extends ArrayList<Map<String,String>> {
	
	private static final long serialVersionUID = 1L;

	private static final Logger logger = LoggerFactory.getLogger(ArchivingQueue.class);

    private ObjectMapper m = new ObjectMapper();
    private JsonFactory jf = new JsonFactory();
    
    
    /**
     * Returns a JSON formatted String representation of the current class.
     * @param prettyPrint
     * @return
     */
    public String toJson(boolean prettyPrint) {
        StringWriter sw = new StringWriter();
        JsonGenerator jg = null;
		try {
			jg = jf.createJsonGenerator(sw);
		} catch (IOException e) {
			logger.error("IO Error during attaching StringWriter to JSONGenerator");			
		}
        if (prettyPrint) {
            jg.useDefaultPrettyPrinter();
        }
        try {
			m.writeValue(jg, this);
		} catch (JsonGenerationException e) {
			logger.error("Couldn't created JSON");
		} catch (JsonMappingException e) {
			logger.error("Couldn't map to JSON");
			e.printStackTrace();
		} catch (IOException e) {
			logger.error("IO Error while writing JSON into StringWriter");
			e.printStackTrace();
		}
        return sw.toString();
    }
}