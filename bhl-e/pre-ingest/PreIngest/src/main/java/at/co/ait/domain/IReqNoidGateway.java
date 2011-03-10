package at.co.ait.domain;

import java.util.concurrent.Future;

public interface IReqNoidGateway {
	Future<String> requestNoid(String operation);

}
