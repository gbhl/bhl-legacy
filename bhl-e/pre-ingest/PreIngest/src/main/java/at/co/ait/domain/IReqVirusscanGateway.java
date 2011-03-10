package at.co.ait.domain;

import java.util.concurrent.Future;

public interface IReqVirusscanGateway {
	Future<String> requestVirusscan(String absolutePathToFile);
}
