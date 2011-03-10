package at.co.ait;


import static org.junit.Assert.*;
import static org.junit.Assert.fail;

import java.io.File;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import at.co.ait.domain.PackageDeliveryService;

public class TestPackageDeliveryService {
	
	private PackageDeliveryService service;

	@Before
	public void setUp() throws Exception {
		AbstractApplicationContext context = 
			new ClassPathXmlApplicationContext("/META-INF/spring/message-server.xml", TestPackageDeliveryService.class);
		service = (PackageDeliveryService) context.getBean("packageDeliveryService");	
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void TestPreparePackage() {

		service.preparePackage(new File("C:/ProjectData/BHL-E-FTP/bhle-csic/v002/full/data"));
		
		fail("not implemented");
	}
	
}
