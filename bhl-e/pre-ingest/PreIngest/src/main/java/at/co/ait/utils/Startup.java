package at.co.ait.utils;

import org.springframework.security.core.context.SecurityContextHolder;

public class Startup {
	public void init() {
		SecurityContextHolder.setStrategyName("MODE_THREADLOCAL");
	}
}
