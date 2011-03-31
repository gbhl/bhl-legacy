package at.co.ait.domain.integration;

import java.util.concurrent.Future;

public interface IReqVirusscanGateway {
	Future<String> requestVirusscan(String absolutePathToFile);
}
