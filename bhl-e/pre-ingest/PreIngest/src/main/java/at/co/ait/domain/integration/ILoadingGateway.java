package at.co.ait.domain.integration;

import java.util.concurrent.Future;

import org.springframework.integration.annotation.Header;

public interface ILoadingGateway {
	void load(Object object, @Header("OBJECT_TYPE") String type);

}
