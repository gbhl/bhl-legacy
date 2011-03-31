package at.co.ait.domain.integration;

import java.util.concurrent.Future;

public interface IReqDescrMappingGateway {
	Future<String> requestDescrMapping(String params);
}
