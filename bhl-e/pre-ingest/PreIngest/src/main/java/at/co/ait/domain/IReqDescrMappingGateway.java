package at.co.ait.domain;

import java.util.concurrent.Future;

public interface IReqDescrMappingGateway {
	Future<String> requestDescrMapping(String params);
}
