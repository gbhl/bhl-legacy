package at.co.ait.web.common;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.oxm.Marshaller;
import org.springframework.oxm.Unmarshaller;

public class ConfigSerializer {	
	private static final Logger logger = LoggerFactory.getLogger(ConfigSerializer.class);
    private Settings settings;
	private Marshaller marshaller;
    private Unmarshaller unmarshaller;
    private Resource fileResource;
    private String filename;
    
    public void setFileResource(Resource resource) throws IOException {
		this.fileResource = resource;
		filename = resource.getFile().getAbsolutePath();
    	if(resource.getFile().exists()) {
			loadSettings();
    	}
	}

	public Settings getSettings() {
		return settings;
	}

	public void setSettings(Settings settings) {
		logger.info("setting Settings");
		this.settings = settings;
	}

    public void setMarshaller(Marshaller marshaller) {
        this.marshaller = marshaller;
    }

    public void setUnmarshaller(Unmarshaller unmarshaller) {
        this.unmarshaller = unmarshaller;
    }

    public void saveSettings() throws IOException {
        FileOutputStream os = null;
        try {
            os = new FileOutputStream(filename);
            this.marshaller.marshal(settings, new StreamResult(os));
        } finally {
            if (os != null) {
                os.close();
            }
        }
    }

    public void loadSettings() throws IOException {
        FileInputStream is = null;
        try {
            is = new FileInputStream(filename);
            this.settings = (Settings) this.unmarshaller.unmarshal(new StreamSource(is));
        } finally {
            if (is != null) {
                is.close();
            }
        }
    }
}