package at.co.ait.domain.integration;

import java.util.concurrent.Future;

public interface ITaxonFinderGateway {
	Future<String> requestTaxa(String operation);

}
