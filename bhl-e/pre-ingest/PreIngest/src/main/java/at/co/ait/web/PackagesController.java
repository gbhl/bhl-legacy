package at.co.ait.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import at.co.ait.domain.oais.LogGenericObject;

@Controller
@RequestMapping(value="/packages/*")
public class PackagesController {	
	
	private @Autowired LogGenericObject loggenericobject;
    
	@RequestMapping(value="all", method=RequestMethod.GET)
	@ModelAttribute("packageMap")
	public Map<String,List<String>> getChannels() {
		return loggenericobject.getBag();
	}
}