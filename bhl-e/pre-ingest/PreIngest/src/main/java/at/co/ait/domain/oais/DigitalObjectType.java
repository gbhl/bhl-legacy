package at.co.ait.domain.oais;

public enum DigitalObjectType {	
	
	INFORMATIONPACKAGE(1),
	IMAGE(2),
	METADATA(3),
	PDF(4),
	UNKNOWN(5);
	
	private int index;
	private DigitalObjectType(int idx) {
		this.index = idx;
	}
	
	public Integer getIndex() {
		return index;
	}	
}