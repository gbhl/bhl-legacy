package at.co.ait.domain.oais;

import java.util.Properties;

/**
 * Metadata contains a multiple Metadate properties which belong to a 
 * DigitalObject or File. The Properties value contains different full
 * text metadata descriptions (e.g. MIX, OCR). 
 * @author sprogerb
 *
 */
public class Metadata {
	
	private Properties _properties = new Properties();
	
	public void setProperty(String key, String value) {
		_properties.setProperty(key, value);
	}
	
	public String getPropertyValue(String key) {
		return _properties.getProperty(key);
	}

}
