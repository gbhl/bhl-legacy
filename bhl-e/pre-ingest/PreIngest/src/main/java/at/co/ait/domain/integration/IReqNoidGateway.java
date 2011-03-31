package at.co.ait.domain.integration;

import java.util.concurrent.Future;

public interface IReqNoidGateway {
	Future<String> requestNoid(String operation);

}
